//
//  NERouter.m
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NERouter.h"
#import "NEFoundation.h"
#import "NEAPI.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation NEBlockTarget

+ (instancetype)targetForSimpleBlock:(SimpleBlock)block {
    CompleteBlock _block = ^(NSString *url,NSDictionary* params,void(^completion)(NSDictionary*)) {
        block(url,params);
        completion(nil);
    };
    return [self targetForCompleteBlock:_block];
}

+ (instancetype)targetForCompleteBlock:(CompleteBlock)block {
    NEBlockTarget *target = [[self alloc] init];
    target.block = block;
    return target;
}

- (void)openFromURL:(NSString *)url withParams:(NSDictionary *)params completion:(void (^)(NSDictionary *))completion {
    self.block(url, params, completion);
}

@end

@interface NERouter()
@property (nonatomic,strong) NSMutableDictionary *registerTable;
@end

@implementation NERouter

+ (instancetype)sharedRouter {
    static dispatch_once_t onceToken;
    static NERouter *router = nil;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}

- (instancetype)init {
    if (self = [super init]) {
        _registerTable = @{}.mutableCopy;
        [self registerURL:@"ne://open-webpage" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *)) {
            [self openURL:params[@"url"] webTitle:params[@"title"]];
        }];
        [self registerURL:@"ne://open-web-no-actionbar" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *)) {
            [self openURL:params[@"url"] webTitle:params[@"title"] hideNavBar:YES];
        }];
    }
    return self;
}

- (NSArray *)allRegisteredURLs {
    return self.registerTable.allKeys;
}

- (void)registerURL:(NSString *)url forTarget:(id<NERouterTarget>)target {
    NSString *realURL = [url componentsSeparatedByString:@"?"].firstObject.lowercaseString;
    if (self.registerTable[realURL]) {
        NSLog(@"WARNING: Duplicate URL%@",realURL);
    }
    self.registerTable[realURL] = target;
}

- (void)registerURL:(NSString *)url forBlock:(void (^)(NSDictionary *, void (^)(NSDictionary *)))block {
    NEBlockTarget *target = [NEBlockTarget targetForCompleteBlock:^(NSString *url, NSDictionary *params, void (^completion)(NSDictionary *)) {
        block(params,completion);
    }];
    [self registerURL:url forTarget:target];
}

- (void)registerURL:(NSString *)url forViewControllerClass:(Class)clazz {
    if (![clazz isSubclassOfClass:UIViewController.class]) {
        NSLog(@"WARNING: %@ is NOT subclass of UIViewController",NSStringFromClass(clazz));
    }
    NEBlockTarget *target = [NEBlockTarget targetForCompleteBlock:^(NSString *url, NSDictionary *params, void (^completion)(NSDictionary *)) {
        NSObject<NERouterTarget> *obj = [[clazz alloc] init];
        if ([obj respondsToSelector:@selector(openFromURL:withParams:completion:)]) {
            [obj openFromURL:url withParams:params completion:completion];
        }
        if ([obj isKindOfClass:UIViewController.class]) {
            [UIViewController.topMost.navigationController pushViewController:(UIViewController*)obj animated:YES];
        }
    }];
    [self registerURL:url forTarget:target];
}

- (void)unregisterURL:(NSString *)url {
    NSString *realURL = [url componentsSeparatedByString:@"?"].firstObject.lowercaseString;
    self.registerTable[realURL] = nil;
}

- (BOOL)canOpen:(NSString *)url {
    if ([url hasPrefix:@"http"]) {
        return YES;
    }
    NSString *realURL = [url componentsSeparatedByString:@"?"].firstObject.lowercaseString;
    return self.registerTable[realURL] != nil;
}

- (BOOL)openURL:(NSString *)url {
    return [self openURL:url params:nil];
}

- (BOOL)openURL:(NSString *)url params:(NSDictionary *)params {
    return [self openURL:url params:params completion:nil];
}

- (BOOL)openURL:(NSString *)url webTitle:(NSString *)webTitle {
    [self openURL:url webTitle:webTitle hideNavBar:NO];
    return YES;
}

- (BOOL)openURL:(NSString *)url webTitle:(NSString *)webTitle hideNavBar:(BOOL)hideNavBar {
    NSString *urlStr = [url.stringByRemovingPercentEncoding stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NEBaseWebViewController *webVC = [[NEBaseWebViewController alloc] init];
    NSMutableDictionary *params = gernalParams();
    urlStr = [urlStr stringByAppendingQueryParams:params];
    webVC.strURL = urlStr;
    webVC.reloadWhenAppear = NO;
    webVC.title = webTitle;
    webVC.showCurrentTitle = webTitle.length == 0;
    webVC.hideNavBar = hideNavBar;
    [UIViewController.topMost.navigationController pushViewController:webVC animated:YES];
    NSLog(@"open webPage %@",urlStr);
    return YES;
}

- (BOOL)openURL:(NSString *)url webTitle:(NSString *)webTitle hideNavBar:(BOOL)hideNavBar extraParams:(NSDictionary *)extraParams {
    NSString *urlStr = [url.stringByRemovingPercentEncoding stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NEBaseWebViewController *webVC = [[NEBaseWebViewController alloc] init];
    NSMutableDictionary *params = gernalParams();
    [params addEntriesFromDictionary:extraParams];
    urlStr = [urlStr stringByAppendingQueryParams:params];
    webVC.strURL = urlStr;
    webVC.reloadWhenAppear = NO;
    webVC.title = webTitle;
    webVC.showCurrentTitle = webTitle.length == 0;
    webVC.hideNavBar = hideNavBar;
    [UIViewController.topMost.navigationController pushViewController:webVC animated:YES];
    NSLog(@"open webPage %@",urlStr);
    return YES;
}

- (BOOL)openURL:(NSString *)url params:(NSDictionary *)params completion:(void (^)(NSDictionary *))completion {
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\t "]];
    if ([url hasPrefix:@"http"]) {
        return [self openURL:url webTitle:nil];
    }
    NSString *realURL = [url componentsSeparatedByString:@"?"].firstObject.lowercaseString;
    id<NERouterTarget> target = self.registerTable[realURL];
    if (!target) {
        NSLog(@"WARNING: Not found target for URL:%@",url);
        return NO;
    }
    if ([target respondsToSelector:@selector(openFromURL:withParams:completion:)]) {
        NSMutableDictionary *urlParams = [self getURLParameters:url] ?: @{}.mutableCopy;
        [urlParams addEntriesFromDictionary:params];
        [target openFromURL:realURL withParams:urlParams completion:completion ?:^(NSDictionary*dic){}];
    }
    return YES;
}

- (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    if ([parametersString containsString:@"&"]) {

        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                [params setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        if (pairComponents.count == 1) {
            return nil;
        }
        
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        if (key == nil || value == nil) {
            return nil;
        }
        
        [params setValue:value forKey:key];
    }
    return params;
}

@end
