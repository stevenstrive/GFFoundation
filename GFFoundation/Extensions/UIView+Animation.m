//
//  UIView+Animation.m
//  NewsEarn
//
//  Created by zhubch on 2018/4/10.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView(Animation)

- (void)rotation {
    [self.layer removeAnimationForKey:@"rotation"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 4.0f;
    animation.repeatCount = HUGE_VAL;
    animation.fromValue = @0.0f;
    animation.toValue = @M_PI;
    [self.layer addAnimation:animation forKey:@"rotation"];
}

- (void)rotationY {
    [self.layer removeAnimationForKey:@"rotationY"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.duration = 0.5f;
    animation.removedOnCompletion = YES;
    animation.fromValue = @0.0f;
    animation.toValue = @M_PI;
    animation.repeatCount = HUGE_VAL;
    [self.layer addAnimation:animation forKey:@"rotationY"];
}

- (void)breath {
    [self.layer removeAnimationForKey:@"scale"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    NSArray *rotationVelues = @[@(1), @(1.05), @(1), @(0.95), @(1)];
    animation.values = rotationVelues;
    animation.removedOnCompletion = YES;
    animation.rotationMode = kCAAnimationRotateAuto;  //方向
    animation.duration = 1.0f;
    animation.keyTimes = @[@0 ,@0.25 ,@0.5, @0.75, @1];
    animation.repeatCount = HUGE_VAL;
    [self.layer addAnimation:animation forKey:@"scale"];
}

- (void)floating {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    shake.duration = arc4random() % 3 + 2;
    BOOL up = arc4random() % 2 == 0;
    shake.values = @[
                     @(5 * (up ? -1 : 1)),
                     @(0),
                     @(-5 * (up ? -1 : 1)),
                     @(0),
                     @(5 * (up ? -1 : 1))];
    shake.repeatCount = HUGE_VAL;
    [self.layer addAnimation:shake forKey:@"floating"];
}

- (void)shake {
    [self shake:HUGE_VAL];
}

- (void)shake:(NSUInteger)repeatCount {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.duration = 0.25;
    shake.values = @[
                     @(numToAngle(20)),
                     @(numToAngle(0)),
                     @(numToAngle(-20)),
                     @(numToAngle(0)),
                     @(numToAngle(20))];
    shake.repeatCount = repeatCount;
    [self.layer addAnimation:shake forKey:@"shake"];
}

@end
