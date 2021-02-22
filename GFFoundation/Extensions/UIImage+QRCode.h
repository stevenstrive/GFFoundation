//
//  UIImage+QRCode.h
//  NewsEarn
//
//  Created by zhubch on 2018/5/17.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(QRCode)

// 创建二维码图片
+ (instancetype)imageWithQRCodeString:(NSString*)str size:(CGSize)size;

// 添加图片
- (UIImage*)imageByAddImage:(UIImage*)image targetRect:(CGRect)rect;

// 添加二维码
- (UIImage*)imageByAddQRCode:(NSString*)str targetRect:(CGRect)rect;

@end
