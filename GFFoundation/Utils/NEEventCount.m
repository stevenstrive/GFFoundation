//
//  NEEventCount.m
//  NewsEarn
//
//  Created by CooHua on 2016/12/2.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import "NEEventCount.h"
#import "NEFoundation.h"
#import "SensorsAnalyticsSDK.h"

@implementation NEEventCount

+ (void)dailyAddEvent {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *strOldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"dailyEvent"];
    if (strDate == nil || [strDate isEqualToString:strOldDate] == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:strDate forKey:@"dailyEvent"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)registSALog {
    SAConfigOptions *config = [[SAConfigOptions alloc]initWithServerURL:NEAPI.log launchOptions:nil];
    [SensorsAnalyticsSDK startWithConfigOptions:config];
    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"$device_id" : [NEDeviceInfo.sharedInfo idfa]}];
    [self trackName:@"Startup" dic:@{@"is_bg_awaken" : @0}];
}

+ (void)trackName:(NSString *)name dic:(NSDictionary *)dic {
//#ifdef DEBUG
//    [CHHUD HUDWithText:[NSString stringWithFormat:@"%@\n%@",name,dic.jsonString]];
//    return;
//#endif
    UIDeviceBatteryState batteryState = [[UIDevice currentDevice] batteryState];
    NSInteger isCharging = ((batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull) ? 1 : 2);
    NSInteger batteryLevel = (NSInteger)([[UIDevice currentDevice] batteryLevel] * 100);
    NSInteger isSimulator = (TARGET_IPHONE_SIMULATOR ? 1 : 2);
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"is_charging"] = @(isCharging);
    dicParams[@"battery_level"] = @(batteryLevel);
    dicParams[@"is_simulator"] = @(isSimulator);
    dicParams[@"userId"] = @(NEAPI.user.userId);
    dicParams[@"is_anonymity"] = @(NEAPI.user.anonymousUser);
    dicParams[@"is_charging"] = @(isCharging);
    dicParams[@"battery_level"] = @(batteryLevel);
    dicParams[@"is_simulator"] = @(isSimulator);
    dicParams[@"idfa"] = NEDeviceInfo.sharedInfo.idfa;
    dicParams[@"wechatId"] = NEPackageInfo.shared.wxId;
    dicParams[@"pkgId"] = NEPackageInfo.shared.pkgID;
    dicParams[@"product"] = NEPackageInfo.shared.productName;
    dicParams[@"channel"] = @"ios";
    [dicParams addEntriesFromDictionary:dic];
    [[SensorsAnalyticsSDK sharedInstance] track:name withProperties:dicParams];
#if DEBUG
    [[SensorsAnalyticsSDK sharedInstance] flush];
#endif
}

@end
