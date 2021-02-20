//
//  TTBaseNavController.h
//  SameRoad
//
//  Created by Mac on 15-5-13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NSDate+NewsEarn.h"

@implementation NSDate(Tool)

/**
 *  是否为今天
 */
- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday {
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

/* 时间戳 */
- (NSString *)timestamp {
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval*1000];
    return [timeString copy];
}

/** 返回一个只有年月日的时间 */
- (NSDate *)dateWithYMD {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSString *)dateWithTimestamp:(NSTimeInterval)timestamp dateFormat:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:format];
    NSString *dateStr = [inputFormatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)currentDay {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    return [NSString stringWithFormat:@"%02ld", [dateComponent day]];
}

+ (NSString *)currentMonth {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    return [NSString stringWithFormat:@"%02ld", [dateComponent month]];
}

+ (NSString *)currentYear {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    return [NSString stringWithFormat:@"%zd", [dateComponent year]];
}


@end
