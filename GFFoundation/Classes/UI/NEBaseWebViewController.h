//
//  NEBaseWebViewController.h
//  NewsEarn
//
//  Created by zhubch on 2018/8/9.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEBaseViewController.h"
#import "WKWebView+JSBridge.h"

@class NEBaseViewController;

@protocol NEWebViewControllerDelegate <NSObject>

- (void)didOpenPage:(NEBaseViewController*)vc success:(BOOL)success;

- (void)didLeavePage:(NEBaseViewController*)vc duration:(NSTimeInterval)duration;

@end

@interface NEBaseWebViewController : NEBaseViewController

@property (nonatomic, strong) NSString *strURL;
@property (nonatomic, strong) id<NEWebViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL showCurrentTitle;
@property (nonatomic, assign) BOOL reloadWhenAppear;
@property (nonatomic, assign) CGFloat totalLength;
@property (nonatomic, assign) CGFloat maxScrollOffset;
@property (nonatomic, strong) WKWebView *webView;

@end
