//
//  NSString+NewsEarn.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(NewsEarn)

@property(readonly) BOOL isTelephoneNumber;


- (BOOL)checkPhoneNumber;

/**
 计算文字宽高
 
 @param font 字体
 @param maxSize 最大Size
 @return 计算好的Size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 去除(null)
 @param string 源字符串
 @return 移除后的string
 */
+ (NSString *)replaceNullStr:(NSString *)string;


/**
 对NSString对象做UTF8Encoding
 
 @return UTF8Encoding后的NSString对象
 */
- (NSString *)stringWithUTF8StringEncoding;

/**
 计算NSString对象一行的宽度
 
 @return NSString对象一行的宽度
 */
- (CGFloat)widthWithFont:(UIFont *)font;

/**
计算NSString对象固定宽度时的高度

@return NSString对象固定宽度时的高度
*/
- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width;


@end
