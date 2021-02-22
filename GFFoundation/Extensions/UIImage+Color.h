//
//  UIImage+Color.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/16.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GradientType) {
    GradientFromTopToBottom = 1,            //从上到下
    GradientFromLeftToRight,                //从做到右
    GradientFromLeftTopToRightBottom,
    GradientFromLeftBottomToRightTop        
};

@interface UIImage(Color)

+ (instancetype)imageWithColor:(UIColor*)color;

+ (instancetype)imageWithStartColor:(UIColor *)start endColor:(UIColor*)end gradientType:(GradientType)type;

@end

