//
//  WiFiHelper.h
//
//  Created by zhaoying on 16/7/22.
//  Copyright © 2016年 赵莹. All rights reserved.
//
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <Foundation/Foundation.h>

@interface WiFiHelper : NSObject

/**
 *  获取当前WIFI的SSID
 *
 *  @return SSID String
 */
+(NSString *) currentWifiSSID;


/**
 *  获取当前WIFI的BSSID (增加此方法是为了解决多个同名wifi问题)
 *
 *  @return BSSID String
 */
+(NSString *) currentWifiBSSID;

/**
 *  获取IP地址
 *
 *  @return <#return value description#>
 */
+(NSString *) localWiFiIPAddress;

+ (Boolean)isWiFiOpen;

@end
