//
//  NEUserInterface.h
//  NEFoundation
//
//  Created by 朱炳程 on 2020/5/14.
//

#import <Foundation/Foundation.h>

@protocol NEUserInterface <NSObject>

@property (nonatomic, readwrite) NSInteger userId;
@property (nonatomic, readwrite) BOOL logined;
@property (nonatomic, readwrite) BOOL anonymousUser;
@property (nonatomic, readwrite) NSString *accessKey;
@property (nonatomic, readwrite) NSString *latitude;
@property (nonatomic, readwrite) NSString *location;
@property (nonatomic, readwrite) NSString *longitude;
@property (nonatomic, readwrite) NSString *sign;
- (void)logout;

@end
