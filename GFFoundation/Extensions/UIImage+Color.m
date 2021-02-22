//
//  UIImage+Color.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/16.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "UIImage+Color.h"
#import "NEFoundation.h"

@implementation UIImage(Color)

+ (instancetype)imageWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor gradientType:(GradientType)type {
    CGFloat locations[2] = {0,1};
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(startColor.CGColor);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)[@[startColor,endColor] map:^id(UIColor *obj) {
        return (id)obj.CGColor;
    }], locations);
    CGPoint start;
    CGPoint end;
    switch (type) {
        case GradientFromTopToBottom:
            start = CGPointMake(5, 0.0);
            end = CGPointMake(5, 10);
            break;
        case GradientFromLeftToRight:
            start = CGPointMake(0.0, 5);
            end = CGPointMake(10, 5);
            break;
        case GradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(10, 10);
            break;
        case GradientFromLeftBottomToRightTop:
            start = CGPointMake(0.0, 10);
            end = CGPointMake(10, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
