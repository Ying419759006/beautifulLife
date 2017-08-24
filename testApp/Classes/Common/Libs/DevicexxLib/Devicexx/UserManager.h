//
//  UserManager.h
//  Devicexx
//
//  Created by yager on 8/15/2016.
//  Copyright © 2016年 device++. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (UserManager *)sharedInstance;

/**
 *  获取手机验证码
 */
- (void)getMessage:(NSString *)phone templateId:(int)templateId completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

/**
 * 用户名、密码进行注册
 */
- (void)registerWithPassword:(NSString *)password userCode:(NSString *)userCode messageCode:(NSString *)messageCode mobile:(NSString *)mobile completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

//找回密码接口实现
- (void)resetPasswordWithPassword:(NSString *)password userCode:(NSString *)userCode messageCode:(NSString *)messageCode mobile:(NSString *)mobile completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

/**
 * 用户名、密码进行登录
 */
- (void)loginUserName:(NSString *)username
             password:(NSString *)password
    completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

/**
 *  用户名进行设备绑定操作
 */
- (void)bindingDeviceForUser:(NSString *)userToken Host:(NSString *)deviceHost devicePort:(UInt16)devicePort completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

/**
 * 单纯的绑定用户
 */
- (void)bindDeviceWithUserToken:(NSString *)userToken deviceId:(NSString *)deviceId password:(NSString *)devicePassword deviceAccessKey:(NSString *)deviceAccessKey deviceTs:(NSString *)deviceTs completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

/**
 *  用户名进行设备解除绑定操作
 */
- (void)unbindDeviceForUser:(NSString *)userToken deviceId:(NSString *)deviceId devicePassword:(NSString *)devicePassword
          completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

/**
 * 用户进行设备部署，获取设备的信息
 */
- (void)deployDeviceForUser:(NSString *)userToken
                 deviceInfo:(NSDictionary *)devInfo
          completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

/**
 *  用户批量部署设备
 */
- (void)batchDeployForUser:(NSString *)userToken completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
;

/**
 * 获取用户绑定过的设备列表
 */
- (void)getDeviceListForUser:(NSString *)userToken
        completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

//新增用户更改设备名称
- (void)updateDeviceInfoWithDviceName:(NSString *)deviceName userToken:(NSString *)userToken deviceId:(NSString *)deviceId completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

//新增用户更改用户名(昵称)
- (void)updateUserInfoWithUserId:(NSString *)userId username:(NSString *)username completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

//新增查询用户信息
- (void)getUserInfoWithUserId:(NSString *)userId completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

//新增查询产品信息接口
- (void)getVendorInfoCompletionHandler:(void (^)(id responseJSON, NSError *error))completionHandler;

@end
