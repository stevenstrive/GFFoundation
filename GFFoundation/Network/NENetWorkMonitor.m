//
//  NENetWorkStatus.m
//  NewsEarn
//
//  Created by zhubch on 2018/4/12.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NENetWorkMonitor.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "NEFoundation.h"
#import <AFNetworking/AFNetworking.h>

@implementation NENetWorkMonitor

+ (instancetype)sharedMonitor {
    static NENetWorkMonitor* monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[self alloc] init];
    });
    return monitor;
}

- (NSString *)networkType {
    CTTelephonyNetworkInfo *netInfo =  [[CTTelephonyNetworkInfo alloc] init];
    NSString *type = @"";
    if ([netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        type = @"4G";
    }
    else if ([netInfo.currentRadioAccessTechnology isEqualToString: CTRadioAccessTechnologyGPRS] ||
             [netInfo.currentRadioAccessTechnology isEqualToString: CTRadioAccessTechnologyEdge] ||
             [netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x] ) {
        type = @"2G";
    }
    else if ([netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]
             || [netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]
             || [netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]
             || [netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]
             || [netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]
             || [netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]
             || [netInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        type = @"3G";
    }
    else {
        type = @"无";
    }
    return type;
}

- (void)start {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NENetWorkStatus *neStatus = [[NENetWorkStatus alloc] init];
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                neStatus.type = kNetworkTypeNotReachable;
                neStatus.desc = @"无网络连接";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                neStatus.type = kNetworkTypeMobile;
                neStatus.desc = @"移动网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                neStatus.type = kNetworkTypeWifi;
                neStatus.desc = @"wifi网络";
                break;
            default:
                break;
        }
        [self updateStatus:neStatus];
    }];
}

- (void)updateStatus:(NENetWorkStatus*)status {
    _netWorkStatus = status;
    if (status.type == kNetworkTypeWifi) {
        return;
    }
    if (status.type == kNetworkTypeNotReachable) {
        [CHHUD HUDWithText:@"您的网络不给力，请检查网络设置"];
        return;
    }

    BOOL isShowImgSettingTip = [NSUserDefaults readBoolForKey:@"isShowImgSettingTipKey"];
    BOOL isNeedShowImgSettingTip = [NSUserDefaults readBoolForKey:@"isNeedShowImgSettingTipsKey"];
    
    if (isShowImgSettingTip == NO && isNeedShowImgSettingTip == NO) {
        [NSUserDefaults saveBool:YES forKey:@"isShowImgSettingTipKey"];
        [NSUserDefaults saveDouble:[[[NSDate date] timestamp] doubleValue] forKey:@"imgSettingTipTime"];
    }
    else if ([[[NSDate date] timestamp]doubleValue] > [NSUserDefaults readDoubleForKey:@"imgSettingTipTime"] && isNeedShowImgSettingTip == NO) {
        [NSUserDefaults saveBool:NO forKey:@"isShowImgSettingTipKey"];
        [NSUserDefaults saveDouble:[[[NSDate date] timestamp] doubleValue] + 7 * 24 * 60 * 60.0 forKey:@"imgSettingTipTime"];
    }
}

- (NSNumber*)networkTypeNumber {
    if (_netWorkStatus.type == kNetworkTypeWifi) {
        return @5;
    }
    else if (_netWorkStatus.type == kNetworkTypeNotReachable) {
        return @0;
    }
    else {
        if ([self.networkType isEqualToString:@"2G"]) {
            return @1;
        }
        else if ([self.networkType  isEqualToString:@"3G"]) {
            return @2;
        }
        else if ([self.networkType  isEqualToString:@"4G"]) {
            return @3;
        }
        else {
            return @(-1);
        }
    }
}

@end

@implementation NENetWorkStatus
@end
