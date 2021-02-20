//
//  NEEventCount.h
//  NewsEarn
//
//  Created by CooHua on 2016/12/2.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEEventCount : NSObject

+ (void)dailyAddEvent;

+ (void)registSALog;
+ (void)trackName:(NSString *)name dic:(NSDictionary *)dic;

@end


