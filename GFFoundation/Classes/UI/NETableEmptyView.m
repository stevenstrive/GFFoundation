//
//  NETableEmptyView.m
//  NewsEarn
//
//  Created by zhubch on 2018/5/28.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NETableEmptyView.h"
#import "NEFoundation.h"

@implementation NETableEmptyView
{
    UIImageView *imgView;
    UILabel *descLabel;
    UIButton *reloadButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame offset:106];
}

- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset {
    if (self = [super initWithFrame:frame]) {
        [self setupWithOffset:offset];
    }
    return self;
}

- (void)setupWithOffset:(CGFloat)offset {
    self.backgroundColor = UIColor.whiteColor;
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 287) * 0.5, offset, 287, 152)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imgView];
    
    descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offset + 171, kScreenWidth, 20)];
    descLabel.textColor = UIColor.black;
    descLabel.font = kFontRegular16;
    descLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:descLabel];
    
    reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(20, offset + 220, kScreenWidth - 40, 50)];
    reloadButton.hidden = YES;
    reloadButton.cornerRadius = 25;
    [reloadButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    reloadButton.titleLabel.font = kFontMedium18;
    [reloadButton setHorizontalColors:NEButtonCommonBG forState:UIControlStateNormal];
    WS(weakSelf);
    [reloadButton clickAction:^(UIButton *sender) {
        if (weakSelf.reload) {
            weakSelf.reload();
        }
    }];
    [self addSubview:reloadButton];
}

- (void)setDescTitle:(NSString *)descTitle {
    descLabel.text = descTitle;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    reloadButton.hidden = buttonTitle.length == 0;
    [reloadButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image {
    imgView.image = image;
}

@end
