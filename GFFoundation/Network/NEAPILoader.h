//
//  NEAPILoader.h
//  NewsEarn
//
//  Created by zhubch on 2018/4/12.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class NEErrorModel;

@interface NEAPILoader : AFHTTPSessionManager

@property (nonatomic,assign) BOOL needUserId;
@property (nonatomic,assign) BOOL convertToArray;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (NSURLSessionDataTask *)GET:(NSString *)strURL
                        params:(NSDictionary *)dicParams
                    resultType:(Class)modelClass
               completeHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler;

- (NSURLSessionDataTask *)POST:(NSString *)strURL
                        params:(NSDictionary *)dicParams
                    resultType:(Class)modelClass
               completeHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler;

- (NSURLSessionDataTask*)upload:(NSString*)strURL
                             data:(NSData*)data
                           params:(NSDictionary *)dicParams
                  completeHandler:(void(^)(id model, NEErrorModel *errorModel))completeHandler;

- (void)anonymousKey:(void(^)(NSString* key))completion;

@end
