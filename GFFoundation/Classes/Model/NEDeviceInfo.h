//
//  NEDeviceInfo.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/2.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEDeviceInfo : NSObject

@property(nonatomic,readonly) NSString *strUA;
@property(nonatomic,readonly) BOOL isJailBreak;
@property(nonatomic,readonly) NSString *deviceLanguage;
@property(nonatomic,readonly) NSString *strDeviceResolution;
@property(nonatomic,readonly) NSString *strIP;
@property(nonatomic,readonly) NSString *network;
@property(nonatomic,readonly) NSString *tdSign;
@property(nonatomic,readonly) NSString *carrierName;
@property(nonatomic,readonly) NSString *cellIP;
@property(nonatomic,readonly) NSString *idfa;

+ (instancetype)sharedInfo;

@end
