//
//  UserManager.m
//  Devicexx
//
//  Created by yager on 8/15/2016.
//  Copyright © 2016年 device++. All rights reserved.
//

#import "UserManager.h"

#import "CommConfig.h"
#import "EncryptionTool.h"
#import "MKNetworkKit.h"
#import "DeviceManager.h"
#import "GetDevicePassword.h"

#import "NSMutableDictionary+dealNil.h"
#import "UDPHelper.h"

@implementation UserManager

+ (UserManager *)sharedInstance
{
    static UserManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UserManager alloc] init];
    });
    return _instance;
}

//获取手机验证码
- (void)getMessage:(NSString *)phone templateId:(int)templateId completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    //queryString--->user/messagecode?accessKey=b6fd39ac8d920c706f4cba1c2b7f9ac9&ts=1477985172&signature=9f865708c4e62ced206fe28f3418c9d4
    // 时间戳
    long ts  = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    NSArray *mobile = @[phone];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:mobile forKey:@"mobile"];
    [params setObjectDealNil:APPNAME forKey:@"appName"];
    [params setObjectDealNil:[NSString stringWithFormat:@"%d",templateId] forKey:@"templateId"];
    [params setObjectDealNil:[NSString stringWithFormat:@"%d",MESSAGE_CODE_TIMEOUT] forKey:@"time"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:APPNAME forKey:@"appName"];
    [tmpDic setObjectDealNil:[NSString stringWithFormat:@"%d",templateId] forKey:@"templateId"];
    [tmpDic setObjectDealNil:[NSString stringWithFormat:@"%d",MESSAGE_CODE_TIMEOUT] forKey:@"time"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/messagecode?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];

    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {

        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    
    [hostNet startRequest:requestNetWork];
}

//用户注册接口实现
- (void)registerWithPassword:(NSString *)password userCode:(NSString *)userCode messageCode:(NSString *)messageCode mobile:(NSString *)mobile completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    
    // curl -X POST -H "Content-Type: application/json"
    // "http://api.vcd.io:4567/v1/user/register?accessKey=8e0bb23839955bde1346b6e9395347ff&ts=1465541792000&signature=ad36b179e3d1fb9f8fb368c4b9e99010"
    // -d '{"username":"ab1cd23223", "password":"9805e8d786b5d2888bdbbcedd0ebce27"}'
    
    // 时间戳
    long ts  = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    // 1，密码做一次MD5加密
    password = [EncryptionTool md5String:password];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:password forKey:@"password"];
    [params setObjectDealNil:userCode forKey:@"userCode"];
    [params setObjectDealNil:messageCode forKey:@"messageCode"];
    [params setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    [params setObjectDealNil:mobile forKey:@"mobile"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:password forKey:@"password"];
    [tmpDic setObjectDealNil:userCode forKey:@"userCode"];
    [tmpDic setObjectDealNil:messageCode forKey:@"messageCode"];
    [tmpDic setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    [tmpDic setObjectDealNil:mobile forKey:@"mobile"];

    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/register?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {

        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    
    // NSLog(@"desc === %@", [requestNetWork description]);
    [hostNet startRequest:requestNetWork];
}

//找回密码接口实现
- (void)resetPasswordWithPassword:(NSString *)password userCode:(NSString *)userCode messageCode:(NSString *)messageCode mobile:(NSString *)mobile completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    
    // curl -X POST -H "Content-Type: application/json"
    // "http://api.vcd.io:4567/v1/user/register?accessKey=8e0bb23839955bde1346b6e9395347ff&ts=1465541792000&signature=ad36b179e3d1fb9f8fb368c4b9e99010"
    // -d '{"username":"ab1cd23223", "password":"9805e8d786b5d2888bdbbcedd0ebce27"}'
    
    // 时间戳
    long ts  = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    // 1，密码做一次MD5加密
    password = [EncryptionTool md5String:password];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:password forKey:@"password"];
    [params setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    [params setObjectDealNil:messageCode forKey:@"messageCode"];
    [params setObjectDealNil:userCode forKey:@"userCode"];
    [params setObjectDealNil:mobile forKey:@"mobile"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:password forKey:@"password"];
    [tmpDic setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    [tmpDic setObjectDealNil:messageCode forKey:@"messageCode"];
    [tmpDic setObjectDealNil:userCode forKey:@"userCode"];
    [tmpDic setObjectDealNil:mobile forKey:@"mobile"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/resetpassword?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
 
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    
    [hostNet startRequest:requestNetWork];
}

//用户登录接口实现
- (void)loginUserName:(NSString *)username
             password:(NSString *)password
    completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    
    //curl -X POST -H "Content-Type: application/json"
    //    "http://api.vcd.io:4567/v1/user/token?accessKey=8e0bb23839955bde1346b6e9395347ff&ts=1465541792000&signature=ad36b179e3d1fb9f8fb368c4b9e99010"
    //    -d '{"username":"ab1cd23223", "password":"2e54a9c498f19a02f4d67264b1750c85"}'
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    // 1，密码做一次MD5加密
    password = [EncryptionTool md5String:password];
    
    //计算新密码策略
    NSString *newPassword = [NSString stringWithFormat:@"%@%@%@", ACCESS_SECRET, password, tsStr];
    newPassword = [EncryptionTool md5String:newPassword];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:username forKey:@"username"];
    [params setObjectDealNil:newPassword forKey:@"password"];
    [params setObjectDealNil:VENDOR_ID forKey:@"vendorId"];

    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:username forKey:@"username"];
    [tmpDic setObjectDealNil:newPassword forKey:@"password"];
    [tmpDic setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);

    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/token?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}

