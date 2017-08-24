//
//  Esptouch.m
//  Esptouch
//
//  Created by 白 桦 on 10/12/15.
//  Copyright (c) 2015 白 桦. All rights reserved.
//

#import "Esptouch1.h"
#import "ESPTouchTask.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface Esptouch1()

@property (nonatomic, strong) ESPTouchTask *task;

@end

@implementation Esptouch1

//- (void)start:(NSString*)ssid bssid:(NSString*)bssid key:(NSString*)key timeout:(int)timeout
//{
//    @synchronized(self)
//    {
//        if (self.task == nil)
//        {
//            self.task = [[ESPTouchTask alloc]initWithApSsid:ssid andApBssid:bssid andApPwd:key andIsSsidHiden:YES andTimeoutMillisecond:timeout * 1000];
//            [self.task executeForResults:0];
//        }
//    }
//}

// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        // NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

//新增
- (bool)start:(NSString *)ssid bssid:(NSString *)bssid isHiden:(BOOL)isHiden key:(NSString *)key timeout:(int)timeout
{
    @synchronized(self)
    {
        if (self.task != nil)
        {
            // task is executing, so do nothing
            NSLog(@"Esptouch1 ERROR: task is executing, do nothing else");
            return NO;
        }
        NSDictionary *apInfo = [self fetchNetInfo];
        if (apInfo!=nil)
        {
            NSString *apSsid = [apInfo objectForKey:@"SSID"];
            
            NSString *apBssid = @"";
            if (bssid == nil) {
                apBssid = [apInfo objectForKey:@"BSSID"];
            } else {
                apBssid = bssid;
            }
            
//            NSString *apBssid = [apInfo objectForKey:@"BSSID"];
            if ([ssid isEqualToString:apSsid])
            {
                dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    self.task = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:key andIsSsidHiden:isHiden andTimeoutMillisecond:timeout * 1000];
                    
                    [self.task executeForResults:0];
                });
                return YES;
            }
            else
            {
                NSLog(@"Esptouch1 WARN: ssid is invalid, do nothing");
                return NO;
            }
        }
        else
        {
            NSLog(@"Esptouch1 WARN: can't get AP info");
            return NO;
        }
    }
}

- (bool)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout
{
    return [self start:ssid bssid:nil isHiden:YES key:key timeout:timeout];
//    @synchronized(self)
//    {
//        if (self.task != nil)
//        {
//            // task is executing, so do nothing
//            NSLog(@"Esptouch1 ERROR: task is executing, do nothing else");
//            return NO;
//        }
//        NSDictionary *apInfo = [self fetchNetInfo];
//        if (apInfo!=nil)
//        {
//            NSString *apSsid = [apInfo objectForKey:@"SSID"];
//            NSString *apBssid = [apInfo objectForKey:@"BSSID"];
//            if ([ssid isEqualToString:apSsid])
//            {
//                dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                dispatch_async(queue, ^{
//                    self.task = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:key andIsSsidHiden:YES andTimeoutMillisecond:timeout * 1000];
//                    
//                    [self.task executeForResults:0];
//                });
//                return YES;
//            }
//            else
//            {
//                NSLog(@"Esptouch1 WARN: ssid is invalid, do nothing");
//                return NO;
//            }
//        }
//        else
//        {
//            NSLog(@"Esptouch1 WARN: can't get AP info");
//            return NO;
//        }
//    }
}

- (void)stop
{
    @synchronized(self)
    {
        if (self.task != nil)
        {
            [self.task interrupt];
        }
    }
}

@end
