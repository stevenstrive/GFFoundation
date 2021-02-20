//
//  NEAPIExtensions.m
//  NewsEarn
//
//  Created by zhubch on 2018/4/13.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEAPIExtensions.h"
#import "NEConstants.h"

#define kMallUrl @"https://kaixincantingh5.coohua.com/"
#define kMallUrlTest @"http://www.coohua.top:8009/kaixincantingh5/"

@implementation NEAPI(URL)

+ (NSString *)log {
    return NEAPI.env == kNEHTTPAPITest ? @"http://dcs.coohua.com/data/v1?project=test" : @"http://dcs.coohua.com/data/v1?project=mvp";
}

+ (NSString *)prefixURL {
    return (NEAPI.env == kNEHTTPAPITest ? kMallUrlTest : kMallUrl);
}

+ (NSString *)agreement {
    return [self.prefixURL stringByAppendingPathComponent:@"/agreement.html"];
}

+ (NSString *)privacy {
    return [self.prefixURL stringByAppendingPathComponent:@"/privacy.html"];
}

+ (NSString *)game {
    if (NEAPI.env == kNEHTTPAPIProduction) {
        return @"https://xingfuguoyuangame.coohua.com/index.html";
    }
    return @"http://www.coohua.top:8009/wennuanhuayuan/web-mobile/index.html";
}

+ (NSString *)mall {
    return [self.prefixURL stringByAppendingPathComponent:@"/mall.html"];
}

+ (NSString *)record {
    return [self.prefixURL stringByAppendingPathComponent:@"/record.html"];
}

+ (NSString *)help {
    return [self.prefixURL stringByAppendingPathComponent:@"/help.html"];
}

+ (NSString *)gold {
    return [self.prefixURL stringByAppendingPathComponent:@"/gold.html"];
}

+ (NSString *)championships {
    if (NEAPI.env == kNEHTTPAPIProduction) {
        return @"https://huankuaizouh5.coohua.com/championship/index.html";
    }
    return @"http://www.coohua.top:8502/huankuaizou_championship/web/index.html";
}

+ (NSString *)reward {
    return [self.prefixURL stringByAppendingPathComponent:@"/profit.html"];
}

+ (NSString *)punchCard{
    return [self.prefixURL stringByAppendingPathComponent:@"/punchCard.html"];
}

+ (NSString *)team {
    return @"http://www.coohua.top:8132/huankuaizougame/web-mobile/index.html";
}

+ (NSString *)inviteMall {
    return [self.prefixURL stringByAppendingPathComponent:@"/inviteMall.html"];
}

+ (NSString *)inviteRecord {
    return [self.prefixURL stringByAppendingPathComponent:@"/inviteRecord.html"];
}
@end
