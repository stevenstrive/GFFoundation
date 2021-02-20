//
//  NEPopupHelper.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/16.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#define kPopUpViewTag 31415926

#import <UIKit/UIKit.h>

static inline void dismiss(UIView *v) {
    if (v.superview.tag != kPopUpViewTag) {
        return;
    }
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         v.y = win.height * 1.5;
                         v.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -1);
                     } completion:^(BOOL finished) {
                         [v.superview removeFromSuperview];
                     }];
}

static inline UIView* presentAutodismissWithOffset(UIView *v, CGFloat offsetY,NSTimeInterval duration) {
    UIView *win = [UIApplication sharedApplication].keyWindow;
    UIView *bg = [[UIView alloc] initWithFrame:win.bounds];
    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    bg.tag = kPopUpViewTag;
    [win addSubview:bg];
    v.centerX = win.centerX;
    v.y = -win.height;
    v.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -1);
    [bg addSubview:v];
    bg.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:14 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         v.centerY = bg.centerY + offsetY;
                         v.transform = CGAffineTransformIdentity;
        bg.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         
                     }];
    if (duration > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dismiss(v);
        });
    }
    return bg;
}

static inline UIView* presentAutodismiss(UIView *v,NSTimeInterval duration) {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIView *bg = [[UIView alloc] initWithFrame:win.bounds];
    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    bg.tag = kPopUpViewTag;
    [win addSubview:bg];
    v.centerX = win.centerX;
    v.y = -win.height;
    v.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -1);
    [bg addSubview:v];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:14 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         v.centerY = bg.centerY;
                         v.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         
                     }];
    if (duration > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dismiss(v);
        });
    }
    return bg;
}

static inline UIView* present(UIView *v) {
    return presentAutodismiss(v, 0);
}
