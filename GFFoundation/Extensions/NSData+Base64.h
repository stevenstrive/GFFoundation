//
//  NSData+Base64.h
//  testFoundation
//
//  Created by apple on 2017/2/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)


/**
 将string转换成base64编码

 @param string 原字符串
 @return 转换后的NSData
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;


/**
 Base64编码

 @param wrapWidth 位宽
 @return 转换后的Base64字符串
 */
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;


/**
 base64转码

 @return 默认位宽64位
 */
- (NSString *)base64EncodedString;


@end
