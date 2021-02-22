//
//  NEAlert.h
//  NewsEarn
//
//  Created by zhubch on 2018/5/24.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHAttributedString;

typedef enum : NSUInteger {
    NEAlertStyleDefaultClose, // 右上方有关闭按钮
    NEAlertStyleBottomClose,// 底部有关闭按钮
    NEAlertStyleNoneClose,// 没有关闭按钮
    NEAlertStyleOverlayer, // 底部有关闭按钮,Alert上有遮罩，只能点击整个Alert
} NEAlertStyle;

typedef enum : NSUInteger {
    NEAlertTitleStyleHorizontal,
    NEAlertTitleStyleVertical,
} NEAlertTitleStyle;

@interface NEAlert : UIView

@property (nonatomic,strong) UIButton *closeBtn;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 showCloseBtn:(BOOL)showCloseBtn
                    btnTitles:(NSString *)titles,...NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 showCloseBtn:(BOOL)showCloseBtn
                   titleStyle:(NEAlertTitleStyle)style
                    btnTitles:(NSString *)titles,...NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithAttrTitle:(CHAttributedString *)title
                      attrMessage:(CHAttributedString *)message
                     showCloseBtn:(BOOL)showCloseBtn
                        btnTitles:(NSString *)titles,...NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithAttrTitle:(CHAttributedString *)title
                      attrMessage:(CHAttributedString *)message
                        noMoreAsk:(NSUInteger)tag
                        btnTitles:(NSString *)titles,...NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithImage:(UIImage*)image;

- (instancetype)initWithImage:(UIImage*)image size:(CGSize)size;

- (instancetype)initWithCustomView:(UIView*)view style:(NEAlertStyle)style size:(CGSize)size;

- (void)show;

- (void)hide;

- (void)showWithClickBlock:(void(^)(NSUInteger buttonIndex))clickBlock;

// 直接移除所有Alert，无动画
+ (void)removeAll;

@end
