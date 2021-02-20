//
//  WKWebView+JSBridge.h
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <WebKit/WebKit.h>

@class WebViewJavascriptBridge;

@protocol NEWebViewJSHandler<NSObject>

- (void)handJSCall:(NSString*)func params:(NSDictionary*)params callBack:(void (^)(id responseData))responseCallback;

@end

@interface WKWebView(JSBridge)

- (void)startBridgeWithDelegate:(id)delegate jsHandler:(id<NEWebViewJSHandler>)jsHandler;

- (void)stopBridge;

- (void)callH5:(NSDictionary*)params completion:(void(^)(id response))completion;

@end
