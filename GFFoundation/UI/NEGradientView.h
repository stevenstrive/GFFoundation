//
//  NEGradientView.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/9.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEGradientView : UIButton

@property(nonatomic,assign) CAGradientLayer *gradient;

+ (instancetype)horizontalViewWithFrame:(CGRect)rect startColor:(UIColor*)start endColor:(UIColor*)end;

+ (instancetype)verticalViewWithFrame:(CGRect)rect startColor:(UIColor*)start endColor:(UIColor*)end;

@end
