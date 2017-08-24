//
//  Tool.h
//  SmartDeviceSDK
//
//  Created by YanqiaoW on 16/8/24.
//  Copyright © 2016年 yiweibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username;

//上一次登录名/手机号
@property (nonatomic, copy) NSString *lastUsername;

//登录密码
@property (nonatomic, copy) NSString *password;

//手机号
@property (nonatomic, copy) NSString *mobile;

//记录是否为切换账户登录
@property (nonatomic, assign) BOOL isChangeAccount;

//产品vendorID数组
@property (nonatomic, strong) NSMutableDictionary *vendorIdDictionary;

//wifi密码
@property (nonatomic, copy) NSString *wifiPassword;

+ (Tool *)sharedTool;

+ (BOOL)hasLogin;
+ (void)setLogin:(BOOL)flag;

+ (BOOL)isLink;
+ (void)setIsLink:(BOOL)flag;

+ (NSString *)uuid;

//失败提示框, 能自定义拼接文字, 默认灰色, 提示2秒
- (void)showErrorCodeSVProgressHUD:(NSString *)customString withAppendingString:(NSDictionary *)dictionary;

//失败提示框, 能自定义拼接文字, 默认灰色, 提示2秒
+ (void)showErrorSVProgressHUDWithStatus:(NSString *)customString withAppendingString:(NSObject *)object;

//失败提示框, 只提示输入字符串, 不拼接, 默认灰色, 提示2秒
+ (void)showErrorSVProgressHUDWithStatus:(NSString *)customString;

//成功提示框, 能自定义拼接文字, 默认灰色, 提示2秒
+ (void)showSuccessSVProgressHUDWithStatus:(NSString *)customString withAppendingString:(NSObject *)object;

//成功提示框, 只提示输入字符串, 不拼接, 默认灰色, 提示2秒
+ (void)showSuccessSVProgressHUDWithStatus:(NSString *)customString;

//成功提示框, 只提示输入字符串, 不拼接, 默认灰色, 提示2秒
+ (void)showWarningSVProgressHUDWithStatus:(NSString *)customString time:(int)time;

@end
