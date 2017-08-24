//
//  RegularExpressionManager.h
//  SmartDevice
//
//  Created by YanqiaoW on 16/10/25.
//  Copyright © 2016年 ewbao. All rights reserved.
//  使用正则表达式匹配一些常用字符串工具类

#import <Foundation/Foundation.h>

@interface RegularExpressionManager : NSObject

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;

@end
