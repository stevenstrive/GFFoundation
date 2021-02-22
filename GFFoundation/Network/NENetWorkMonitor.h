//
//  NENetWorkStatus.h
//  NewsEarn
//
//  Created by zhubch on 2018/4/12.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NENetworkType) {
    kNetworkTypeNotReachable = 0,   // **** 无网络连接
    kNetworkTypeMobile,             // **** 移动网络
    kNetworkTypeWifi,               // **** wifi网络
};

@interface NENetWorkStatus : NSObject
@property (nonatomic,assign) NENetworkType type;
@property (nonatomic,strong) NSString *desc;

@end

@interface NENetWorkMonitor : NSObject

+ (instancetype)sharedMonitor;

- (void)start;

@property(nonatomic,readonly) NSString *networkType;

@property(nonatomic,readonly) NSNumber *networkTypeNumber;

@property(nonatomic,readonly) NENetWorkStatus *netWorkStatus;

@end
