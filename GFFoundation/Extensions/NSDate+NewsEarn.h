//
//
//  TTBaseNavController.h
//  SameRoad
//
//  Created by Mac on 15-5-13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDate (Tool)

/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;

/* 时间戳 */
- (NSString *)timestamp;

/** 返回一个只有年月日的时间 */
- (NSDate *)dateWithYMD;

/**
 将日期类型的NSString转换成NSDate
 @param string 生成的
 @param format "yyyy-MM-dd HH:mm:ss.SSS" 字符串类型
 @return 返回NSDate对象
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

/**
 将时间戳转换成指定格式日期字符串
 @param timestamp 时间戳
 @param format 日期格式  “yyyy-MM-dd HH:mm:ss.S”
 @return 格式化的str
 */
+ (NSString *)dateWithTimestamp:(NSTimeInterval)timestamp dateFormat:(NSString *)format;

+ (NSString *)currentDay;

+ (NSString *)currentMonth;

+ (NSString *)currentYear;

@end

