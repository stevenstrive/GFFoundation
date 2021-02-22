//
//  NEResponseObject.m
//  AFNetworking
//
//  Created by 朱炳程 on 2019/8/30.
//

#import "NEResponseObject.h"

#define kDocPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
#define kModelsPath [kDocPath stringByAppendingPathComponent:@"models"]

@implementation NEResponseObject

@end

@implementation NEBaseModel

+ (void)load {
    if (![NSFileManager.defaultManager fileExistsAtPath:kModelsPath]) {
        [NSFileManager.defaultManager createDirectoryAtPath:kModelsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (instancetype)readFromFile {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[kModelsPath stringByAppendingPathComponent:NSStringFromClass(self)]];
}

- (void)writeToFile {
    [NSKeyedArchiver archiveRootObject:self toFile:[kModelsPath stringByAppendingPathComponent:NSStringFromClass(self.class)]];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

MJExtensionCodingImplementation

@end


@implementation NEArrayResponse

@end
