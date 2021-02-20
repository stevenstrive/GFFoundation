//
//  UIButton+Click.h
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(Click)

- (void)clickAction:(void(^)(UIButton *sender))action;

@end
