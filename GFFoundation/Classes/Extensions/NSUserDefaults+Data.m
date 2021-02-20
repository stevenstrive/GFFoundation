//
//  NSUserDefaults+NE.m
//  testFoundation
//
//  Created by apple on 2017/2/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "NSUserDefaults+Data.h"
#import <objc/runtime.h>


typedef void(^NEUserDefalutBlock)(NSUserDefaults *defalut);

@interface NSUserDefaults()

@end

@implementation NSUserDefaults (Data)

+ (BOOL)synchronizeValue:(NEUserDefalutBlock)block {
    NSUserDefaults *defalut = [NSUserDefaults standardUserDefaults];
    block(defalut);
    return [defalut synchronize];
};

+ (void)clearUserDefalut {
    [NSUserDefaults resetStandardUserDefaults];
}

+ (BOOL)saveIntegerValue:(NSInteger)value forKey:(NSString *)key {
    return [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        [defalut setInteger:value forKey:key];
    }];
}


+ (BOOL)saveFloat:(float)value forKey:(NSString *)key {
    return [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        [defalut setFloat:value forKey:key];
    }];
}

+ (BOOL)saveDouble:(double)value forKey:(NSString *)key {
    return [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        [defalut setDouble:value forKey:key];
    }];
}

+ (BOOL)saveBool:(BOOL)value forKey:(NSString *)key {
    return [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        [defalut setBool:value forKey:key];
    }];
}

+ (BOOL)saveURL:(NSURL *)url forKey:(NSString *)key {
    return [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        [defalut setURL:url forKey:key];
    }];
}

+ (BOOL)saveObject:(id)value forKey:(NSString *)key {
    return [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        [defalut setObject:value forKey:key];
    }];
}

+ (BOOL)saveCustomObject:(NSObject*)obj forKey:(NSString *)key {
    return [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        uint outCount = 0;
        objc_property_t *proList = class_copyPropertyList([obj class], &outCount);
        for (int i = 0; i < outCount; i++)
        {
            objc_property_t pro = proList[i];
            const char *proName = property_getName(pro);
            NSString *p_Name = [[NSString alloc] initWithCString:proName encoding:NSUTF8StringEncoding];
            id value = [obj valueForKey:p_Name];
            if (value != nil)
            {
                [dictM setValue:value forKey:key];
            }
        }
        NSString *className = NSStringFromClass([obj class]);
        [dictM setObject:className forKey:@"className"];
        [defalut setObject:dictM forKey:key];
        free(proList);
    }];
}

+ (id)readCustomObjectForKey:(NSString *)key {
    __block id object = nil;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:[defalut objectForKey:key]];
        NSString *className = [dictM valueForKey:@"className"];
        [dictM removeObjectForKey:@"className"];
        Class cls = NSClassFromString(className);
        object = [[cls alloc] init];
        [dictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (object != nil) {
                [object setValue:obj forKeyPath:key];
            }
        }];
    }];
    return object;
}

+ (id)readObjectForKey:(NSString *)key {
    __block id object = nil;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        object = [defalut objectForKey:key];
    }];
    return object;
}

+ (BOOL)removeObjForKey:(NSString *)key {
    return [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        [defalut removeObjectForKey:key];
    }];
}


+ (NSString *)readStringForKey:(NSString *)key {
    __block NSString *str = nil;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        str = [defalut stringForKey:key];
    }];
    return str;
}

+ (NSArray *)readArrayForKey:(NSString *)key {
    __block NSArray *arr = nil;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        arr = [defalut arrayForKey:key];
    }];
    return arr;
}


+ (NSDictionary<NSString *, id> *)readDictionaryForKey:(NSString *)key {
    __block NSDictionary *dict = nil;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        dict = [defalut dictionaryForKey:key];
    }];
    return dict;
}


+ (NSData *)readDataForKey:(NSString *)key {
    __block NSData *data = nil;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        data = [defalut dataForKey:key];
    }];
    return data;
}

+ (NSArray<NSString *> *)readStringArrayForKey:(NSString *)key {
    __block NSArray *arr = nil;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        arr = [defalut stringArrayForKey:key];
    }];
    return arr;
}


+ (NSInteger)readIntegerForKey:(NSString *)key {
    __block NSInteger value = 0;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        value = [defalut integerForKey:key];
    }];
    return value;
}

+ (float)readFloatForKey:(NSString *)key {
    __block float value = 0.0;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        value = [defalut floatForKey:key];
    }];
    return value;
}


+ (double)readDoubleForKey:(NSString *)key {
    __block double value = 0.00;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        value = [defalut doubleForKey:key];
    }];
    return value;
}

+ (BOOL)readBoolForKey:(NSString *)key {
    __block BOOL value = NO;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        value = [defalut boolForKey:key];
    }];
    return value;
}

+ (NSURL *)readURLForKey:(NSString *)key {
    __block NSURL *url = nil;
    [NSUserDefaults synchronizeValue:^(NSUserDefaults *defalut) {
        url = [defalut URLForKey:key];
    }];
    return url;
}




@end


