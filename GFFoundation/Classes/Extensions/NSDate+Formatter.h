//
//  NSDate+Formatter.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Copyright (C) 2013 by Christopher Meyer
//  http://schwiiz.org/
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatter)
- (NSString *)dateWithFormat:(NSString *)format;
/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;
@end
