//
//  NEAlert.m
//  NewsEarn
//
//  Created by zhubch on 2018/5/24.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEAlert.h"
#import "NEFoundation.h"

@interface NEAlert()

@property (nonatomic,strong) void(^btnClicked)(NSUInteger buttonIndex);
@property (nonatomic,assign) BOOL noMoreAsk;

@end

@implementation NEAlert
{
    CHAttributedString *_title;
    CHAttributedString *_message;
    NSArray *_titles;
    NSUInteger _noMoreAskTag;
    NEAlertTitleStyle _titleStytle;
    BOOL _showCloseBtn;
}

+ (void)load {
    [NERouter.sharedRouter registerURL:@"ne://alert" forBlock:^(NSDictionary *params, void (^completion)(NSDictionary *)) {
        NSString *title = params[@"title"];
        NSString *msg = params[@"msg"];
        NSString *button = params[@"button"];
        NSString *url = params[@"url"];
        NEAlert *alert = [[NEAlert alloc] initWithTitle:title message:msg showCloseBtn:NO btnTitles:button, nil];
        [alert showWithClickBlock:^(NSUInteger buttonIndex) {
            [NERouter.sharedRouter openURL:url];
        }];
    }];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message showCloseBtn:(BOOL)showCloseBtn btnTitles:(NSString *)titles, ... {
    va_list args;
    va_start(args, titles);
    NSMutableArray *titleArray = @[].mutableCopy;
    if (titles) {
        [titleArray addObject:titles];
        NSString *otherString;
        while ((otherString = va_arg(args, NSString *))) {
            [titleArray addObject:otherString];
        }
    }
    title = title ?: @"";
    message = message ?: @"";
    _titles = titleArray;
    _message = message.set.color(UIColor.gray6).font(UIFont.regular(16));
    _title = title.set.color(UIColor.black).font(UIFont.medium(20));
    _titleStytle = NEAlertTitleStyleHorizontal;
    _showCloseBtn = showCloseBtn;
    va_end(args);
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth - 38 - 38, 0)]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message showCloseBtn:(BOOL)showCloseBtn titleStyle:(NEAlertTitleStyle)style btnTitles:(NSString *)titles, ... {
    va_list args;
    va_start(args, titles);
    NSMutableArray *titleArray = @[].mutableCopy;
    if (titles) {
        [titleArray addObject:titles];
        NSString *otherString;
        while ((otherString = va_arg(args, NSString *))) {
            [titleArray addObject:otherString];
        }
    }
    title = title ?: @"";
    message = message ?: @"";
    _titles = titleArray;
    _message = message.set.color(UIColor.gray6).font(UIFont.regular(16));
    _title = title.set.color(UIColor.black).font(UIFont.medium(20));
    _titleStytle = style;
    _showCloseBtn = showCloseBtn;
    va_end(args);
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth - 38 - 38, 0)]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithAttrTitle:(CHAttributedString *)title attrMessage:(CHAttributedString *)message showCloseBtn:(BOOL)showCloseBtn btnTitles:(NSString *)titles, ...{
    va_list args;
    va_start(args, titles);
    NSMutableArray *titleArray = @[].mutableCopy;
    if (titles) {
        [titleArray addObject:titles];
        NSString *otherString;
        while ((otherString = va_arg(args, NSString *))) {
            [titleArray addObject:otherString];
        }
    }
    _titles = titleArray;
    _message = message;
    _title = title;
    va_end(args);
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth - 38 - 38, 0)]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithAttrTitle:(CHAttributedString *)title attrMessage:(CHAttributedString *)message noMoreAsk:(NSUInteger)tag btnTitles:(NSString *)titles, ... {
    va_list args;
    va_start(args, titles);
    NSMutableArray *titleArray = @[].mutableCopy;
    if (titles) {
        [titleArray addObject:titles];
        NSString *otherString;
        while ((otherString = va_arg(args, NSString *))) {
            [titleArray addObject:otherString];
        }
    }
    _titles = titleArray;
    _message = message;
    _title = title;
    _showCloseBtn = YES;
    _noMoreAskTag = tag;
    va_end(args);
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth - 38 - 38, 0)]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.cornerRadius = 8;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 24, self.width - 52, 0)];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = _title.done();
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.height = [titleLabel sizeThatFits:CGSizeMake(titleLabel.width, 100)].height;
    [self addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(titleLabel.frame) + 8, self.width - 52, 0)];
    messageLabel.numberOfLines = 0;
    messageLabel.attributedText = _message.done();
    messageLabel.height = [messageLabel sizeThatFits:CGSizeMake(messageLabel.width, 100)].height;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:messageLabel];
    
    if (_showCloseBtn) {
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 34 - 7, 7, 34, 34)];
        [closeBtn setImage:[UIImage imageNamed:@"game_alert_close"] forState:UIControlStateNormal];
        [closeBtn clickAction:^(UIButton *sender) {
            dismiss(self);
        }];
        [self addSubview:closeBtn];
        self.closeBtn = closeBtn;
    }
    
    if (_titles.count == 0) {
        self.height = CGRectGetMaxY(messageLabel.frame) + 24;
        return;
    }
    
    CGFloat verticalH = (_titleStytle == NEAlertTitleStyleVertical) * (_titles.count - 1) * 64;
    self.height = CGRectGetMaxY(messageLabel.frame) + 24 + 48 + 24 + verticalH;
    CGFloat y = CGRectGetMaxY(messageLabel.frame);
    if (_noMoreAskTag > 0) {
        self.height = CGRectGetMaxY(messageLabel.frame) + 24 + 48 + 24 + 24;

        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(115, y + 10, 26, 26)];
        [btn setImage:[UIImage imageNamed:@"icon_no_ask"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_no_ask_sel"] forState:UIControlStateSelected];
        [self addSubview:btn];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(135, y + 10, 100, 26)];
        tip.attributedText = @"不再提示".set.color(UIColor.gray6).font(kFontRegular12).done();
        [self addSubview:tip];
        
        [btn clickAction:^(UIButton *sender) {
            sender.selected = !sender.selected;
            self.noMoreAsk = sender.selected;
        }];
        y += 47;
    } else {
        y += 24;
    }
    
    if (_titleStytle == NEAlertTitleStyleHorizontal) {
        CGFloat w = (self.width - (_titles.count + 1) * 16) / _titles.count;
        for (int i = 0; i < _titles.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * w + 16 * (i + 1), y, w, 48)];
            btn.cornerRadius = 24;
            btn.tag = i;
            btn.titleLabel.font = kFontMedium16;
            if (i == _titles.count - 1) {
                [btn setBackgroundColor:UIColor.main forState:UIControlStateNormal];
            } else {
                [btn setTitleColor:UIColor.gray6 forState:UIControlStateNormal];
                [btn setBackgroundColor:UIColor.gray2 forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            [self addSubview:btn];
        }
    }
    else {
        CGFloat w = self.width - 16;
        for (int i = 0; i < _titles.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(8, y + (i * 64), w, 48)];
            btn.titleLabel.font = kFontMedium16;
            btn.cornerRadius = 24;
            btn.tag = i;
            if (i == 0) {
                [btn setBackgroundColor:UIColor.main forState:UIControlStateNormal];
            } else {
                [btn setTitleColor:UIColor.gray6 forState:UIControlStateNormal];
                [btn setBackgroundColor:UIColor.gray2 forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            [self addSubview:btn];
        }
    }
}

