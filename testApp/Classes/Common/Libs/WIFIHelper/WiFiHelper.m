//
//  WiFiHelper.m
//
//  Created by zhaoying on 16/7/22.
//  Copyright © 2016年 赵莹. All rights reserved.
//
//

#import "WiFiHelper.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import "Reachability.h"

@implementation WiFiHelper

+(NSString *) currentWifiSSID
{
#if TARGET_OS_SIMULATOR
    return @"(simulator)";
#else
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"] ;
    
    return ssid;
#endif
}

+(NSString *) currentWifiBSSID
{
#if TARGET_OS_SIMULATOR
    return @"(simulator)";
#else
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *bssid = [dctySSID objectForKey:@"BSSID"] ;
    
    return bssid;
#endif
}

+(NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

+ (Boolean)isWiFiOpen{
    
    Boolean result = false;
    Reachability *r= [Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus] == ReachableViaWiFi) {
        //成功运行
        result = true;
    } else {
        result = false;
    }
    return result;
}


@end
