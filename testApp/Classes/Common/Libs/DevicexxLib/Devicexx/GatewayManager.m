//
//  GatewayManager.m
//  Devicexx
//
//  Created by YanqiaoW on 16/12/20.
//  Copyright © 2016年 device++. All rights reserved.
//

#import "GatewayManager.h"
#import "NSMutableDictionary+dealNil.h"
#import "CommConfig.h"
#import "EncryptionTool.h"
#import "MKNetworkKit.h"

@implementation GatewayManager

+ (GatewayManager *)sharedInstance
{
    static GatewayManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[GatewayManager alloc] init];
    });
    return _instance;
}

//获取子设备id
- (void)getDeviceInfoWithMac:(NSString *)mac imei:(NSString *)imei icid:(NSString *)icid completionHandler:(void (^)(NSDictionary *responseJSON, NSError *error))completionHandler
{
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:mac forKey:@"mac"];
    [params setObjectDealNil:imei forKey:@"imei"];
    [params setObjectDealNil:icid forKey:@"icid"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:imei forKey:@"imei"];
    [tmpDic setObjectDealNil:icid forKey:@"icid"];
    [tmpDic setObjectDealNil:mac forKey:@"mac"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"[getSubDeviceId]--->signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"gateway/validate?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];

}

//绑定网关与子设备
- (void)bindGatewayAndSubDeviceWithSubDeviceId:(NSString *)subDeviceId gatewayId:(NSString *)gatewayId completionHandler:(void (^)(NSDictionary *responseJSON, NSError *error))completionHandler
{
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:subDeviceId forKey:@"subDeviceId"];
    [params setObjectDealNil:gatewayId forKey:@"gatewayId"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:subDeviceId forKey:@"subDeviceId"];
    [tmpDic setObjectDealNil:gatewayId forKey:@"gatewayId"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"[bindGatewayAndSubDevice] signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"gateway/bind?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
    
}

//解除网关与子设备的绑定关系
- (void)unbindGatewayAndSubDeviceWithSubDeviceId:(NSString *)subDeviceId gatewayId:(NSString *)gatewayId completionHandler:(void (^)(NSDictionary *responseJSON, NSError *error))completionHandler
{
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:subDeviceId forKey:@"subDeviceId"];
    [params setObjectDealNil:gatewayId forKey:@"gatewayId"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:subDeviceId forKey:@"subDeviceId"];
    [tmpDic setObjectDealNil:gatewayId forKey:@"gatewayId"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"[unbindGatewayAndSubDevice] signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"gateway/unbind?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}

//获取设备绑定网关列表
- (void)getBindGatewaylistWithGatewayId:(NSString *)gatewayId completionHandler:(void (^)(NSDictionary *responseJSON, NSError *error))completionHandler
{
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:gatewayId forKey:@"deviceId"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:gatewayId forKey:@"deviceId"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"[getSubdevicelist] signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"gateway/gatewaylist?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}

@end
