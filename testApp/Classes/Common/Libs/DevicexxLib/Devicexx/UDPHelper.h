//
//  UDPHelper.h
//  Devicexx
//
//  Created by YanqiaoW on 16/12/9.
//  Copyright © 2016年 device++. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDPHelper : NSObject

//单例
+ (UDPHelper *)sharedInstance;

//开启本地UDP的接收服务
- (void)openUDPServer;

//关闭本地UDP的接收服务
- (void)closeUDPServer;

/**
 * 获取周边的设备列表
 */
- (void)discoverDeviceCompletionHandler:(void (^)(NSArray *deviceList, NSError *error))completionHandler;

//新增获取设备productName接口, 为nil代表不是厂商productId, 可忽略设备
- (NSString *)getProductNameJudgeVendorDeviceWithProductId:(NSString *)productId;

/**
 * 绑定设备前置条件，获取设备的密码等信息
 */
- (void)bindingDeviceHost:(NSString *)deviceHost
               devicePort:(UInt16)devicePort
        completionHandler:(void (^)(NSDictionary *devInfo, NSError *error))completionHandler;

/**
 * AP模式让设备入网
 */
- (void)APLink:(NSString *)ssid
      password:(NSString *)password
completionHandler:(void (^)(NSDictionary *devInfo, NSError *error))completionHandler;

/**
 * 智能链接的反馈
 */
- (void)receiveSmartLinkCompletionHandler:(void (^)(NSDictionary *devInfo, NSError *error))completionHandler;

/**
 * 设备入网成功的反馈
 */
- (void)networkSuccessCompletionHandler:(void (^)(NSDictionary *devInfo, NSError *error))completionHandler;

@end
