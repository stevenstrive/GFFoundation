//
//  NEUtils.h
//  NEFoundation
//
//  Created by zhubch on 2018/8/9.
//

#import <Foundation/Foundation.h>

extern NSBundle *resourceBundle(Class clazz);
extern void playSound(void);
extern UIColor *randomColor(void);
extern NSString *getIPAddress(BOOL);
extern NSString *resolveHost(NSString*);
extern NSInteger getGoldRate(void);
extern BOOL testEnvOr(BOOL);
extern id nullsafe_pack(id); //如果是nil会转成NSNULL
extern id nullsafe_unpack(id);//如果是NSNULL会转成nil
extern void share(id);
extern NSString *formatWan(NSInteger);
extern void retry(int,BOOL(^)(int times));
