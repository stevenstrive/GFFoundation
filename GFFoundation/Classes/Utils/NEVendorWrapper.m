//
//  NEVendorWapper.m
//  NewsEarn
//
//  Created by zhubch on 2018/8/30.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEVendorWrapper.h"
#import "NEFoundation.h"
#import "WXApi.h"
#import "NEPackageInfo.h"

@interface NEVendorWrapper()
 <WXApiDelegate,WXApiLogDelegate>

@property (nonatomic,copy) void(^loginCompletion)(NSDictionary*);
@property (nonatomic,copy) void(^shareCompletion)(NSDictionary*);
@property (nonatomic,copy) void(^tdSignCompletion)(NSDictionary*);

@end

@implementation NEVendorWrapper

+ (void)load {

    [NERouter.sharedRouter registerURL:@"ne://wx-share" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *)) {
        SendMessageToWXReq *req = [[self sharedWapper] createWXReqWithParams:params];
        req.scene = WXSceneSession;
        [WXApi sendReq:req completion:nil];
        [NEVendorWrapper sharedWapper].shareCompletion = completion;
    }];
    [NERouter.sharedRouter registerURL:@"ne://system-share" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *params)) {
        share(params[@"url"]);
    }];
    [NERouter.sharedRouter registerURL:@"ne://wx-timeline-share" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *)) {
        SendMessageToWXReq *req = [[self sharedWapper] createWXReqWithParams:params];
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req completion:nil];
        [NEVendorWrapper sharedWapper].shareCompletion = completion;
    }];
    [NERouter.sharedRouter registerURL:@"ne://wx-auth" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *)) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = params[@"state"];
        [WXApi sendReq:req completion:nil];
        [NEVendorWrapper sharedWapper].loginCompletion = completion;
    }];

    [NERouter.sharedRouter registerURL:@"ne://open-in-wx" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *)) {
        OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
        req.url = params[@"url"];
        [WXApi sendReq:req completion:nil];
    }];
    
    [NERouter.sharedRouter registerURL:@"ne://td-sign" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *)) {
        if ([NEVendorWrapper sharedWapper].tdSign) {
            completion(@{@"sign":[NEVendorWrapper sharedWapper].tdSign});
        } else {
            [NEVendorWrapper sharedWapper].tdSignCompletion = completion;
        }
    }];
    
    // 稍稍延迟， 以免影响启动时间
    [RACScheduler.mainThreadScheduler afterDelay:0.1 schedule:^{
        [[self sharedWapper] setup];
    }];
}

+ (instancetype)sharedWapper {
    static NEVendorWrapper *wapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wapper = [[self alloc] init];
    });
    return wapper;
}

- (void)onLog:(NSString*)log logLevel:(WXLogLevel)level {
    NSLog(@"%@",log);
}

- (void)setup {
    [WXApi registerApp:NEPackageInfo.shared.wxId universalLink:@"https://www.coohua.com"];
    
    [WXApi startLogByLevel:WXLogLevelNormal logDelegate:self];
}

- (BOOL)handleURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (SendMessageToWXReq*)createWXReqWithParams:(NSDictionary*)params {
    NSString *title = params[@"title"];
    NSString *desc = params[@"desc"];
    NSString *url = params[@"url"];
    UIImage *image = params[@"image"];
    NSString *text = params[@"text"];
    if (text.length) {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = text;
        return req;
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;

    WXImageObject *imgObj = [WXImageObject object];
    imgObj.imageData = UIImagePNGRepresentation(image);

    WXMediaMessage *shareMsg = [WXMediaMessage message];
    shareMsg.title = title;
    shareMsg.description = desc;
    shareMsg.messageExt = nil;
    shareMsg.messageAction = nil;
    shareMsg.mediaTagName = @"ne";
    shareMsg.mediaObject = imgObj;
    if (url.length) {
        shareMsg.mediaObject = ext;
    }
    [shareMsg setThumbImage:[self thumbnailWithImageWithoutScale:image size:CGSizeMake(800, 800)]];

    SendMessageToWXReq *shareReq = [[SendMessageToWXReq alloc] init];
    shareReq.bText = NO;
    shareReq.message = shareMsg;
    return shareReq;
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (void)onResp:(id)response {
    if ([NSStringFromClass([response class]) isEqualToString:@"SendAuthResp"]) { // **** 微信登录授权
        SendAuthResp *resp = response;
        if (self.loginCompletion) {
            self.loginCompletion(@{@"errCode":@(resp.errCode),@"code":resp.code?:@"",@"state":resp.state?:@""});

        }
    }
    else if ([NSStringFromClass([response class]) isEqualToString:@"SendMessageToWXResp"]) { // **** 微信分享
        SendMessageToWXResp *resp = response;
        if (self.shareCompletion) {
            self.shareCompletion(@{@"code":@(resp.errCode)});
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {

}


@end
