//
//  NEPackageInfo.m
//  NEFoundation
//
//  Created by 朱炳程 on 2020/5/16.
//

#import "NEPackageInfo.h"

@implementation NEPackageInfo

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static NEPackageInfo *info = nil;
    dispatch_once(&onceToken, ^{
        info = [[self alloc] init];
    });
    return info;
}

@end
