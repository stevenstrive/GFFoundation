//
//  NEAPIExtensions.h
//  NewsEarn
//
//  Created by zhubch on 2018/4/13.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEAPIDefine.h"

@interface NEAPI(URL)

@property(class,readonly) NSString *log;

@property(class,readonly) NSString *prefixURL;

@property(class,readonly) NSString *mall;//tx
@property(class,readonly) NSString *record;//tx
@property(class,readonly) NSString *privacy;
@property(class,readonly) NSString *agreement;
@property(class,readonly) NSString *game;
@property(class,readonly) NSString *gold;
@property(class,readonly) NSString *help;
@property(class,readonly) NSString *championships;
@property(class,readonly) NSString *reward;
@property(class,readonly) NSString *punchCard;
@property(class,readonly) NSString *team;
@property(class,readonly) NSString *inviteMall;
@property(class,readonly) NSString *inviteRecord;
@end
