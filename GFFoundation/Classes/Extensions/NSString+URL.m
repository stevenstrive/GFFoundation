//
//  NSString+URL.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/31.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString(URL)

- (NSString *)stringByAppendingQueryParams:(NSDictionary *)params {
    if ([self hasSuffix:@"#/"]) {
        return self;
    }
    if (params.count == 0) {
        return self;
    }
    
    NSMutableString *paramsString = @"".mutableCopy;
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [paramsString appendFormat:@"%@=%@&",key,obj];
    }];
    if ([paramsString hasSuffix:@"&"]) {
        [paramsString deleteCharactersInRange:NSMakeRange(paramsString.length - 1, 1)];
    }
    if ([self containsString:@"?"]) {
        return [self stringByAppendingFormat:@"&%@",paramsString.urlEncoded];
    }
    return [self stringByAppendingFormat:@"?%@",paramsString.urlEncoded];
}

- (NSString*)urlEncoded {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSURL *)asURL {
    return [NSURL URLWithString:self];
}

@end
