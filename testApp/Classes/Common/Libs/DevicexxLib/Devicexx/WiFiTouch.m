//
//  WiFiTouch.m
//  Devicexx
//
//  Created by yager on 8/15/2016.
//  Copyright © 2016年 device++. All rights reserved.
//

#import "WiFiTouch.h"
#import "Esptouch1.h"
#import "ESPUDPSocketServer.h"

typedef void (^GetIpCompletionHandler)(NSData *data);

@interface WiFiTouch()<ESPUDPSocketServerDelegate>

@property (nonatomic, strong) __block volatile Esptouch1* esptouch1;
@property (nonatomic, assign) __block volatile BOOL isEsptouch1StartSuc;
@property (nonatomic, assign) __block volatile NSTimeInterval startTimestamp;
@property (nonatomic, assign) __block volatile NSTimeInterval timeout;

//接收到设备ip回调block
@property (nonatomic, copy) GetIpCompletionHandler controlHandler;

@end

@implementation WiFiTouch

+ (WiFiTouch *)sharedTouch
{
    static WiFiTouch *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[WiFiTouch alloc]init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static id _id = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _id = [super allocWithZone:zone];
    });
    return _id;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.startTimestamp = -1.0;
        self.timeout = -1.0;
    }
    return self;
}

- (BOOL) isTimeout
{
    if (self.startTimestamp < 0 || self.timeout < 0)
    {
        return YES;
    }
    NSDate* date = [[NSDate alloc]init];
    NSTimeInterval now = [date timeIntervalSince1970];
    BOOL isTimeout = now > (self.startTimestamp + self.timeout);
    return isTimeout;
}

- (void)smartLink:(NSString*)ssid key:(NSString*)password timeout:(int)timeout
{
    @synchronized(self)
    {
        NSLog(@"Esptouch start() ssid:%@,psw:%@,timeout:%d",ssid,password,timeout);
        if ([self isRunning])
        {
            NSLog(@"Esptouch WARN: start() one task is running, so stop it before start a new one");
            [self stop];
        }
        self.esptouch1 = [[Esptouch1 alloc]init];
        self.isEsptouch1StartSuc = [self.esptouch1 start:ssid key:password timeout:timeout]; //多个wifi重名bug
        self.timeout = timeout;
        NSDate* date = [[NSDate alloc]init];
        NSTimeInterval now = [date timeIntervalSince1970];
        // self.startTimestamp is 100ms more than the real time to fix the timeout defect
        self.startTimestamp = now + 0.1;
    }
}

//- (void)smartLink:(NSString*)ssid key:(NSString*)password timeout:(int)timeout
- (void)smartLink:(NSString*)ssid bssid:(NSString *)bssid key:(NSString*)password isHiden:(BOOL)isHiden timeout:(int)timeout
{
    @synchronized(self)
    {
        NSLog(@"Esptouch start() ssid:%@,psw:%@,timeout:%d",ssid,password,timeout);
        if ([self isRunning])
        {
            NSLog(@"Esptouch WARN: start() one task is running, so stop it before start a new one");
            [self stop];
        }
        self.esptouch1 = [[Esptouch1 alloc]init];
//        self.isEsptouch1StartSuc = [self.esptouch1 start:ssid key:password timeout:timeout]; //多个wifi重名bug
        
        //使用新方法
        self.isEsptouch1StartSuc = [self.esptouch1 start:ssid bssid:bssid isHiden:isHiden key:password timeout:timeout];
        self.timeout = timeout;
        NSDate* date = [[NSDate alloc]init];
        NSTimeInterval now = [date timeIntervalSince1970];
        // self.startTimestamp is 100ms more than the real time to fix the timeout defect
        self.startTimestamp = now + 0.1;
    }
}

- (void)stop
{
    @synchronized(self)
    {
        NSLog(@"Esptouch stop()");
        if (self.esptouch1 != nil)
        {
            [self.esptouch1 stop];
            self.esptouch1 = nil;
            self.isEsptouch1StartSuc = NO;
            self.startTimestamp = -1.0;
            self.timeout = -1.0;
        }
    }
}

- (BOOL)isRunning
{
    @synchronized(self)
    {
        if (self.esptouch1 != nil && self.isEsptouch1StartSuc)
        {
            return ![self isTimeout];
        }
        else
        {
            return NO;
        }
    }
}

//代理方法
- (void)espUDPSocketServerGetIpdeviceGetIp:(NSData *)data
{
    if (self.controlHandler) {
        self.controlHandler(data);
    }
    NSLog(@"获取设备ip--->%@",data);
}

- (void)deviceGetIp:(void (^)(NSData *data))completionHandler
{
    self.controlHandler = completionHandler;
}

@end
