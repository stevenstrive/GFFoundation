//
//  UIButton+Background.h
//  NewsEarn
//
//  Created by zhubch on 2018/5/25.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NEButtonCommonBG @[_RGB(0xB5C74E), UIColor.main]
#define NEButtonDisableBG @[_RGB(0xB9F6F5), _RGB(0xB9F6F5)]
#define NEButtonTintBG @[_RGB(0xFBE33C), _RGB(0xF9B139)]

@interface UIButton(Color)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

- (void)setHorizontalColors:(NSArray<UIColor*> *)colors
                   forState:(UIControlState)state;

- (void)setVerticaColors:(NSArray<UIColor*> *)colors
                forState:(UIControlState)state;

@end
