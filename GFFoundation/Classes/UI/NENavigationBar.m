//
//  NENavigationBar.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/28.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NENavigationBar.h"
#import "NEFoundation.h"

@implementation NENavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _background = [[UIView alloc] initWithFrame:self.bounds];
        _background.backgroundColor = UIColor.clearColor;
//        _background.layer.shadowColor = _RGB(0x2B6598).CGColor;
//        _background.layer.shadowOffset = CGSizeMake(0, 2);
//        _background.layer.shadowOpacity = 0.2;
        [self addSubview:_background];
        
        UIImageView *navBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        navBg.contentMode = UIViewContentModeScaleAspectFill;
        navBg.image = [UIImage imageNamed:@"nav_bg"];
        [self addSubview:navBg];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, kStatusBarHeight, kScreenWidth - 200, 44)];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = kFontBold18;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 105) *0.5, kStatusBarHeight, 90, 34)];
        _titleImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_titleImgView];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back_btn_icon"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(14, kStatusBarHeight - 6, 48, 48);
        [self addSubview:_backButton];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _closeButton.frame = CGRectMake(14 + 44 , kStatusBarHeight, 50, 44);
        [self addSubview:_closeButton];
        _closeButton.hidden = YES;
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight - 0.5, kScreenWidth, 0.5)];
        _line.backgroundColor = UIColor.clearColor;
        [self addSubview:_line];
        
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

@end
