//
//  NEBaseViewController.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/28.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEBaseViewController.h"
#import "NEFoundation.h"

@interface NEBaseViewController ()
@property (nonatomic,strong)UIImageView *bgImg;
@end

@implementation NEBaseViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = _RGB(0xFFF9E6);
    
//    UIImageView *bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_v"]];
//    [self.view insertSubview:bgImg atIndex:0];
//    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, 0, 0));
//    }];
//    _bgImg = bgImg;
    [self loadNavBarIfNeed];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isMovingFromParentViewController) {
        [self viewDidBack];
    }
}

- (void)loadNavBarIfNeed {
    if (_navBar) {
        return;
    }
    _hideBackButton = self.navigationController.viewControllers.count <= 1;
    _navBar = [[NENavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    _navBar.titleLabel.text = self.title;
    _navBar.backButton.hidden = _hideBackButton;
    _navBar.line.hidden = _hideNavLine;
    _navBar.hidden = _hideNavBar;
    [_navBar.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navBar];
}

- (void)setHideNavLine:(BOOL)hideLine {
    _hideNavLine = hideLine;
    _navBar.line.hidden = _hideNavLine;
}

- (void)setTitle:(NSString *)title {
    super.title = title;
    _navBar.titleLabel.text = title;
}

- (void)setHideNavBar:(BOOL)hideNavBar {
    _hideNavBar = hideNavBar;
    _navBar.hidden = _hideNavBar;
}

- (void)setHideBackButton:(BOOL)hideBackButton {
    _hideBackButton = hideBackButton;
    _navBar.backButton.hidden = _hideBackButton;
}

- (void)setShowCloseButton:(BOOL)showCloseButton {
    _showCloseButton = showCloseButton;
    _navBar.closeButton.hidden = !showCloseButton;
    [_navBar.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setHideBgView:(BOOL)hideBgView {
    _hideBgView = hideBgView;
    _bgImg.hidden = hideBgView;
}

- (void)setImageTitle:(NSString *)imageTitle {
    _imageTitle = imageTitle;
    _navBar.titleImgView.image = [UIImage imageNamed:imageTitle];
}

- (BOOL)shouldBack {
    return YES;
}

- (void)back {
    if (self.shouldBack && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidBack {
    
}

@end
