//
//  NEGradientView.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/9.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEGradientView.h"

@implementation NEGradientView

+ (instancetype)horizontalViewWithFrame:(CGRect)rect startColor:(UIColor *)start endColor:(UIColor *)end {
    NEGradientView *view = [[self alloc] initWithFrame:rect];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)start.CGColor,
                       (id)end.CGColor, nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1.0, 0);
    [view.layer addSublayer:gradient];
    view.gradient = gradient;
    return view;
}

+ (instancetype)verticalViewWithFrame:(CGRect)rect startColor:(UIColor *)start endColor:(UIColor *)end {
    NEGradientView *view = [[self alloc] initWithFrame:rect];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)start.CGColor,
                       (id)end.CGColor, nil];
    [view.layer addSublayer:gradient];
    return view;
}

@end
