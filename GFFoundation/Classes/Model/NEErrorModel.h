//
//  NEErrorModel.h
//  AFNetworking
//
//  Created by 朱炳程 on 2019/10/16.
//

#import <Foundation/Foundation.h>

@interface NEErrorModel : NSObject

@property (nonatomic,assign) NSInteger code;
@property (nonatomic,strong) NSString *message;

@end