//新合并绑定设备
- (void)bindingDeviceForUser:(NSString *)userToken Host:(NSString *)deviceHost devicePort:(UInt16)devicePort completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    // curl -X POST -H "Content-Type: application/json" "http://api.vcd.io:4567/v1/user/binding?accessKey=8e0bb23839955bde1346b6e9395347ff&ts=1465541792000&signature=ad36b179e3d1fb9f8fb368c4b9e99010"
    
    //    -d '{"userToken":"0beacd46-ee6f-4ad8-8800-9539542984f4","deviceId":"sa4nUnfQisGTZH3EmE8JEE", "devicePassword":"0a1704dee5ed7200fcea5f627f6d1fd1", "deviceAccessKey":"8e0bb23839955bde1346b6e9395347ff", "deviceTs":1465541792}'
    
    // 时间戳
//    long ts = [[NSDate date] timeIntervalSince1970];
//    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //    DeviceManager *deviceManager = [DeviceManager sharedInstance];
    UDPHelper *udpHelper = [UDPHelper sharedInstance];
    [udpHelper bindingDeviceHost:deviceHost devicePort:devicePort completionHandler:^(NSDictionary *devInfo, NSError *error) {
        NSLog(@"devInfo--->%@",devInfo);
        if(error)
        {
            NSLog(@"bindingDevice error%@",error.localizedDescription);
            return ;
        }
        if (!(devInfo.allKeys.count >0)) {
            NSLog(@"biningDevice");
        }
        //设备信息
        NSString *deviceAccessKey  = devInfo[@"accessKey"];
        NSString *devicePassword   = devInfo[@"password"];
        NSString *deviceId         = devInfo[@"deviceId"];
        NSString *deviceTs         = devInfo[@"ts"];
        
        [self bindDeviceWithUserToken:userToken deviceId:deviceId password:devicePassword deviceAccessKey:deviceAccessKey deviceTs:deviceTs completionHandler:^(id responseJSON, NSError *error) {
            
            if (completionHandler) {
                completionHandler(responseJSON, error);
            }
            
        }];
        
        //        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        //        [params setObjectDealNil:userToken forKey:@"userToken"];
        //        [params setObjectDealNil:deviceId forKey:@"deviceId"];
        //        [params setObjectDealNil:devicePassword forKey:@"devicePassword"];
        //        [params setObjectDealNil:deviceAccessKey forKey:@"deviceAccessKey"];
        //        [params setObjectDealNil:deviceTs forKey:@"deviceTs"];
        //        [params setObjectDealNil:@"mqtt" forKey:@"protocol"];
        //
        //        // 2，签名算法，自动对参数进行处理
        //        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
        //        [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
        //        [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
        //        [tmpDic setObjectDealNil:userToken forKey:@"userToken"];
        //        [tmpDic setObjectDealNil:deviceId forKey:@"deviceId"];
        //        [tmpDic setObjectDealNil:devicePassword forKey:@"devicePassword"];
        //        [tmpDic setObjectDealNil:deviceAccessKey forKey:@"deviceAccessKey"];
        //        [tmpDic setObjectDealNil:deviceTs forKey:@"deviceTs"];
        //        [tmpDic setObjectDealNil:@"mqtt" forKey:@"protocol"];
        //
        //        NSString *signature = [EncryptionTool generateSignature:tmpDic];
        //        NSLog(@"signature  == %@", signature);
        //
        //        //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
        //        MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
        //
        //        //实例一个请求对象MKNetworkRequest
        //        NSString *queryString = [NSString stringWithFormat:@"user/binding?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
        //        MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
        //        [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
        //        [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        //            if (completionHandler) {
        //                completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        //            }
        //        }];
        //        [hostNet startRequest:requestNetWork];
    }];
    
}

