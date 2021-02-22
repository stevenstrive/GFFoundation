
//
//  NEHTTPLoader.m
//  NewsEarn
//
//  Created by zhubch on 2018/4/12.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEAPILoader.h"
#import "NEFoundation.h"

@interface NEAPILoader()
@property (nonatomic,strong) NSURL *prefixURL;
@end

@implementation NEAPILoader

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:nil]) {
        NSSet *typeSet = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/xml", @"video/mp2t", @"suggestion/json", @"application/zip", nil];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = typeSet;
        self.requestSerializer.timeoutInterval = 10.0f;
        self.prefixURL = url;
        AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        self.securityPolicy = policy;
        self.needUserId = YES;
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)strURL params:(NSDictionary *)dicParams resultType:(Class)modelClass completeHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler {
    if ([strURL hasPrefix:@"http://"] || [strURL hasPrefix:@"https://"]) {
        return [self GetWithURLString:strURL Params:dicParams ResultModelClass:modelClass CompleteHandler:completeHandler];
    }
    NSString *url = [self.prefixURL.absoluteString stringByAppendingString:strURL];
    return [self GetWithURLString:url Params:dicParams ResultModelClass:modelClass CompleteHandler:completeHandler];
}

- (NSURLSessionDataTask *)POST:(NSString *)strURL params:(NSDictionary *)dicParams resultType:(Class)modelClass completeHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler {
    NSString *url = [self.prefixURL.absoluteString stringByAppendingPathComponent:strURL];
    return [self PostWithURLString:url Params:dicParams ResultModelClass:modelClass CompleteHandler:completeHandler];
}

- (NSURLSessionDataTask *)upload:(NSString *)strURL data:(NSData*)data params:(NSDictionary *)dicParams completeHandler:(void (^)(id, NEErrorModel *))completeHandler {
    return nil;
}

#pragma mark - HTTP Get, Post

- (NSURLSessionDataTask *)GetWithURLString:(NSString *)strURL
                                    Params:(NSDictionary *)dicParams
                          ResultModelClass:(Class)modelClass
                           CompleteHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler {
    NSLog(@"%@",[strURL stringByAppendingQueryParams:gernalParams()]);
    return [self GET:strURL parameters:dicParams headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self printLogWithURLString:strURL params:dicParams responseObject:responseObject error:nil];
        [self successWithRespData:responseObject resultModelClass:modelClass task:task completeHandler:completeHandler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self printLogWithURLString:strURL params:dicParams responseObject:nil error:error];
        [self failureWithError:error task:task completeHandler:completeHandler];
    }];
}

- (NSURLSessionDataTask *)PostWithURLString:(NSString *)strURL
                                     Params:(NSDictionary *)dicParams
                           ResultModelClass:(Class)modelClass
                            CompleteHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler {
    return [self POST:strURL parameters:dicParams headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
            [self printLogWithURLString:strURL params:dicParams responseObject:responseObject error:nil];
    #endif
            [self successWithRespData:responseObject resultModelClass:modelClass task:task completeHandler:completeHandler];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self printLogWithURLString:strURL params:dicParams responseObject:nil error:error];
            [self failureWithError:error task:task completeHandler:completeHandler];
        }];
}
#pragma mark  HTTP Result Handler

- (void)successWithRespData:(id)responseObj resultModelClass:(Class)modelClass task:(NSURLSessionDataTask *)task completeHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler {
    if (!completeHandler) {
        return;
    }
    if ([responseObj conformsToProtocol:@protocol(OS_dispatch_data)] && [modelClass isKindOfClass:[NSData class]]) {
        completeHandler(responseObj, nil);
        return;
    }
    
    if ([[[modelClass alloc] init] isKindOfClass:[NSString class]]) {
        NSString *str = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        completeHandler(str,nil);
        return;
    }
    if ([[[modelClass alloc] init] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        completeHandler(dic,nil);
        return;
    }
    NSString *str = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    NEResponseObject *obj = [NEResponseObject mj_objectWithKeyValues:responseObj];
    
    NSUInteger code = obj.code;
    if (code == 0 || code == 1 || code == 20018) {
        if (obj == nil | modelClass == NEResponseObject.class) {
            completeHandler(obj,nil);
        } else if (self.convertToArray) {
            id modelArray = [modelClass mj_objectArrayWithKeyValuesArray:obj.result];
            completeHandler(modelArray, nil);
        } else {
            id model = [modelClass mj_objectWithKeyValues:obj.result];
            completeHandler(model, nil);
        }
    }
    else {
        NEErrorModel* error = [NEErrorModel mj_objectWithKeyValues:obj.mj_keyValues];
        completeHandler(nil,error);
    }
}

- (void)failureWithError:(NSError *)error task:(NSURLSessionDataTask *)task completeHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler {
    NEErrorModel *errorModel = [[NEErrorModel alloc] init];
    NSHTTPURLResponse *resp = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    
    errorModel.code = resp.statusCode ?: error.code;
    errorModel.message = error.localizedDescription;
    completeHandler(nil,errorModel);
    
    if (errorModel.code == 401) {
        static NSDate *alertDate = nil;
        if (alertDate && [NSDate.date timeIntervalSinceDate:alertDate] < 5) {
            return;
        }
        NEAlert *alert = [[NEAlert alloc] initWithTitle:@"登录已过期，请重新登录" message:nil showCloseBtn:NO btnTitles:@"重新登录", nil];
        [alert showWithClickBlock:^(NSUInteger buttonIndex) {
            [NEAPI.user logout];
        }];
        alertDate = NSDate.date;
    }
}

#pragma mrak - Helper

- (void)printLogWithURLString:(NSString *)strURLString params:(NSDictionary *)dicParams responseObject:(id)respObj error:(NSError *)error {
    NSURL *url = [NSURL URLWithString:strURLString relativeToURL:self.baseURL];
    if (error) {
        NSLog(@"Request URL: %@", url.absoluteString);
        NSLog(@"Params: %@", dicParams);
        NSLog(@"Error: %@", error);
    }
}

@end

