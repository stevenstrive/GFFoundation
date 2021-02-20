//
//  NENavigationController.m
//  NewsEarn
//
//  Created by zhubch on 2018/4/20.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NENavigationController.h"
#import "NEFoundation.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface NENavigationController ()

@end

@implementation NENavigationController


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationController.viewControllers.count == 1) {
        self.isRoot = YES;
    }else {
        self.isRoot = NO;
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count <= 2) {
        self.isRoot = YES;
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    self.isRoot = YES;
    return [super popToRootViewControllerAnimated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRoot = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
