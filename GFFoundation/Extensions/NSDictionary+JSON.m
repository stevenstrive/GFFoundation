//
//  NSDictionary+JSON.m
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary(JSON)

- (NSString *)jsonString {
    NSError *strError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&strError];
    if (strError != nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (instancetype)dictionaryWithJSON:(NSString *)json {
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *strError = nil;
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&strError];
    if (strError != nil) {
        return nil;
    }
    return obj;
}

- (NSString *)transferKeyValueToUrlStringWithStartSeperator:(NSString *)startSeperator {
    if (self.allKeys.count == 0) {
        return @"";
    }
    NSString *string = startSeperator;
    for (int i = 0; i < self.allKeys.count; i ++) {
        NSString *key = self.allKeys[i];
        BOOL isLastKey = (self.allKeys.count  == i + 1);
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@=%@%@", key, [self objectForKey:key], (isLastKey ? @"" : @"&")]];
    }
    return string;
}
@end
