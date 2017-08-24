//
//  GetDevicePassword.h
//  AESMessage
//
//  Created by YanqiaoW on 16/11/29.
//  Copyright © 2016年 Device++. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetDevicePassword : NSObject


+ (GetDevicePassword *)sharedInstance;

//设置devicePassword
- (void)setDictionaryWithArray:(NSArray *)array;

//获取devicePassword
- (NSString *)getDevicePassword:(NSString *)deviceId;

@end