//单纯的绑定用户
- (void)bindDeviceWithUserToken:(NSString *)userToken deviceId:(NSString *)deviceId password:(NSString *)devicePassword deviceAccessKey:(NSString *)deviceAccessKey deviceTs:(NSString *)deviceTs completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //设备信息
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:userToken forKey:@"userToken"];
    [params setObjectDealNil:deviceId forKey:@"deviceId"];
    [params setObjectDealNil:devicePassword forKey:@"devicePassword"];
    [params setObjectDealNil:deviceAccessKey forKey:@"deviceAccessKey"];
    [params setObjectDealNil:deviceTs forKey:@"deviceTs"];
    [params setObjectDealNil:@"mqtt" forKey:@"protocol"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:userToken forKey:@"userToken"];
    [tmpDic setObjectDealNil:deviceId forKey:@"deviceId"];
    [tmpDic setObjectDealNil:devicePassword forKey:@"devicePassword"];
    [tmpDic setObjectDealNil:deviceAccessKey forKey:@"deviceAccessKey"];
    [tmpDic setObjectDealNil:deviceTs forKey:@"deviceTs"];
    [tmpDic setObjectDealNil:@"mqtt" forKey:@"protocol"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/binding?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}

//用户解除绑定设备接口实现
- (void)unbindDeviceForUser:(NSString *)userToken deviceId:(NSString *)deviceId devicePassword:(NSString *)devicePassword
          completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    // curl -X POST -H "Content-Type: application/json" "http://api.vcd.io:4567/v1/user/unbinding?accessKey=8e0bb23839955bde1346b6e9395347ff&ts=1465541792000&signature=ad36b179e3d1fb9f8fb368c4b9e99010"
    
    //    -d '{"userToken":"0beacd46-ee6f-4ad8-8800-9539542984f4","deviceId":"sa4nUnfQisGTZH3EmE8JEE", "devicePassword":"0a1704dee5ed7200fcea5f627f6d1fd1", "deviceAccessKey":"8e0bb23839955bde1346b6e9395347ff", "deviceTs":1465541792}'
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //设备密码进行二次加密
    devicePassword = [NSString stringWithFormat:@"%@%@%@", ACCESS_SECRET,devicePassword,tsStr];
    devicePassword = [EncryptionTool md5String:devicePassword];
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:userToken forKey:@"userToken"];
    [params setObjectDealNil:deviceId forKey:@"deviceId"];
    [params setObjectDealNil:devicePassword forKey:@"devicePassword"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:userToken forKey:@"userToken"];
    [tmpDic setObjectDealNil:deviceId forKey:@"deviceId"];
    [tmpDic setObjectDealNil:devicePassword forKey:@"devicePassword"];

    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/unbinding?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
    
}

//用户部署设备
/*
- (void)deployDeviceForUser:(NSString *)userToken
                 deviceInfo:(NSDictionary *)devInfo
          completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    //curl -X POST -H "Content-Type: application/json" "http://api.vcd.io:4567/v1/user/deploy?accessKey=8e0bb23839955bde1346b6e9395347ff&ts=1465541792&signature=ad36b179e3d1fb9f8fb368c4b9e99010"
    
    //    -d '{"userToken":"0beacd46-ee6f-4ad8-8800-9539542984f4","deviceId":"sa4nUnfQisGTZH3EmE8JEE", "devicePassword":"0a1704dee5ed7200fcea5f627f6d1fd1", "protocol":"mqtts"}'
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //设备信息
    NSString *deviceId       = devInfo[@"deviceId"];
    NSString *devicePassword = devInfo[@"devicePassword"];
    //计算新密码策略
    devicePassword = [NSString stringWithFormat:@"%@%@%@", ACCESS_SECRET, devicePassword, tsStr];
    devicePassword = [EncryptionTool md5String:devicePassword];
    
    NSDictionary *params = @{
                             @"userToken":userToken,
                             @"deviceId":deviceId,
                             @"devicePassword":devicePassword,
                             @"protocol":@"mqtt"
                             };
    
    // 2，签名算法，自动对参数进行处理
    NSDictionary *tmpDic = @{
                             @"accessKey":ACCESS_KEY,
                             @"ts":tsStr,
                             @"userToken":userToken,
                             @"deviceId":deviceId,
                             @"devicePassword":devicePassword,
                             @"protocol":@"mqtt"
                             };
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/deploy?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}*/

