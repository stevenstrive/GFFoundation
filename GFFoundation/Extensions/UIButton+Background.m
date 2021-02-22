//
//  UIButton+Background.m
//  NewsEarn
//
//  Created by zhubch on 2018/5/25.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "UIButton+Background.h"
#import "UIImage+Color.h"

@implementation UIButton(Color)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    UIImage *image = [UIImage imageWithColor:color];
    [self setBackgroundImage:image forState: state];
}

- (void)setVerticaColors:(NSArray<UIColor *> *)colors forState:(UIControlState)state {
    UIImage *image = [UIImage imageWithStartColor:colors.firstObject endColor:colors.lastObject gradientType:GradientFromTopToBottom];
    [self setBackgroundImage:image forState: state];
}

- (void)setHorizontalColors:(NSArray<UIColor *> *)colors forState:(UIControlState)state {
    UIImage *image = [UIImage imageWithStartColor:colors.firstObject endColor:colors.lastObject gradientType:GradientFromLeftToRight];
    [self setBackgroundImage:image forState: state];
}

@end
