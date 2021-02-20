//
//  NERouter.h
//  NewsEarn
//
//  Created by zhubch on 2018/8/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteBlock)(NSString *url,NSDictionary* params,void(^completion)(NSDictionary*));
typedef void(^SimpleBlock)(NSString *url,NSDictionary* params);

@protocol NERouterTarget<NSObject>
- (void)openFromURL:(NSString*)url withParams:(NSDictionary*)params completion:(void(^)(NSDictionary*))completion;
@end

@interface NEBlockTarget: NSObject<NERouterTarget>

@property (nonatomic,copy) CompleteBlock block;

+ (instancetype)targetForCompleteBlock:(CompleteBlock)block;

+ (instancetype)targetForSimpleBlock:(SimpleBlock)block;

@end

@interface NERouter : NSObject
@property (nonatomic,readonly) NSArray *allRegisteredURLs;

+ (instancetype)sharedRouter;

- (void)registerURL:(NSString*)url
          forTarget:(id<NERouterTarget>)target;

- (void)registerURL:(NSString*)url
           forBlock:(void(^)(NSDictionary* params,void(^completion)(NSDictionary*)))block;

- (void)registerURL:(NSString*)url
     forViewControllerClass:(Class<NERouterTarget>)clazz;

- (void)unregisterURL:(NSString*)url;

- (BOOL)canOpen:(NSString*)url;

- (BOOL)openURL:(NSString*)url;

- (BOOL)openURL:(NSString*)url
       webTitle:(NSString*)webTitle;

- (BOOL)openURL:(NSString*)url
         params:(NSDictionary*)params;

- (BOOL)openURL:(NSString*)url
         params:(NSDictionary*)params
     completion:(void(^)(NSDictionary*))completion;

- (BOOL)openURL:(NSString *)url
       webTitle:(NSString *)webTitle
     hideNavBar:(BOOL)hideNavBar
    extraParams:(NSDictionary *)extraParams;

- (BOOL)openURL:(NSString *)url
       webTitle:(NSString *)webTitle
     hideNavBar:(BOOL)hideNavBar;
@end
