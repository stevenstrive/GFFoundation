//
//  NSDictionary+JSON.h
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(JSON)

@property (readonly) NSString *jsonString;

+ (instancetype)dictionaryWithJSON:(NSString*)json;

- (NSString *)transferKeyValueToUrlStringWithStartSeperator:(NSString *)startSeperator;
@end
