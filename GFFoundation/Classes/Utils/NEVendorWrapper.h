//
//  NEVendorWrapper.h
//  NewsEarn
//
//  Created by zhubch on 2018/8/30.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NEWxShareScene) {
    kNEWxShareSession = 0,
    kNEWxShareTimeline,
    kNEWxShareFavorite,
};

@interface NEVendorWrapper : NSObject

@property (nonatomic,copy) NSString *tdSign;

+ (instancetype)sharedWapper;

- (BOOL)handleURL:(NSURL*)url;

@end
