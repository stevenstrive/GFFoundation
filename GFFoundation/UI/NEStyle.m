//
//  NEStyle.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/29.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEStyle.h"
#import "NEFoundation.h"

@implementation NEStyle

@end

@implementation UIFont(NEStyle)

+ (UIFont *)ne_systemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight {
    UIFont *font = nil;
    if ([self respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        font = [self systemFontOfSize:fontSize weight:weight];
    } else {
        font = [self systemFontOfSize:fontSize];
    }
    return font ?: [self systemFontOfSize:fontSize];
}

+ (UIFont*(^)(CGFloat))thin {
    return ^(CGFloat size) {
        return [UIFont ne_systemFontOfSize:size weight:UIFontWeightThin];
    };
}

+ (UIFont*(^)(CGFloat))regular {
    return ^(CGFloat size) {
        return [UIFont ne_systemFontOfSize:size weight:UIFontWeightRegular];
    };
}

+ (UIFont*(^)(CGFloat))bold {
    return ^(CGFloat size) {
        return [UIFont ne_systemFontOfSize:size weight:UIFontWeightBold];
    };
}

+ (UIFont*(^)(CGFloat))medium {
    return ^(CGFloat size) {
        return [UIFont ne_systemFontOfSize:size weight:UIFontWeightMedium];
    };
}

+ (UIFont *(^)(NSString *))name {
    return ^(NSString *name) {
        return [UIFont fontWithName:name size:16];
    };
}

- (UIFont *(^)(CGFloat))size {
    return ^(CGFloat size) {
        return [self fontWithSize:size];
    };
}

@end

@implementation UIColor(NEStyle)

+ (UIColor *)main {
    return _RGB(0x8A4509);
}

+ (UIColor *)gray1 {
    return _RGB(0x17181D);
}

+ (UIColor *)gray2 {
    return _RGB(0x323232);
}

+ (UIColor *)gray3 {
    return _RGB(0xe5e5e5);
}

+ (UIColor *)grayLine {
    return _RGB(0xd1d1d1);
}

+ (UIColor *)gray5 {
    return _RGB(0xc7c7c7);
}

+ (UIColor *)gray6 {
    return _RGB(0x8e8e8e);
}

+ (UIColor *)gray7 {
    return _RGB(0xaaaaaa);
}

+ (UIColor *)black {
    return _RGB(0x323232);
}

+ (UIColor *)line {
    return _RGB(0xcccccc);
}

+ (UIColor *)content {
    return _RGB(0xFFFFFF);
}

+ (UIColor *)subtitle {
    return _RGB(0xEA2650);
}

+ (UIColor *)title {
    return _RGB(0x212121);
}

@end
