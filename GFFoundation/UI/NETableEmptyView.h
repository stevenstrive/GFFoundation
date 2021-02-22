//
//  NETableEmptyView.h
//  NewsEarn
//
//  Created by zhubch on 2018/5/28.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NETableEmptyView : UIView

@property (nonatomic,assign) NSUInteger offset;
@property (nonatomic,strong) NSString *buttonTitle;
@property (nonatomic,strong) NSString *descTitle;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy)  void(^reload)(void);

- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset;

@end
