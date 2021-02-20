//
//  NSObject+Debug.h
//  NewsEarn
//
//  Created by zhubch on 2018/1/6.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject(Debug)
+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;
@end

@interface UIView(Debug)

@end
