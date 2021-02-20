//
//  NEAPI.m
//  NewsEarn
//
//  Created by zhubch on 2018/4/12.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEAPI.h"
#import "NEFoundation.h"
#import <ReactiveObjC/ReactiveObjC.h>

/**
 1. dev环境：           涉及到前后端功能开发时，前后端联调的环境，使用网络是公司内网；
 2. test环境：          只是前端做开发，部分后端无改动时可以在此环境测试，使用网络是外部网络；
 3. staging环境：       正式上线前，公司自测确认产品功能，使用网络是外部网络；
 4. production环境：    正式线上环境，使用网络是外部网络；
 */

static NEAPIEnv _env = kNEHTTPAPIProduction;//kNEHTTPAPIProduction;//

static id<NEUserInterface> _user = nil;

@implementation NEAPI {
    BOOL _addGernelParams;
    BOOL _addAdvParams;
    BOOL _addUserIdAndTiket;
    BOOL _allowNoUserId;
    CGFloat _emergency;
    CGFloat _repeatDelay;
}

@synthesize loader = _loader;

- (instancetype)initWithModelClass:(Class)clazz {
    if (self = [super init]) {
        _modelClass = clazz;
        _addGernelParams = YES;
        _addAdvParams = NO;
        _addUserIdAndTiket = NO;
        _allowNoUserId = NO;
        _emergency = -1;
    }
    return self;
}

+ (void)setEnv:(NEAPIEnv)env {
    _env = env;
}

+ (NEAPIEnv)env {
    return _env;
}

+ (void)setUser:(id<NEUserInterface>)user {
    _user = user;
}

+ (id<NEUserInterface>) user {
    return _user;
}

+ (NSArray<NSString *> *)urls {
    return nil;
}

+ (NSString *)baseURL {
    return self.urls[self.env];
}

- (NEAPI *)withoutGernalParams {
    _addGernelParams = NO;
    return self;
}

- (NEAPI *)withAdvParams {
    _addAdvParams = YES;
    return self;
}

- (NEAPI *)withToken {
    _addUserIdAndTiket = YES;
    return self;
}

- (NEAPI *)allowNoUserId {
    _allowNoUserId = YES;
    return self;
}

- (NEAPI *(^)(CGFloat))emergency {
    return ^(CGFloat value) {
        self->_emergency = value;
        return self;
    };
}

- (NSString*)processPath:(NSString*)path {
    if (![path isKindOfClass:NSString.class]) {
        return @"";
    }
    NSString *strPath = path;
    return strPath ?: @"";
}

- (NSDictionary *)processParams:(NSDictionary *)params {
    
    NSMutableDictionary *dic = (params ?: @{}).mutableCopy;
    if (_addGernelParams) {
        [dic addEntriesFromDictionary:gernalParams()];
    }
    
    if (_addAdvParams) {

    }
    return dic;
}

- (NEAPILoader *)loader {
    if (_loader == nil) {
        NSURL *baseURL = [NSURL URLWithString:[self class].baseURL];
        NEAPILoader *loader = [[NEAPILoader alloc] initWithBaseURL:baseURL];
        if (_allowNoUserId) {
            loader.needUserId = NO;
        }
        NSDictionary *header = gernalParams();
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [loader.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
        _loader = loader;
    }

    return _loader;
}

- (void)get:(NSString *)path params:(NSDictionary *)params completion:(NEAPICompleteHandler)handler {
    [self.loader GET:[self processPath:path] params:[self processParams:params] resultType:self.modelClass completeHandler:handler];
}

- (void)post:(NSString *)path params:(NSDictionary *)params completion:(NEAPICompleteHandler)handler {
    [self.loader POST:[self processPath:path] params:[self processParams:params] resultType:self.modelClass completeHandler:handler];
}

- (void)get:(NSString *)path completion:(NEAPICompleteHandler)handler {
    [self get:path params:nil completion:handler];
}

- (void)post:(NSString *)path completion:(NEAPICompleteHandler)handler {
    [self post:path params:nil completion:handler];
}

- (void)getArray:(NSString *)path completion:(void (^)(NSArray *, NEErrorModel *))handler {
    [self getArray:path params:nil completion:handler];
}

- (void)getArray:(NSString *)path params:(NSDictionary *)params completion:(void (^)(NSArray *, NEErrorModel *))handler {
    self.loader.convertToArray = YES;
    [self.loader GET:[self processPath:path] params:[self processParams:params] resultType:self.modelClass completeHandler:handler];
}

- (void)postArray:(NSString *)path completion:(void (^)(NSArray *, NEErrorModel *))handler {
    [self postArray:path params:nil completion:handler];
}

- (void)postArray:(NSString *)path params:(NSDictionary *)params completion:(void (^)(NSArray *, NEErrorModel *))handler {
    self.loader.convertToArray = YES;
    [self.loader POST:[self processPath:path] params:[self processParams:params] resultType:self.modelClass completeHandler:handler];
}

- (RACSignal *)rac_get:(NSString *)path params:(NSDictionary *)params {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block BOOL hasSendNext = NO;
        if (_emergency >= 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_emergency * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (hasSendNext) {
                    return ;
                }
                [subscriber sendNext:nil];
            });
        }
        [self get:path params:[self processParams:params] completion:^(id model, NEErrorModel *errorModel) {
            hasSendNext = YES;
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)rac_post:(NSString *)path params:(NSDictionary *)params {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block BOOL hasSendNext = NO;
        if (_emergency >= 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_emergency * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (hasSendNext) {
                    return ;
                }
                [subscriber sendNext:nil];
            });
        }
        [self post:path params:[self processParams:params] completion:^(id model, NEErrorModel *errorModel) {
            hasSendNext = YES;
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)rac_get:(NSString *)path {
    return [self rac_get:path params:nil];
}

- (RACSignal *)rac_post:(NSString *)path {
    return [self rac_post:path params:nil];
}

@end

@implementation NEAPIResult
@end

NSMutableDictionary *gernalParams() {
    NSString *strGPS = @"default";
    if (_user.latitude.length != 0 && _user.longitude.length != 0) {
        strGPS = [NSString stringWithFormat:@"%@,%@", _user.latitude, _user.longitude];
    }
    NSMutableDictionary *header = @{
                                    @"deviceId":NEDeviceInfo.sharedInfo.idfa,
                                    @"brand":@"Apple",
                                    @"gps":strGPS,
                                    @"bs":@"CDMA",
                                    @"version":versionString(),
                                    @"appVersion":versionString(),
                                    @"os":@"iOS",
                                    @"channel":@"AppStore",
                                    @"romVersion":[NSString stringWithFormat:@"iOS%f",kSystemVersion],
                                    @"osVersion":[NSString stringWithFormat:@"iOS%f",kSystemVersion],
                                    @"pkgId":NEPackageInfo.shared.pkgID,
                                    @"anomy":@(_user.anonymousUser && _user.logined).stringValue,
                                    @"userId":@(_user.userId).stringValue,
                                    @"appId":NEPackageInfo.shared.appID,
                                    @"env": kEnvStr,
                                    @"sign": _user.sign
                                    }.mutableCopy;
    if (_user.accessKey.length) {
        header[@"accessKey"] = _user.accessKey;
    }
    return header;
}
