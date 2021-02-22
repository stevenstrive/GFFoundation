//
//  NSObject+Debug.m
//  NewsEarn
//
//  Created by zhubch on 2018/1/6.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NSObject+Debug.h"
#import "NEFoundation.h"

@implementation NSObject(Debug)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#ifdef DEBUG
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self swizzleSelector:@selector(doesNotRecognizeSelector:) withSwizzledSelector:@selector(debug_doesNotRecognizeSelector:)];
    });
}
#endif

- (void)debug_doesNotRecognizeSelector:(SEL)aSelector {
//    NSLog(@"要崩了");
}

@end

@implementation UIView(Debug)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(addSubview:) withSwizzledSelector:@selector(debug_addSubview:)];
    });
}

- (void)debug_addSubview:(UIView *)view {
    [self debug_addSubview:view];
}

@end
