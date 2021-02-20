//
//  NEBaseModel.h
//  AFNetworking
//
//  Created by 朱炳程 on 2019/8/30.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "NEErrorModel.h"

@interface NEResponseObject : NSObject

@property (nonatomic,assign) NSInteger code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) id result;

@end

@interface NEBaseModel : NSObject<MJCoding>

+ (instancetype)readFromFile;

- (void)writeToFile;

@end

@interface NEArrayResponse : NSObject<MJCoding>
@property (nonatomic,assign) Class *clazz;
@end
