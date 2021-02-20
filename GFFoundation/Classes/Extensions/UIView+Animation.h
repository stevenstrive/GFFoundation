//
//  UIView+Animation.h
//  NewsEarn
//
//  Created by zhubch on 2018/4/10.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

#define numToAngle(x) ((x) / 360.0 * (M_PI * 2))

@interface UIView(Animation)

- (void)shake;

- (void)breath;

- (void)floating;

- (void)rotation;

- (void)rotationY;


- (void)shake:(NSUInteger)repeatCount;

@end
