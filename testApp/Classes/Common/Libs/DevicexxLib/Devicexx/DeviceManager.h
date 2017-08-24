//
//  DeviceManager.h
//  Devicexx
//
//  Created by yager on 8/15/2016.
//  Copyright © 2016年 device++. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceManager : NSObject

+ (DeviceManager *)sharedInstance;

#pragma mark ---以下为设备控制功能部分---start

//此MQTT连接是否可以用来发布(控制)设备
- (BOOL)isCanPublish:(NSString *)serverUrl;

//取消所有client
- (void)disconnectAllServerUrl;

/**
 * 控制设备状态的初始化, 字典类型数据回调
 */
- (void)openMQTTServerWithUserId:(NSString *)userId
                       serverUrl:(NSString *)serverUrl
                        userName:(NSString *)username
                        password:(NSString *)password
                            uuid:(NSString *)uuid
               completionHandler:(void (^)(NSString *deviceId, NSDictionary *devInfo, NSError *error))completionHandler;

/**
 * 控制设备状态的初始化, 字典类型数据回调 与 NSData类型数据回调
 */
- (void)openMQTTServerWithUserId:(NSString *)userId
                       serverUrl:(NSString *)serverUrl
                        userName:(NSString *)username
                        password:(NSString *)password
                            uuid:(NSString *)uuid
               completionHandler:(void (^)(NSString *deviceId, NSDictionary *devInfo, NSError *error))completionHandler
        rawDataCompletionHandler:(void (^)(NSString *deviceId, NSData *data, NSError *error))rawDataCompletionHandler;


/**
 * 控制设备状态的开关状态
 */
- (void)publishMessage:(NSString *)deviceId serverUrl:(NSString *)serverUrl params:(NSDictionary *)params;


/**
 * 控制设备状态的开关状态(参数为NSData类型)
 */
- (void)publishMessage:(NSString *)deviceId serverUrl:(NSString *)serverUrl data:(NSData *)data;

#pragma mark ---设备控制功能部分结束---end

//新增订阅规则
- (void)subscribeMessage:(NSString *)deviceId serverUrl:(NSString *)serverUrl;

@end
