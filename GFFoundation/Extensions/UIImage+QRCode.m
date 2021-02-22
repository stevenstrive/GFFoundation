//
//  UIImage+QRCode.m
//  NewsEarn
//
//  Created by zhubch on 2018/5/17.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "UIImage+QRCode.h"
#import "NSArray+HigherOrder.h"

@implementation UIImage(QRCode)

+ (instancetype)imageWithQRCodeString:(NSString *)str size:(CGSize)size {
    NSData *data = [[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrcodeImage = [filter outputImage];
    
    CGFloat scaleX = size.width / qrcodeImage.extent.size.width;
    CGFloat scaleY = size.height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    return [UIImage imageWithCIImage:transformedImage];
}

- (UIImage *)imageByAddImage:(UIImage *)image targetRect:(CGRect)rect {
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [image drawInRect:rect];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

- (UIImage *)imageByAddQRCode:(NSString *)str targetRect:(CGRect)rect {
    UIImage *qrcodeImage = [UIImage imageWithQRCodeString:str size:rect.size];
    return [self imageByAddImage:qrcodeImage targetRect:rect];
}

@end
