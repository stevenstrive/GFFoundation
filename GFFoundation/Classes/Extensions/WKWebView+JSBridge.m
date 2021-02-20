
//
//  WKWebView+JSBridge.m
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "WKWebView+JSBridge.h"
#import "NEFoundation.h"
#import "WKWebViewJavascriptBridge.h"

@interface WKWebView()
@property (nonatomic,strong) WKWebViewJavascriptBridge *bridge;
@end

@implementation WKWebView(JSBridge)

- (WKWebViewJavascriptBridge *)bridge {
    return objc_getAssociatedObject(self, "bridge");
}

- (void)setBridge:(WKWebViewJavascriptBridge *)bridge {
    objc_setAssociatedObject(self, "bridge", bridge, OBJC_ASSOCIATION_RETAIN);
}

- (void)startBridgeWithDelegate:(id)delegate jsHandler:(id<NEWebViewJSHandler>)jsHandler {
#if DEBUG
    [WKWebViewJavascriptBridge enableLogging];
#endif
    WKWebViewJavascriptBridge *bridge = [WKWebViewJavascriptBridge bridgeForWebView:self];
    [bridge setWebViewDelegate:delegate];
    [bridge registerHandler:@"NEH5CallNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dicData = nil;
        if ([data isKindOfClass:NSString.class]) {
            dicData = [NSDictionary dictionaryWithJSON:data];
        } else if ([data isKindOfClass:NSDictionary.class]) {
            dicData = data;
        }
        NSMutableDictionary *params = [(dicData[@"params"] ?: dicData) mutableCopy];
        NSString *strFunc = dicData[@"func"];
        if (dicData[@"path"]) {
            params[@"path"] = dicData[@"path"];
        }
        [jsHandler handJSCall:strFunc params:params callBack:responseCallback];
    }];
    self.bridge = bridge;
}

- (void)stopBridge {
    self.bridge = nil;
}

- (void)callH5:(NSDictionary *)params completion:(void (^)(id))completion {
    [self.bridge callHandler:@"NENativeCallH5" data:params.jsonString responseCallback:^(id responseData) {
        completion(responseData);
    }];
}

@end
