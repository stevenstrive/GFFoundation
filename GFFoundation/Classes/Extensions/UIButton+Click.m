//
//  UIButton+Click.m
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "UIButton+Click.h"
#import <objc/runtime.h>

static const void * btnClickKey = "btnClick:(btnBlock)block";

@implementation UIButton(Click)

- (void)clickAction:(void (^)(UIButton *))action {
    if (action != nil) {
        objc_setAssociatedObject(self, btnClickKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)btnAction:(UIButton *)btn {
    void (^actionBlock)(UIButton *)  = objc_getAssociatedObject(self, btnClickKey);
    actionBlock(btn);
}

@end
