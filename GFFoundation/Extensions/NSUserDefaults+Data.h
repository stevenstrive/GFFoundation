//
//  NSUserDefaults+NE.h
//  testFoundation
//
//  Created by apple on 2017/2/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Data)


/** 谨慎操作 !!! */
+ (void)clearUserDefalut;

+ (BOOL)saveIntegerValue:(NSInteger)value forKey:(NSString *)key;
+ (BOOL)saveFloat:(float)value forKey:(NSString *)key;
+ (BOOL)saveDouble:(double)value forKey:(NSString *)key;
+ (BOOL)saveBool:(BOOL)value forKey:(NSString *)key;
+ (BOOL)saveURL:(NSURL *)url forKey:(NSString *)key;
+ (BOOL)saveObject:(id)value forKey:(NSString *)key;

/**
 保存自定义对象 ， 自定义对象只能包含Foundation的属性，不能含有自定义的Model
 //没有对Value加密
 
 Demo
     Person *p1 = [[Person alloc] init];
     p1.name = @"张三";
     p1.age = 34;
     p1.dict = @{@"key":@"你好",@"name":@"lsl"};
     [NSUserDefaults saveCustomObject:p1 forKey:@"p1"];
     Person *p2 = [NSUserDefaults readCustomObjectForKey:@"p1"];
     NSLog(@"p2.name -- %@",p2.name);

 @param obj 对象
 @param key 保存的键
 @return 是否保存成功
 */
+ (BOOL)saveCustomObject:(NSObject*)obj forKey:(NSString *)key;


/**
 读取一个对象
 @param key 保存的键
 @return 对象
 */
+ (id)readCustomObjectForKey:(NSString *)key;

/**
 读取一个对象，保存的是Foundation包含的类型
 @param key 保存的键
 @return 对象
 */
+ (id)readObjectForKey:(NSString *)key;

/**
 移除存储的对象
 @param key 保存的键
 @return 是否移除成功
 */
+ (BOOL)removeObjForKey:(NSString *)key;


+ (NSString *)readStringForKey:(NSString *)key;
+ (NSArray *)readArrayForKey:(NSString *)key;
+ (NSDictionary<NSString *, id> *)readDictionaryForKey:(NSString *)key;
+ (NSData *)readDataForKey:(NSString *)key;
+ (NSArray<NSString *> *)readStringArrayForKey:(NSString *)key;
+ (NSInteger)readIntegerForKey:(NSString *)key;
+ (float)readFloatForKey:(NSString *)key;
+ (double)readDoubleForKey:(NSString *)key;
+ (BOOL)readBoolForKey:(NSString *)key;
+ (NSURL *)readURLForKey:(NSString *)key;





@end



