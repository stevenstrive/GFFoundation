//
//  NSString+URL.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/31.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(URL)

@property (nonatomic,readonly) NSURL *asURL;
@property (nonatomic,readonly) NSString *urlEncoded;
- (NSString*)stringByAppendingQueryParams:(NSDictionary*)params;
@end
