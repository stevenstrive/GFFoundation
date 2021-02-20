//
//  NELocationManager.h
//  NewsEarn
//
//  Created by nododo on 2018/3/6.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NELocationManager : NSObject

@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lng;

+ (NELocationManager *)shareManager;

- (void)getLocationCoordinate:(void (^)(NSString *lat, NSString *lng))completionHandler ;

@end
