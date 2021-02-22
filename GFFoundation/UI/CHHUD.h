//
//  CHHUD.h
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface CHHUD : MBProgressHUD

#pragma mark - Show with hide automatic

+ (void)HUDWithText:(NSString *)strText;

#pragma mark - Show without hide automatic

+ (void)showHUDWithView:(UIView *)curView;
+ (void)showHUDWithView:(UIView *)curView withTitle:(NSString *)strTitle;

+ (void)hideHUDWithView:(UIView *)curView;

+ (void)HUDWithText:(NSString *)strText afterDelay:(NSInteger)delay;

@end
