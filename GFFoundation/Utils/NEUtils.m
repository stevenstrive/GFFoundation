//
//  NEUtils.m
//  NEFoundation
//
//  Created by zhubch on 2018/8/9.
//

#import "NEUtils.h"
#import "NEFoundation.h"
#import <AudioToolbox/AudioToolbox.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

NSBundle *resourceBundle(Class clazz) {
    NSBundle *bundle = [NSBundle bundleForClass:clazz];
    NSURL *bundleURL = [bundle URLForResource:@"Resource" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:bundleURL];
    return bundle;
}

UIColor *randomColor() {
    return ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f]);
}

NSDictionary *getIPAddresses(){
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

NSString *getIPAddress(BOOL preferIPv4){
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = getIPAddresses();
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

NSString* resolveHost(NSString *hostname) {
    Boolean result;
    CFHostRef hostRef;
    CFArrayRef addresses;
    NSString *ipAddress = nil;
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL); 
        if (result) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    if (result) {
        CFIndex index = 0;
        CFDataRef ref = (CFDataRef) CFArrayGetValueAtIndex(addresses, index);
        
        int port=0;
        struct sockaddr *addressGeneric;
        
        NSData *myData = (__bridge NSData *)ref;
        addressGeneric = (struct sockaddr *)[myData bytes];
        
        switch (addressGeneric->sa_family) {
            case AF_INET: {
                struct sockaddr_in *ip4;
                char dest[INET_ADDRSTRLEN];
                ip4 = (struct sockaddr_in *)[myData bytes];
                port = ntohs(ip4->sin_port);
                ipAddress = [NSString stringWithFormat:@"%s", inet_ntop(AF_INET, &ip4->sin_addr, dest, sizeof dest)];
            }
                break;
                
            case AF_INET6: {
                struct sockaddr_in6 *ip6;
                char dest[INET6_ADDRSTRLEN];
                ip6 = (struct sockaddr_in6 *)[myData bytes];
                port = ntohs(ip6->sin6_port);
                ipAddress = [NSString stringWithFormat:@"%s", inet_ntop(AF_INET6, &ip6->sin6_addr, dest, sizeof dest)];
            }
                break;
            default:
                ipAddress = nil;
                break;
        }
    }
    
    return ipAddress;
}

BOOL testEnvOr(BOOL value) {
    return value;
//    return NEAPI.env == kNEHTTPAPITest || value;
}

id nullsafe_pack(id value) {
    if (value) {
        return value;
    }
    return NSNull.null;
}

id nullsafe_unpack(id value) {
    if (value && value != NSNull.null) {
        return value;
    }
    return nil;
}

void share(id content) {
    if (content == nil) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[content] applicationActivities:nil];

    activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
    };
    [UIViewController.topMost presentViewController:activityVC animated:YES completion:^{

    }];
}

NSString *formatWan(NSInteger num) {
    if (num > 10000) {
        if (num % 1000 == 0) {
            return [NSString stringWithFormat:@"%.1fW", num/10000.0];
        } else {
            return [NSString stringWithFormat:@"%.2fW", num/10000.0];
        }
    } else {
        return [NSString stringWithFormat:@"%ld", num];
    }
}

void retry(int times,BOOL(^task)(int times)) {
    if (task(0)) {
        return;
    }
    if (times <= 0) {
        return;
    }
    __block BOOL stop = NO;
    for (int i = 1; i < times + 1; i ++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (stop) {
                return;
            }
            stop = task(i);
        });
    }
}
