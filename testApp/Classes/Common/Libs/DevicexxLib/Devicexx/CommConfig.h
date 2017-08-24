//
//  UserManager.h
//  Devicexx
//
//  Created by yager on 8/15/2016.
//  Copyright © 2016年 device++. All rights reserved.
//
#import <UIKit/UIKit.h>

/**
 * 服务器路径配置 http://api.vcd.io:4567/v1/
 * 注意：此地址不能加上 "http://"
 */
UIKIT_EXTERN NSString * const NETWORK_URL;

/**
 * 合作厂商key、secret; 由Devcie++提供给合作厂商
 */
UIKIT_EXTERN NSString * const ACCESS_KEY;
UIKIT_EXTERN NSString * const ACCESS_SECRET;
UIKIT_EXTERN NSString * const VENDOR_ID;
UIKIT_EXTERN NSString * const APPNAME;
UIKIT_EXTERN int const MESSAGE_CODE_TIMEOUT;
//仅在DEBUG模式下打印日志，发布APP不会打印日志
#ifdef DEBUG
# define NSLog(fmt, ...) NSLog((@"%s -%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define NSLog(...) {}
#endif
