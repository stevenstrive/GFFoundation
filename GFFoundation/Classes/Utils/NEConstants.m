//
//  NEConstants.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEConstants.h"
#import "NEFoundation.h"
#import <ReactiveObjC/ReactiveObjC.h>

NSString *versionString() {
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    if (version == nil) {
        version = @"1.0.0";
    }
    return version;
}

NSString *environmentString() {
    if (NEAPI.env == kNEHTTPAPITest) {
        return @"test";
    }
    return @"production";
}

NSString *shortEnvironmentString() {
    return [environmentString() substringToIndex:1];
}

NSString *bundleIdString() {
    return [[NSBundle mainBundle] bundleIdentifier];
}

RACSignal *timerSignalInterval(CGFloat interval) {
    RACSignal *timer = [[RACSignal interval:interval
                                onScheduler:[RACScheduler mainThreadScheduler]] startWith:[NSDate date]];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block double seconds = 0;
        RACDisposable *disposable = [timer subscribeNext:^(id x) {
            seconds += interval;
            [subscriber sendNext:@(seconds)];
        }];
        return [RACDisposable disposableWithBlock:^{
            [disposable dispose];
        }];
    }];
}

RACSignal *timerSignal() {
    return timerSignalInterval(1);
}
