//
//  WiFiTouch.h
//  Devicexx
//
//  Created by yager on 8/15/2016.
//  Copyright © 2016年 device++. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  智能入网，此类用于让设备智能上网，保证在WIFI环境中进行
 */
@interface WiFiTouch : NSObject

+ (WiFiTouch *)sharedTouch;

/**
 * 智能入网，为设备提供上网的WIFI账号和密码，确保在WIFI环境中使用此方法；
 *
 * @param ssid WIFI账号名称
 * @param password WIFI账号密码
 *
 */
- (void)smartLink:(NSString*)ssid key:(NSString*)password timeout:(int)timeout; //此方法多个wifi重名时有bug

- (void)smartLink:(NSString*)ssid bssid:(NSString *)bssid key:(NSString*)password isHiden:(BOOL)isHiden timeout:(int)timeout;

- (void)stop;

- (BOOL)isRunning;

//获取到设备ip回调
- (void)deviceGetIp:(void (^)(NSData *data))completionHandler;

@end
