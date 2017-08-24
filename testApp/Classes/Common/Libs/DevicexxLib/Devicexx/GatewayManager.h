//
//  GatewayManager.h
//  Devicexx
//
//  Created by YanqiaoW on 16/12/20.
//  Copyright © 2016年 device++. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GatewayManager : NSObject

+ (GatewayManager *)sharedInstance;

//获取设备信息
- (void)getDeviceInfoWithMac:(NSString *)mac imei:(NSString *)imei icid:(NSString *)icid completionHandler:(void (^)(NSDictionary *responseJSON, NSError *error))completionHandler;

//绑定网关与子设备
- (void)bindGatewayAndSubDeviceWithSubDeviceId:(NSString *)subDeviceId gatewayId:(NSString *)gatewayId completionHandler:(void (^)(NSDictionary *responseJSON, NSError *error))completionHandler;

//解除网关与子设备的绑定关系
- (void)unbindGatewayAndSubDeviceWithSubDeviceId:(NSString *)subDeviceId gatewayId:(NSString *)gatewayId completionHandler:(void (^)(NSDictionary *responseJSON, NSError *error))completionHandler;

//获取设备绑定网关列表
- (void)getBindGatewaylistWithGatewayId:(NSString *)gatewayId completionHandler:(void (^)(NSDictionary *responseJSON, NSError *error))completionHandler;

@end