//用户批量部署设备
- (void)batchDeployForUser:(NSString *)userToken completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{

    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:userToken forKey:@"userToken"];
    [params setObjectDealNil:@"mqtt" forKey:@"protocol"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:userToken forKey:@"userToken"];
    [tmpDic setObjectDealNil:@"mqtt" forKey:@"protocol"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/deploy?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}

//获取用户绑定过的设备列表
- (void)getDeviceListForUser:(NSString *)userToken
        completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    //    curl -X POST -H "Content-Type: application/json"
    //    "http://api.vcd.io:4567/v1/user/bindinglist?accessKey=8e0bb23839955bde1346b6e9395347ff&ts=1465541792000&signature=ad36b179e3d1fb9f8fb368c4b9e99010"
    //    -d '{"userToken":"0beacd46-ee6f-4ad8-8800-9539542984f4"}'
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
//    NSString *protocol = @"mqtt";
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:userToken forKey:@"userToken"];
    [params setObjectDealNil:@"mqtt" forKey:@"protocol"];

    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:userToken forKey:@"userToken"];
    [tmpDic setObjectDealNil:@"mqtt" forKey:@"protocol"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/bindinglist?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        
        if (completionHandler) {
            
            NSArray *array = completedRequest.responseAsJSON[@"data"];
            if (array.count >= 1) {
                [[GetDevicePassword sharedInstance] setDictionaryWithArray:array];
            }
            
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
            
        }
    }];
    [hostNet startRequest:requestNetWork];
}

- (void)updateDeviceInfoWithDviceName:(NSString *)deviceName userToken:(NSString *)userToken deviceId:(NSString *)deviceId completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:deviceId forKey:@"deviceId"];
    [params setObjectDealNil:deviceName forKey:@"deviceName"];
    [params setObjectDealNil:@"" forKey:@"deviceLogo"];
    [params setObjectDealNil:userToken forKey:@"userToken"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:deviceId forKey:@"deviceId"];
    [tmpDic setObjectDealNil:deviceName forKey:@"deviceName"];
    [tmpDic setObjectDealNil:@"" forKey:@"deviceLogo"];
    [tmpDic setObjectDealNil:userToken forKey:@"userToken"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"device/updatename?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}
//新增用户更改用户名(昵称)
- (void)updateUserInfoWithUserId:(NSString *)userId username:(NSString *)username completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{
    
    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:userId forKey:@"userId"];
    [params setObjectDealNil:username forKey:@"username"];
    [params setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:userId forKey:@"userId"];
    [tmpDic setObjectDealNil:username forKey:@"username"];
    [tmpDic setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/updatename?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}

//新增查询用户信息
- (void)getUserInfoWithUserId:(NSString *)userId completionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{

    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:userId forKey:@"userId"];
    [params setObjectDealNil:VENDOR_ID forKey:@"vendorId"];

    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:userId forKey:@"userId"];
    [tmpDic setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    
    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"user/getinfo?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
    MKNetworkRequest *requestNetWork = [hostNet requestWithPath:queryString params:params httpMethod:@"POST"];
    [requestNetWork setParameterEncoding:MKNKParameterEncodingJSON];
    [requestNetWork addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completionHandler) {
            completionHandler(completedRequest.responseAsJSON, completedRequest.error);
        }
    }];
    [hostNet startRequest:requestNetWork];
}

//新增查询产品信息接口
- (void)getVendorInfoCompletionHandler:(void (^)(id responseJSON, NSError *error))completionHandler
{

    // 时间戳
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    
    //1，业务参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:VENDOR_ID forKey:@"vendorId"];
    
    // 2，签名算法，自动对参数进行处理
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmpDic setObjectDealNil:ACCESS_KEY forKey:@"accessKey"];
    [tmpDic setObjectDealNil:tsStr forKey:@"ts"];
    [tmpDic setObjectDealNil:VENDOR_ID forKey:@"vendorId"];

    NSString *signature = [EncryptionTool generateSignature:tmpDic];
    NSLog(@"signature  == %@", signature);
    
    //实例负责管理网络队列参数是主机名（注意前面不能加HTTP）
    MKNetworkHost *hostNet = [[MKNetworkHost alloc] initWithHostName:NETWORK_URL];
    
    //实例一个请求对象MKNetworkRequest
    NSString *queryString = [NSString stringWithFormat:@"product/getinfo?accessKey=%@&ts=%@&signature=%@", ACCESS_KEY, tsStr, signature];
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
