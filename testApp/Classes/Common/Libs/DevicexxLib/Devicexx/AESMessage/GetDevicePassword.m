//
//  GetDevicePassword.m
//  AESMessage
//
//  Created by YanqiaoW on 16/11/29.
//  Copyright © 2016年 Device++. All rights reserved.
//

#import "GetDevicePassword.h"

@interface GetDevicePassword ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation GetDevicePassword


//单例
+ (GetDevicePassword *)sharedInstance
{
    static GetDevicePassword *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[GetDevicePassword alloc] init];
    });
    return _instance;
}

//懒加载
- (NSMutableDictionary *)dictionary
{
    if (!_dictionary) {
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dictionary;
}

//获取devicePassword
- (NSString *)getDevicePassword:(NSString *)deviceId
{
    return [self.dictionary objectForKey:deviceId];
}

//设置devicePassword, 传入在线列表返回数组
- (void)setDictionaryWithArray:(NSArray *)array
{
    [self.dictionary removeAllObjects];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        [self.dictionary setObject:dic[@"devicePassword"] forKey:dic[@"deviceId"]];
    }
}

@end
