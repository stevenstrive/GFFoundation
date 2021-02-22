//
//  NSString+NewsEarn.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NSString+NewsEarn.h"
#import "NEFoundation.h"

@implementation NSString(NewsEarn)

- (BOOL)isTelephoneNumber {
    NSString* telNum = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNum length] != 11) {
        return NO;
    }
    return [telNum matches:@"1[\\d]{10}"].count;
}

- (BOOL)checkPhoneNumber {
    if (self.isTelephoneNumber) {
        return YES;
    }
    [CHHUD HUDWithText:@"手机号码格式不正确"];
    return NO;
}

+ (NSString*)getUUIDString {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    if (font == nil ) {
        font = [UIFont systemFontOfSize:14.0];
    }
    
    if (maxSize.width != 0 || maxSize.height != 0){
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
    else {
        return CGSizeZero;
    }
}

+ (NSString *)replaceNullStr:(NSString *)string {
    NSString *al = [string stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    return al;
}

- (NSString *)stringWithUTF8StringEncoding {
    if(self == nil || [self length] == 0){
        return nil;
    }
    NSString *strUTF8 = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return strUTF8;
}

- (CGFloat)widthWithFont:(UIFont *)font {
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(9999, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.width;
}

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width {
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

@end