- (instancetype)initWithImage:(UIImage *)image {
    if (image == nil) {
        return nil;
    }
    CGFloat maxWidth = MIN(kScreenWidth * 0.8, image.size.width);
    CGFloat finalScale = maxWidth / image.size.width;
    return [self initWithImage:image size:CGSizeMake(image.size.width * finalScale, image.size.height * finalScale)];
}

- (instancetype)initWithImage:(UIImage *)image size:(CGSize)size {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    return [self initWithCustomView:imgView style:NEAlertStyleOverlayer size:size];
}

- (instancetype)initWithCustomView:(UIView *)view style:(NEAlertStyle)style size:(CGSize)size {
    BOOL bottomClose = NEAlertStyleOverlayer == style || NEAlertStyleBottomClose == style;
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height + 56 * bottomClose)]) {
        view.frame = CGRectMake(0, 0, size.width, size.height);
        view.cornerRadius = 10;
        view.userInteractionEnabled = YES;
        if (NEAlertStyleOverlayer == style) {
            UIButton *overlayer = [[UIButton alloc] initWithFrame:view.bounds];
            [overlayer addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:overlayer];
        }
        
        [self addSubview:view];

        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.width - 40) * 0.5 , size.height + 16, 40, 40)];
        [closeButton setImage:[UIImage imageNamed:@"game_alert_close"] forState:UIControlStateNormal];
        if (NEAlertStyleDefaultClose == style) {
            closeButton.frame = CGRectMake(self.width - 34 - 7, 7, 34, 34);
            [closeButton setImage:[UIImage imageNamed:@"game_alert_close"] forState:UIControlStateNormal];
        }
        [closeButton clickAction:^(UIButton *sender) {
            dismiss(self);
        }];
        if (NEAlertStyleNoneClose != style) {
            [self addSubview:closeButton];
        }
    }
    return self;
}

- (void)show {
    [self showWithClickBlock:nil];
}

- (void)showWithClickBlock:(void (^)(NSUInteger))clickBlock {
    if (_noMoreAskTag > 0 && [NSUserDefaults.standardUserDefaults boolForKey:[NSString stringWithFormat:@"NoMoreAsk%d",_noMoreAskTag]]) {
        if (clickBlock) {
            clickBlock(0);
        }
        return;
    }
    self.btnClicked = clickBlock;
    present(self);
}

- (void)btnClicked:(UIButton*)sender {
    if (self.noMoreAsk) {
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:[NSString stringWithFormat:@"NoMoreAsk%d",_noMoreAskTag]];
    }
    dismiss(self);
    if (self.btnClicked) {
        self.btnClicked(sender.tag);
    }
}

- (void)hide {
    dismiss(self);
}

+ (void)removeAll {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    for (UIView *v in win.subviews) {
        if (v.tag == kPopUpViewTag) {
            [v removeFromSuperview];
        }
    }
}

@end
