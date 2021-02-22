//
//  NSString+Base64.h
//  testFoundation
//
//  Created by apple on 2017/2/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

/**
 base64编码转换
 @param string 字符串
 @return 转换后的Base64字符串
 */
+ (NSString *)stringWithBase64EncodedString:(NSString *)string;

/**
 编码成BASE64
 @return 编码后的字符串
 */
- (NSString *)base64EncodedString;

/**
 解码Base64编码
 @return 解码后的string
 */
- (NSString *)base64DecodedString;

/**
 将解码后的string 转换成 NSData
 @return 解码后的字符串
 */
- (NSData *)base64DecodedData;


@end
