//
//  Esptouch.h
//  Esptouch
//
//  Created by 白 桦 on 10/12/15.
//  Copyright (c) 2015 白 桦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Esptouch1 : NSObject

//新增
- (bool)start:(NSString *)ssid bssid:(NSString *)bssid isHiden:(BOOL)isHiden key:(NSString *)key timeout:(int)timeout;

- (bool)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout;

- (void)stop;

@end
