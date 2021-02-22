//
//  NEAPI.h
//  NewsEarn
//
//  Created by zhubch on 2018/4/12.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEAPILoader.h"
#import "NEUserInterface.h"

typedef NS_ENUM(NSInteger, NEAPIEnv) {
    kNEHTTPAPIProduction = 0,
    kNEHTTPAPITest,
};

extern NSMutableDictionary *gernalParams(void);

@class RACSignal;

@interface NEAPIResult<__covariant ObjectType> : NSObject
@property (nonatomic,strong) ObjectType model;
@property (nonatomic,strong) NEErrorModel *errorModel;
@end

typedef void(^NEAPICompleteHandler)(id model, NEErrorModel *errorModel);

@interface NEAPI<__covariant ObjectType> : NSObject

@property(class) NEAPIEnv env;

@property(class) id<NEUserInterface> user;

@property(class,readonly) NSArray<NSString*>* urls;

@property(class,readonly) NSString* baseURL;

@property(class,readwrite) NSString* customURL;

@property(readonly) NEAPILoader* loader;

@property(readonly) Class modelClass;

//userID为空时不会请求匿名id
@property(readonly) NEAPI *allowNoUserId;

//不要添加通用参数，默认添加
@property(readonly) NEAPI *withoutGernalParams;

//带上第三方广告接口公参, 默认不带
@property(readonly) NEAPI *withAdvParams;

//部分接口需要另外加上userId和ticket
@property(readonly) NEAPI *withToken;

//指定时间内得到结果，没有请求返回空
@property(readonly) NEAPI *(^emergency)(CGFloat);

//如果有正在的进行的请求，默认会复用，使用此属性可禁止复用
@property(readonly) NEAPI *renew;

- (instancetype)initWithModelClass:(Class)clazz;

- (RACSignal*)rac_get:(NSString*)path;

- (RACSignal*)rac_post:(NSString*)path;

- (RACSignal*)rac_get:(NSString*)path
               params:(NSDictionary*)params;

- (RACSignal*)rac_post:(NSString*)path
                params:(NSDictionary*)params;

- (void)get:(NSString*)path
 completion:(void(^)(ObjectType model, NEErrorModel *errorModel))handler;

- (void)post:(NSString*)path
  completion:(void(^)(ObjectType model, NEErrorModel *errorModel))handler;

- (void)getArray:(NSString*)path
      completion:(void(^)(NSArray<ObjectType> *model, NEErrorModel *errorModel))handler;

- (void)postArray:(NSString*)path
       completion:(void(^)(NSArray<ObjectType> *model, NEErrorModel *errorModel))handler;

- (void)get:(NSString*)path
     params:(NSDictionary*)params
 completion:(void(^)(ObjectType model, NEErrorModel *errorModel))handler;

- (void)post:(NSString*)path
      params:(NSDictionary*)params
  completion:(void(^)(ObjectType model, NEErrorModel *errorModel))handler;

- (void)getArray:(NSString*)path
          params:(NSDictionary*)params
      completion:(void(^)(NSArray<ObjectType> *model, NEErrorModel *errorModel))handler;

- (void)postArray:(NSString*)path
           params:(NSDictionary*)params
       completion:(void(^)(NSArray<ObjectType> *model, NEErrorModel *errorModel))handler;

@end

#define api_subclass(api_type) @interface NEAPI##api_type<__covariant ObjectType> : NEAPI\
- (void)get:(NSString*)path completion:(void(^)(ObjectType model, NEErrorModel *errorModel))handler;\
- (void)post:(NSString*)path completion:(void(^)(ObjectType model, NEErrorModel *errorModel))handler;\
- (void)get:(NSString*)path params:(NSDictionary*)params  completion:(void(^)(ObjectType model, NEErrorModel *errorModel))handler;\
- (void)post:(NSString*)path params:(NSDictionary*)params completion:(void(^)(ObjectType model, NEErrorModel *errorModel))handler;\
- (RACSignal*)rac_get:(NSString*)path params:(NSDictionary*)params;\
- (RACSignal*)rac_post:(NSString*)path params:(NSDictionary*)params;\
- (RACSignal*)rac_get:(NSString*)path;\
- (RACSignal*)rac_post:(NSString*)path;\
- (void)getArray:(NSString*)path\
params:(NSDictionary*)params\
completion:(void(^)(NSArray<ObjectType> *model, NEErrorModel *errorModel))handler;\
- (void)postArray:(NSString*)path\
params:(NSDictionary*)params\
completion:(void(^)(NSArray<ObjectType> *model, NEErrorModel *errorModel))handler;\
- (void)getArray:(NSString*)path\
completion:(void(^)(NSArray<ObjectType> *model, NEErrorModel *errorModel))handler;\
- (void)postArray:(NSString*)path\
completion:(void(^)(NSArray<ObjectType> *model, NEErrorModel *errorModel))handler;\
@end

#define api_subclass_imp(api_type,url1,url2) @implementation NEAPI##api_type\
+ (NSArray<NSString *> *)urls {\
return @[url1,url2];\
}\
@end

#define BaseAPI(model_type) [[NEAPI<model_type*> alloc] initWithModelClass:[model_type class]]
#define UserAPI(model_type) [[NEAPIUser<model_type*> alloc] initWithModelClass:[model_type class]]

#define api_register        @"/bp/user/register"
#define api_phone           @"/bp/user/bindOrLoginByMobile"
#define api_wechat          @"/bp/user/bindOrLoginByWechat"
#define api_user_info       @"/bp/user/info"
#define api_sms             @"/bp/user/sendVerifyCode"
#define api_user_lbs        @"/bp/user/uploadLbs"
#define api_check_security  @"/bp/app/check/status"
