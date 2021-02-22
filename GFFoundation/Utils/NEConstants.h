//
//  NEConstants.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

#ifndef NEConstants_h
#define NEConstants_h

#define kVerionStr versionString()
#define kEnvStr environmentString()
#define kEnvShortStr shortEnvironmentString()
#define kCurrentDateStr currentDateString()
#define kBundleIdStr bundleIdString()
#define kSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
#define kDocPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject


// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define _RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]

/// 1.iOS系统版本

#define kisiPhoneX   \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
#define kNavHeight  (kisiPhoneX ? 88 : 64)
#define kTabHeight  (kisiPhoneX ? 83 : 49)
#define kNavOffset  (kisiPhoneX ? 24 : 0)
#define kStatusBarHeight  (kisiPhoneX ? 44 : 20)

/// 4.屏幕大小尺寸
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf)  __strong __typeof(&*self)strongSelf = self


static NSString * userEnvDic = @"env_userEnvDic";
extern NSString *versionString(void);
extern NSString *environmentString(void);
extern NSString *shortEnvironmentString(void);
extern NSDictionary *baseKeyDictionary(void);
extern NSString *bundleIdString(void);
extern RACSignal *timerSignal(void);
extern RACSignal *timerSignalInterval(CGFloat);


#endif /* NEConstants_h */
