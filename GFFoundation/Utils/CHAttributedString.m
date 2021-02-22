//
//  CHAttributedString.m
//  CHFoundation
//
//  Created by zhubch on 2017/12/22.
//

#import "CHAttributedString.h"
#import "NEFoundation.h"

@implementation CHAttributedStyle

+ (instancetype)style:(void (^)(CHAttributedStyle *))maker {
    CHAttributedStyle *style = [[self alloc] init];
    maker(style);
    return style;
}

- (NSDictionary *)attributes {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    if (_font) {
        [attrs setObject:_font forKey:NSFontAttributeName];
    }
    if (_color) {
        [attrs setObject:_color forKey:NSForegroundColorAttributeName];
    }
    if (_background) {
        [attrs setObject:_background forKey:NSBackgroundColorAttributeName];
    }
    if (_underline) {
        [attrs setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
        [attrs setObject:_underline forKey:NSUnderlineColorAttributeName];
    }
    if (_paragraphStyle) {
        [attrs setObject:_paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    return attrs;
}

@end

@interface CHAttributedString ()

@property (nonatomic,strong) NSArray<NSValue*>* ranges;
@property (nonatomic,strong) NSMutableAttributedString *attrStr;

@end

@implementation CHAttributedString

- (instancetype)initWithString:(NSString *)str{
    if (self = [super init]) {
        self.attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    }
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr {
    if (self = [super init]) {
        self.attrStr = attrStr.mutableCopy;
    }
    return self;
}

- (NSUInteger)length {
    return self.attrStr.length;
}

- (CHAttributedString *(^)(NSInteger, NSInteger))range {
    return ^(NSInteger loc, NSInteger len) {
        self.ranges = @[r(loc,len)];
        return self;
    };
}

- (CHAttributedString *)whole {
    self.ranges = @[r(0, self.attrStr.length)];
    return self;
}

- (CHAttributedString *(^)(NSString *))matches {
    return ^(NSString *expStr) {
        self.ranges = [self.attrStr.string matches:expStr];
        return self;
    };
}

- (CHAttributedString *(^)(NSString *, NSUInteger))matcheAt {
    return ^(NSString *expStr, NSUInteger idx) {
        NSArray *ranges = [self.attrStr.string matches:expStr];
        if (idx < ranges.count) {
            self.ranges = @[ranges[idx]];
        } else {
            self.ranges = @[];
        }
        return self;
    };
}

- (CHAttributedString *)set {
    if (_ranges == nil) {
        self.ranges = @[r(0, self.attrStr.length)];
    }
    return self;
}

- (CHAttributedString *(^)(NSParagraphStyle *))paragraphStyle {
    return ^(NSParagraphStyle *paragraphStyle) {
        return [self addAttributes:@{
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     }];
    };
}

- (CHAttributedString *(^)(CHAttributedStyle *))style {
    return ^(CHAttributedStyle *style) {
        return [self addAttributes:style.attributes];
    };
}

- (CHAttributedString *(^)(UIColor *))color {
    return ^(UIColor *color) {
        if (color == nil) {
            return self;
        }
        return [self addAttributes:@{NSForegroundColorAttributeName:color}];
    };
}

- (CHAttributedString *(^)(UIFont *))font {
    return ^(UIFont *font) {
        if (font == nil) {
            return self;
        }
        return [self addAttributes:@{NSFontAttributeName:font}];
    };
}

- (CHAttributedString *(^)(UIColor *))background {
    return ^(UIColor *color) {
        if (color == nil) {
            return self;
        }
        return [self addAttributes:@{NSBackgroundColorAttributeName:color}];
    };
}

- (CHAttributedString *(^)(UIColor*))underline {
    return ^(UIColor *color) {
        if (color == nil) {
            return self;
        }
        return [self addAttributes:@{
                              NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                              NSUnderlineColorAttributeName:color
                              }];
    };
}

- (CHAttributedString *(^)(UIColor *))middleLine {
    return ^(UIColor *color) {
        if (color == nil) {
            return self;
        }
        return [self addAttributes:@{
                                     NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                                     NSStrikethroughStyleAttributeName:color
                                     }];
    };
}

- (CHAttributedString *(^)(CGFloat))baselineOffset {
    return ^(CGFloat offset) {
        return [self addAttributes:@{
                                     NSStrokeColorAttributeName:@(offset),
                                     }];
    };
}

- (CHAttributedString *(^)(UIColor *))strokeColor {
    return ^(UIColor *color) {
        if (color == nil) {
            return self;
        }
        return [self addAttributes:@{NSStrokeWidthAttributeName:@(1),
                                     NSBaselineOffsetAttributeName:color,
                                     }];
    };
}

- (NSAttributedString *(^)(void))done {
    return ^(){
        return self.attrStr;
    };
}

- (CHAttributedString *)attributeString {
    return self;
}

- (CHAttributedString *)addAttributes:(NSDictionary*)attrs {
    for (NSValue *range in self.ranges) {
        [self.attrStr addAttributes:attrs
                              range:range.rangeValue];
        
    }
    return self;
}

- (CHAttributedString *(^)(id<CHStringConvertible>))join {
    return ^(id<CHStringConvertible> chStr) {
        [self.attrStr appendAttributedString:chStr.attributeString.attrStr];
        return self.whole;
    };
}

-(NSAttributedString*)cutWith:(CGSize)maxSize font:(UIFont*)font {
    NSString *str = self.attrStr.string;
    NSUInteger len = str.length;
    CGSize testSize = CGSizeMake(maxSize.width, maxSize.height + 40);
    CGFloat h = [str sizeWithFont:font maxSize:testSize].height;
    while (h > maxSize.height) {
        len -= 2;
        str = [str substringToIndex:len];
        h = [str sizeWithFont:font maxSize:testSize].height;
    }
    NSMutableAttributedString *ret = [self.attrStr attributedSubstringFromRange:NSMakeRange(0, len )].mutableCopy;
    if (len != self.length && len > 5) {
        NSAttributedString *all = @" ...全文".set.font(font).matches(@"全文").color(UIColor.main).done();
        [ret replaceCharactersInRange:NSMakeRange(len - 4, 4) withAttributedString:all];
    }
    return ret;
}
@end

@implementation NSString(CHFoundation)

- (NSArray<NSValue *> *)matches:(NSString *)expStr {
    NSError *err = nil;
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:expStr options:NSRegularExpressionCaseInsensitive error:&err];
    NSAssert(err == nil, err.localizedDescription);
    NSMutableArray *ranges = [NSMutableArray array];
    [exp enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [ranges addObject:[NSValue valueWithRange:result.range]];
        
    }];
    return ranges;
}

- (CHAttributedString *)attributeString {
    CHAttributedString *attr = [[CHAttributedString alloc] initWithString:self];
    attr.ranges = @[r(0,self.length)];
    return attr;
}

- (CHAttributedString *)set {
    return self.attributeString;
}

- (CHAttributedString *(^)(id<CHStringConvertible>))join {
    return ^(id<CHStringConvertible> chStr) {
        return self.attributeString.join(chStr);
    };
}

- (CHAttributedString *(^)(NSString *))matches {
    return ^(NSString *expStr) {
        CHAttributedString *attr = [[CHAttributedString alloc] initWithString:self];
        attr.ranges = [self matches:expStr];
        return attr;
    };
}

- (CHAttributedString *(^)(NSInteger, NSInteger))range {
    return ^(NSInteger loc, NSInteger len) {
        CHAttributedString *attr = [[CHAttributedString alloc] initWithString:self];
        attr.ranges = @[r(loc,len)];
        return attr;
    };
}

- (CHAttributedString *)whole {
    CHAttributedString *attr = [[CHAttributedString alloc] initWithString:self];
    attr.ranges = @[r(0,self.length)];
    return attr;
}

@end

@implementation CHAttributedImage

+ (instancetype)empty {
    return [[self alloc] init];
}

+ (instancetype)imageNamed:(NSString *)name size:(CGSize)size {
    return [self imageNamed:name size:size offset:0];
}

+ (instancetype)imageNamed:(NSString *)name size:(CGSize)size offset:(CGFloat)offsetY {
    CHAttributedImage *image = [[self alloc] init];
    image.image = [UIImage imageNamed:name];
    image.size = size;
    image.offsetY = offsetY;
    return image;
}

- (CHAttributedString *)attributeString {
    if (self.image == nil) {
        return @"".whole;
    }
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, -_offsetY, _size.width, _size.height);
    attach.image = _image;
    NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:attach];
    return [[CHAttributedString alloc] initWithAttributedString:attrString];
}

- (CHAttributedString *(^)(id<CHStringConvertible>))join {
    return ^(id<CHStringConvertible> chStr) {
        return self.attributeString.join(chStr);
    };
}

@end

