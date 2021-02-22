//
//  NENavigationBar.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/28.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NENavigationBar : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong, readonly) UIButton *backButton;

@property (nonatomic, strong, readonly) UIButton *closeButton;

@property (nonatomic, strong, readonly) UIImageView *titleImgView;

@property (nonatomic, strong, readonly) UIView *line;

@property (nonatomic, strong, readonly) UIView *background;

@end
