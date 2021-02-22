//
//  NEDeviceInfo.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/2.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NEDeviceInfo.h"
#import "NENetWorkMonitor.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "NERouter.h"
#include <ifaddrs.h>
#include <sys/socket.h> // Per msqr
#import <sys/ioctl.h>
#include <net/if.h>
#import <arpa/inet.h>

@implementation NEDeviceInfo

@synthesize strIP = _strIP;
@synthesize strUA = _strUA;
@synthesize tdSign = _tdSign;
@synthesize idfa = _idfa;

+ (instancetype)sharedInfo {
    static dispatch_once_t onceToken;
    static NEDeviceInfo *info = nil;
    dispatch_once(&onceToken, ^{
        info = [[self alloc] init];
    });
    return info;
}

- (instancetype)init {
    if (self = [super init]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self strIP];
        });

    }
    return self;
}

- (NSString *)tdSign {
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(sem, 1);
    [NERouter.sharedRouter openURL:@"ne://td-sign" params:nil completion:^(NSDictionary *ret) {
        self->_tdSign = ret[@"sign"];
        dispatch_semaphore_signal(sem);
    }];
    dispatch_semaphore_wait(sem, 1);
    dispatch_semaphore_signal(sem);
    return _tdSign ?: @"";
}

- (NSString *)idfa {
    if (_idfa.length < 1 || [_idfa isEqualToString:@"0"]) {
        if (@available(iOS 14.5.0, *)) {
            // iOS14及以上版本需要先请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSString *strIdfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSString *temp = [strIdfa stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    temp = [temp stringByReplacingOccurrencesOfString:@"0" withString:@""];
                    if (temp.length < 1) {
                        strIdfa = @"0";
                    }
                    self->_idfa = strIdfa;
                } else {
                    self->_idfa = @"0";
                }
            }];
            return @"0";
        } else {
            if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {}
            NSString *strIdfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            NSString *temp = [strIdfa stringByReplacingOccurrencesOfString:@"-" withString:@""];
            temp = [temp stringByReplacingOccurrencesOfString:@"0" withString:@""];
            if (temp.length < 1) {
                strIdfa = @"0";
            }
            _idfa = strIdfa;
            return strIdfa;
        }
    }
    else {
        return _idfa;
    }
}

- (NSString *)strIP {
    if (_strIP.length == 0) {
        NSURL *ipURL = [NSURL URLWithString:@"http://dcs.coohua.com/ip"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:ipURL];
        request.HTTPMethod = @"GET";
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data != nil) {
            NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            _strIP = ([dicInfo[@"ip"] length] != 0) ? dicInfo[@"ip"] : @"";
        }
    }
    return _strIP ?: @"";
}

- (BOOL)isJailBreak {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
        return YES;
    }
    return NO;
}

- (NSString *)deviceLanguage {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *arrLanguages = [defs objectForKey:@"AppleLanguages"];
    NSString *strPreferredLang = arrLanguages[0];
    return strPreferredLang;
}

- (NSString *)strDeviceResolution {
    CGSize size = [UIScreen mainScreen].currentMode.size;
    NSString *strResolution = [NSString stringWithFormat:@"%ld x %ld", (long)size.width, (long)size.height];
    return strResolution;
}

- (NSString *)network {
    NSInteger ac = [[NENetWorkMonitor sharedMonitor].networkTypeNumber integerValue];
    if (ac == 5) {
        return @"wifi";
    }
    if (ac == 3) {
        return @"4g";
    }
    if (ac == 2) {
        return @"3g";
    }
    if (ac == 1) {
        return @"2g";
    }
    return @"unknow";
}

- (NSString *)carrierName {
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];
    if (carrier == nil) {
        return @"Unkown";
    }
    NSString *networkCode = [carrier mobileNetworkCode];
    NSString *countryCode = [carrier mobileCountryCode];
    
    NSString *carrierName = nil;
    //中国运营商
    if (countryCode && [countryCode isEqualToString:@"460"]) {
        if (networkCode) {
            
            //中国移动
            if ([networkCode isEqualToString:@"00"] || [networkCode isEqualToString:@"02"] || [networkCode isEqualToString:@"07"] || [networkCode isEqualToString:@"08"]) {
                carrierName= @"中国移动";
            }
            //中国联通
            if ([networkCode isEqualToString:@"01"] || [networkCode isEqualToString:@"06"] || [networkCode isEqualToString:@"09"]) {
                carrierName= @"中国联通";
            }
            //中国电信
            if ([networkCode isEqualToString:@"03"] || [networkCode isEqualToString:@"05"] || [networkCode isEqualToString:@"11"]) {
                carrierName= @"中国电信";
            }
            //中国卫通
            if ([networkCode isEqualToString:@"04"]) {
                carrierName= @"中国卫通";
            }
            //中国铁通
            if ([networkCode isEqualToString:@"20"]) {
                carrierName= @"中国铁通";
            }
        }
    }
    return carrierName ?: @"Unkown";
}

- (NSString *)getDeviceIPAddresses {
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}


- (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

- (NSString *)getIpAddressWIFI {
    return [self ipAddressWithIfaName:@"en0"];
}

- (NSString *)cellIP {
    return [self ipAddressWithIfaName:@"pdp_ip0"];
}

@end
