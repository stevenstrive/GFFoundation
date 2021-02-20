//
//  NEBaseWebViewController.m
//  NewsEarn
//
//  Created by zhubch on 2018/8/9.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEBaseWebViewController.h"
#import "NEFoundation.h"
#import <MJRefresh/MJRefresh.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface NEBaseWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, readonly) BOOL changeNavBar;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation NEBaseWebViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    WS(weakSelf);
    RAC(self,title) = [[RACObserve(self.webView,title) map:^id(NSString *value) {
        if (!weakSelf.showCurrentTitle) {
            return nil;
        }
        return value;
    }] ignore:nil];
    [self refreshUI];
    [self refreshData];
    
    [NERouter.sharedRouter openURL:@"ne://js-handler" params:@{@"webView":self.webView} completion:^(NSDictionary *result) {
        [self.webView startBridgeWithDelegate:self jsHandler:result[@"handler"]];
    }];
}

- (void)refreshUI {
//    self.navBar.background.backgroundColor = _RGB(0xB1B809);
//    [self.navBar.backButton setImage:[UIImage imageNamed:@"icon_navbar_back_normal"] forState:UIControlStateNormal];
//    self.navBar.titleLabel.textColor = UIColor.whiteColor;
    self.navBar.line.hidden = NO;
    CGFloat y = self.hideNavBar ? 0 : kNavHeight;
    self.webView.frame = CGRectMake(0, y , self.view.frame.size.width, self.view.frame.size.height - y);
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.changeNavBar ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (self.isMovingToParentViewController) {
        return;
    }

    if (self.reloadWhenAppear && [self canReloadWhenAppear]) {
        [self.webView reload];
    }
}

- (void)dealloc {
    NSLog(@"dealloc %@",self);
    [self.webView stopBridge];
}

- (void)refreshData {
//    [CHHUD showHUDWithView:self.view withTitle:@"加载中..."];
    self.isLoading = YES;
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.strURL]];
    [self.webView loadRequest:request];
}

- (BOOL)shouldBack {
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    if ([self.webView canGoBack]) {
        self.showCloseButton = YES;
        [self.webView goBack];
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, self.view.frame.size.width, self.view.frame.size.height - kNavHeight)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = url.absoluteString ?: @"";
    if (!self.isLoading && [urlString hasPrefix:@"http"]) {
        self.strURL = urlString;
    }
    self.isLoading = YES;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\/\\/itunes\\.apple\\.com\\/" options:0 error:nil];
    if ([regex numberOfMatchesInString:urlString options:0 range:NSMakeRange(0, urlString.length)] > 0) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlString hasPrefix:@"weixin://"]) {//需要替换
        if([[UIApplication sharedApplication] canOpenURL:urlString.asURL]){
            [[UIApplication sharedApplication] openURL:urlString.asURL];
        }
        else {
            [CHHUD HUDWithText:@"未安装微信"];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlString hasPrefix:@"ne://"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [NERouter.sharedRouter openURL:urlString];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [CHHUD hideHUDWithView:self.view];
    self.isLoading = NO;
    [webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [CHHUD hideHUDWithView:self.view];
    self.isLoading = NO;
    [webView.scrollView.mj_header endRefreshing];
}

- (BOOL)canReloadWhenAppear {
    if ([self.strURL hasPrefix:@"http://www.coohua.com/share/xinwenzhuan_help"] || [self.strURL hasPrefix:@"https://www.coohua.com/share/xinwenzhuan_help"]) {
        return NO;
    }
    return YES;
}

@end
