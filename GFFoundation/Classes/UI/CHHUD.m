//
//  CHHUD.m
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "CHHUD.h"

@implementation CHHUD

+ (void)HUDWithText:(NSString *)strText {
    [self HUDWithText:strText afterDelay:2];
}

#pragma mark - Show without hide automatic

+ (void)showHUDWithView:(UIView *)curView {
    [self showHUDWithView:curView withTitle:nil];
}

+ (void)showHUDWithView:(UIView *)curView withTitle:(NSString *)strTitle {
    CHHUD *hud = [CHHUD showHUDAddedTo:curView animated:YES];
    hud.labelText = strTitle;
}

+ (void)hideHUDWithView:(UIView *)curView {
    [CHHUD hideHUDForView:curView animated:YES];
}

+ (void)HUDWithText:(NSString *)strText afterDelay:(NSInteger)delay {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [CHHUD showHUDAddedTo:keyWindow animated:YES];
    HUD.userInteractionEnabled = NO;
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabel.text = strText;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.contentColor = UIColor.whiteColor;
    HUD.bezelView.color = [UIColor blackColor];
    HUD.alpha = 0.85;
    [HUD hideAnimated:YES afterDelay:delay];

}
@end

