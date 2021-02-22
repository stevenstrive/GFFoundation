//
//  CHAttributedString.h
//  CHFoundation
//
//  Created by zhubch on 2017/12/22.
//

#import <Foundation/Foundation.h>

static NSString *numberPattern = @"[\\d\\.]+";

//NSAttributedString的属性集合，方便复用
@interface CHAttributedStyle: NSObject

@property(nonatomic,strong) UIColor             *color;
@property(nonatomic,strong) UIFont              *font;
@property(nonatomic,strong) UIColor             *background;
@property(nonatomic,strong) UIColor             *underline;
@property(nonatomic,strong) UIColor             *middleLine;
@property(nonatomic,strong) NSParagraphStyle    *paragraphStyle;

// 构造style
+ (instancetype)style:(void(^)(CHAttributedStyle *style))maker;

@property(nonatomic,readonly) NSDictionary      *attributes;

@end

static inline NSValue* r(NSUInteger loc, NSUInteger len) {
    return [NSValue valueWithRange:NSMakeRange(loc, len)];
}

@class CHAttributedString;

// 实现CHStringConvertible协议的对象就可以拼接
@protocol CHStringConvertible

@property(nonatomic,readonly) CHAttributedString *attributeString;
@property(nonatomic,readonly) CHAttributedString*(^join)(id<CHStringConvertible>);

@end

//给字符串添加属性
/*
    NSString *text = @"rytfgjhbkjn";
    titleLabel.attributedText = text.set
        .color(UIColor.black)
        .font(kFontRegular16)
        .matches(@"[\\d]+").set
        .color(UIColor.main)
        .done();
*/
@interface CHAttributedString: NSObject<CHStringConvertible>

// set 开始， done 结束
@property(nonatomic,readonly) CHAttributedString* set; // 什么也不干
@property(nonatomic,readonly) NSAttributedString*(^done)(void); // 转NSAttributedString

// 选择要操作的范围
@property(nonatomic,readonly) CHAttributedString*(^range)(NSInteger,NSInteger); // 指定范围
@property(nonatomic,readonly) CHAttributedString*(^matches)(NSString*); // 匹配正则的范围
@property(nonatomic,readonly) CHAttributedString*(^matcheAt)(NSString*,NSUInteger); // 第几个匹配正则的范围
@property(nonatomic,readonly) CHAttributedString* whole; // 全部范围

// 用style对象设置属性
@property(nonatomic,readonly) CHAttributedString*(^style)(CHAttributedStyle*);

// 设置属性
@property(nonatomic,readonly) CHAttributedString*(^color)(UIColor*);
@property(nonatomic,readonly) CHAttributedString*(^background)(UIColor*);
@property(nonatomic,readonly) CHAttributedString*(^font)(UIFont*);
@property(nonatomic,readonly) CHAttributedString*(^paragraphStyle)(NSParagraphStyle*);
@property(nonatomic,readonly) CHAttributedString*(^underline)(UIColor*);
@property(nonatomic,readonly) CHAttributedString*(^middleLine)(UIColor*);
@property(nonatomic,readonly) CHAttributedString*(^baselineOffset)(CGFloat);
@property(nonatomic,readonly) CHAttributedString*(^strokeColor)(UIColor*);

@property(nonatomic,readonly) NSUInteger length;

-(NSAttributedString*)cutWith:(CGSize)maxSize font:(UIFont*)font;

@end

@interface NSString(CHFoundation)<CHStringConvertible>

@property(nonatomic,readonly) CHAttributedString*(^range)(NSInteger,NSInteger);
@property(nonatomic,readonly) CHAttributedString*(^matches)(NSString*);
@property(nonatomic,readonly) CHAttributedString* whole;
@property(nonatomic,readonly) CHAttributedString* set;

- (NSArray<NSValue*>*)matches:(NSString*)expStr;

@end


@interface CHAttributedImage: NSObject<CHStringConvertible>

@property(nonatomic,assign) CGSize             size;
@property(nonatomic,strong) UIImage            *image;
@property(nonatomic,assign) CGFloat            offsetY;

+ (instancetype)imageNamed:(NSString*)name size:(CGSize)size;
+ (instancetype)imageNamed:(NSString*)name size:(CGSize)size offset:(CGFloat)offsetY;
+ (instancetype)empty;

@end



