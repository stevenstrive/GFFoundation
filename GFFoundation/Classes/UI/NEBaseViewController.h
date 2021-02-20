//
//  NEBaseViewController.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/28.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NENavigationBar.h"

@interface NEBaseViewController : UIViewController

@property (nonatomic,strong,readonly) NENavigationBar *navBar;

@property (nonatomic,assign) BOOL hideNavLine;

@property (nonatomic,assign) BOOL hideNavBar;
@property (nonatomic,assign) BOOL hideBgView;

@property (nonatomic,copy) NSString *imageTitle;

// 隐藏返回按钮
@property (nonatomic,assign) BOOL hideBackButton;

//显示关闭按钮
@property (nonatomic,assign) BOOL showCloseButton;

// 可以重写这个方法拦截返回事件，默认 return YES;
- (BOOL)shouldBack;

- (void)back;

- (void)viewDidBack;


@end
