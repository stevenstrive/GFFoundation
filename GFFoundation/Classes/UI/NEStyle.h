//
//  NEStyle.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/29.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFontRegular11 UIFont.regular(11)
#define kFontRegular12 UIFont.regular(12)
#define kFontRegular13 UIFont.regular(13)
#define kFontRegular14 UIFont.regular(14)
#define kFontRegular15 UIFont.regular(15)
#define kFontRegular16 UIFont.regular(16)
#define kFontRegular17 UIFont.regular(17)
#define kFontRegular18 UIFont.regular(18)
#define kFontRegular20 UIFont.regular(20)
#define kFontRegular22 UIFont.regular(22)
#define kFontRegular35 UIFont.regular(35)
#define kFontRegular40 UIFont.regular(40)

#define kFontMedium12 UIFont.medium(12)
#define kFontMedium14 UIFont.medium(14)
#define kFontMedium16 UIFont.medium(16)
#define kFontMedium18 UIFont.medium(18)
#define kFontMedium20 UIFont.medium(20)
#define kFontMedium22 UIFont.medium(22)

#define kFontBold12 UIFont.bold(12)
#define kFontBold14 UIFont.bold(14)
#define kFontBold16 UIFont.bold(16)
#define kFontBold18 UIFont.bold(18)
#define kFontBold20 UIFont.bold(20)
#define kFontBold22 UIFont.bold(22)
#define kFontBold41 UIFont.bold(41)
#define kFontBold52 UIFont.bold(52)

@interface NEStyle: NSObject
@property(nonatomic,strong) UIColor             *color;
@property(nonatomic,strong) UIFont              *font;
@property(nonatomic,assign) NSTextAlignment     *alignment;
@end

@interface UIFont(NEStyle)

@property(readonly) UIFont *(^size)(CGFloat);

@property(class,readonly) UIFont*(^thin)(CGFloat);
@property(class,readonly) UIFont*(^regular)(CGFloat);
@property(class,readonly) UIFont*(^bold)(CGFloat);
@property(class,readonly) UIFont*(^medium)(CGFloat);
@property(class,readonly) UIFont*(^name)(NSString*);
@end

@interface UIColor(NEStyle)

@property(class,readonly) UIColor *main;
@property(class,readonly) UIColor *black;
@property(class,readonly) UIColor *gray1;
@property(class,readonly) UIColor *gray2;
@property(class,readonly) UIColor *gray3;
@property(class,readonly) UIColor *grayLine;
@property(class,readonly) UIColor *gray5;
@property(class,readonly) UIColor *gray6;
@property(class,readonly) UIColor *gray7;
@property(class,readonly) UIColor *line;
@property(class,readonly) UIColor *content;
@property(class,readonly) UIColor *subtitle;
@property(class,readonly) UIColor *title;

@end
