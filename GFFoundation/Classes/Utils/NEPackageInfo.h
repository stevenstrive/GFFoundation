//
//  NEPackageInfo.h
//  NEFoundation
//
//  Created by 朱炳程 on 2020/5/16.
//

#import <Foundation/Foundation.h>

@interface NEPackageInfo : NSObject

@property (nonatomic,strong) NSString *pkgID;
@property (nonatomic,strong) NSString *appID;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *wxId;
@property (nonatomic,strong) NSString *appName;

+ (instancetype)shared;

@end
