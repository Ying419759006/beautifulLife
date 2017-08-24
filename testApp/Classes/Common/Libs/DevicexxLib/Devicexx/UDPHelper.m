//
//  UDPHelper.m
//  Devicexx
//
//  Created by YanqiaoW on 16/12/9.
//  Copyright © 2016年 device++. All rights reserved.
//

#import "UDPHelper.h"
#import "GCDAsyncUdpSocket.h"
#import "NSMutableDictionary+dealNil.h"
#import "DevicexxMessage.h"
#import "CommConfig.h"
#import "MKNetworkKit.h"
#import "EncryptionTool.h"


PushHead_t s_head;
PushHead_t r_head;


//手机需要监听的端口，用来设备反馈的信息
#define LOC_UDP_PORT 12517

//通过广播发送消息
//224.0.0.1/255.255.255.255 代表本地子网中的所有主机
#define LOC_BROADCAST_IP @"224.0.0.1"
#define UDP_BROADCAST_IP @"255.255.255.255"

//设备端提供的端口（AP入网）
#define DEV_UDP_PORT 12476
//跟设备进行绑定操作
#define DEV_TCP_PORT 12528


@interface UDPHelper ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

//产品vendorID数组
@property (nonatomic, strong) NSMutableDictionary *vendorIdDictionary;

typedef void (^DeviceDiscoverCompletionHandler)(NSArray *deviceList, NSError *error);
typedef void (^DeviceBindingCompletionHandler)(NSDictionary *info, NSError *error);
typedef void (^DeviceWIFIMODCompletionHandler)(NSDictionary *info, NSError *error);
typedef void (^DeviceSmartCompletionHandler)(NSDictionary *info, NSError *error);
typedef void (^DeviceNetworkCompletionHandler)(NSDictionary *info, NSError *error);

@property (nonatomic, copy) DeviceDiscoverCompletionHandler discoverHandler;
@property (nonatomic, copy) DeviceBindingCompletionHandler bindingHandler;
@property (nonatomic, copy) DeviceWIFIMODCompletionHandler apmodHandler;
@property (nonatomic, copy) DeviceSmartCompletionHandler smartHandler;
@property (nonatomic, copy) DeviceNetworkCompletionHandler networkHandler;

@end

@implementation UDPHelper

+ (UDPHelper *)sharedInstance
{
    static UDPHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UDPHelper alloc] init];
    });
    return _instance;
}

- (NSMutableDictionary *)vendorIdDictionary{
    if (_vendorIdDictionary == nil) {
        _vendorIdDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _vendorIdDictionary;
}

- (GCDAsyncUdpSocket *)udpSocket
{
    if (_udpSocket == nil) {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _udpSocket;
}

//开启本地UDP的接收服务
- (void)openUDPServer {
    
    //在打开UDP时, 调用获取productId 及 productName接口
    [self getProductInfo];
    
    //初始化udp
    NSError *error = nil;
    //////绑定本地接收数据端口
    if (![self.udpSocket bindToPort:LOC_UDP_PORT error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    if (![self.udpSocket enableBroadcast:YES error:&error]) {
        NSLog(@"Error enableBroadcast (bind): %@", error);
        return;
    }
    if (![self.udpSocket joinMulticastGroup:@"224.0.0.1"  error:&error]) {
        NSLog(@"Error joinMulticastGroup (bind): %@", error);
        return;
    }
    //////启动接收线程
    if (![self.udpSocket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
        return;
    }
}

//
- (void)getProductInfo
{
    //在打开UDP时, 调用获取productId 及 productName接口
    if (self.vendorIdDictionary.allKeys.count == 0) { //保证app每次使用期间只运行一次
        
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
            
            if (completedRequest.error) {
                NSLog(@"judgeVendorDeviceWithProductId error :%@",completedRequest.error.localizedDescription);
            }
            
            if ([ completedRequest.responseAsJSON[@"success"] boolValue]) {
                
                for (NSDictionary *dic in completedRequest.responseAsJSON[@"data"][@"productVoList"]) {
                    [self.vendorIdDictionary setValue:dic[@"productName"] forKey:dic[@"productId"]];
                }
                NSLog(@"本厂商productId:%@",self.vendorIdDictionary);
                
            } else {
                NSLog(@"judgeVendorDeviceWithProductId error : %@", completedRequest.responseAsJSON);
            }
            
        }];
        [hostNet startRequest:requestNetWork];
        
    }
}

//关闭本地UDP的接收服务
- (void)closeUDPServer
{
    if (self.udpSocket != nil) {
        [self.udpSocket closeAfterSending];
    }
    if (self.apmodHandler != nil) {
        self.apmodHandler = nil;
    }
    if (self.smartHandler != nil) {
        self.smartHandler = nil;
    }
    if (self.networkHandler != nil) {
        self.networkHandler = nil;
    }
    if (self.discoverHandler != nil) {
        self.discoverHandler = nil;
    }
    if (self.bindingHandler != nil) {
        self.bindingHandler = nil;
    }
}

//接收硬件的反馈信息
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    //接收硬件反馈信息 IP、Port、message
    NSString *host = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port  = [GCDAsyncUdpSocket portFromAddress:address];
    
    // 检查通信头数据是否满足大于28个字节
    if ([data length] > sizeof(PushHead_t)) {
        // Get header structure
        PushHead_t *header = [[DevicexxMessage sharedInstance] messageHeadParser:data];
        
        // Check header validation
        if(nil != header) {
            
            //NSData *headerData = [data subdataWithRange:NSMakeRange(0, 28)];
            //[headerData getBytes:&r_head length:sizeof(r_head)];
            
            // 截掉通信协议头28个字节后的内容
            NSData *bodyData  = [data subdataWithRange:NSMakeRange(28, [data length]-28)];
            NSString *message = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
            NSLog(@"client host = %@, port = %d, message = %@", host, port, message);
            
            uint32_t cmdid = header->cmdid;
            if (3001 == cmdid) { //AP模式让设备入网
                [self dealWithAPMODResultData:bodyData fromAddress:address];
            }
            if (3002 == cmdid) { //智能入网反馈
                [self dealWithSmartResultData:bodyData fromAddress:address];
            }
            if (3003 == cmdid) { //设备入网成功反馈
                [self dealWithNetworkResultData:bodyData fromAddress:address];
            }
            if (3004 == cmdid) { //扫描局域网中的设备
                [self dealWithDiscoverResultData:bodyData fromAddress:address];
            }
            if (3005 == cmdid) { //绑定设备反馈信息
                [self dealWithBindingResultData:bodyData fromAddress:address];
            }
        }
    }
}

//周边设备列表接口实现
- (void)discoverDeviceCompletionHandler:(void (^)(NSArray *deviceList, NSError *error))completionHandler
{
    
    NSString *jsonString = @"{}";
    uint32_t bodyLen = (uint32_t)[jsonString length];
    
    s_head.magicnum = htonl(0xAA33CC55);
    s_head.version  = htonl(1);  //通信协议类型是JSON
    //2001-AP配置发送消息->3001; 2004-发现局域网中的所有设备:{} ->3004; 2005-绑定设备->3005
    s_head.cmdid    = htonl(2004);
    s_head.seq      = htonl(1); //通信ID自增长序列1,2,3...
    s_head.checksum = htonl(0); //暂忽略
    s_head.flag     = htonl(0); //暂忽略
    s_head.bodylen  = htonl(bodyLen); //计算消息长度
    
    NSData *headData = [[NSData alloc] initWithBytes:&s_head length:sizeof(s_head)];
    NSData *bodyData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //直接拼接header和body数据
    NSMutableData *sendData = [[NSMutableData alloc] initWithCapacity:0];
    [sendData appendData:headData];
    [sendData appendData:bodyData];
    
    
    //处理回调结果使用
    self.discoverHandler = completionHandler;
    
    // UDP全网广播
    [self.udpSocket sendData:sendData
                      toHost:UDP_BROADCAST_IP
                        port:DEV_UDP_PORT
                 withTimeout:-1
                         tag:0];
}

//新增设备是否可以被发现接口
- (NSString *)getProductNameJudgeVendorDeviceWithProductId:(NSString *)productId
{
    
    if ([self.vendorIdDictionary.allKeys containsObject:productId]) {
        return [self.vendorIdDictionary objectForKey:productId];
    } else {
        return nil;
    }
    
}

//绑定设备前获取设备信息
- (void)bindingDeviceHost:(NSString *)deviceHost
               devicePort:(UInt16)devicePort
        completionHandler:(void (^)(NSDictionary *devInfo, NSError *error))completionHandler
{
    long timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *jsonString = [NSString stringWithFormat:@"{\"ts\":%ld}", timestamp];
    uint32_t bodyLen = (uint32_t)[jsonString length];
    
    s_head.magicnum = htonl(0xAA33CC55);
    s_head.version  = htonl(1);  //通信协议类型是JSON
    //2001-AP配置发送消息->3001; 2004-发现局域网中的所有设备:{} ->3004; 2005-绑定设备->3005
    s_head.cmdid    = htonl(2005);
    s_head.seq      = htonl(1); //通信ID自增长序列1,2,3...
    s_head.checksum = htonl(0); //暂忽略
    s_head.flag     = htonl(0); //暂忽略
    s_head.bodylen  = htonl(bodyLen); //计算消息长度
    
    NSData *headerData = [[NSData alloc] initWithBytes:&s_head length:sizeof(s_head)];
    NSData *bodyData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //直接拼接header和body数据
    NSMutableData *sendData = [[NSMutableData alloc] initWithCapacity:0];
    [sendData appendData:headerData];
    [sendData appendData:bodyData];
    
    NSString *devIp  = deviceHost;
    uint16_t devPort = devicePort;
    
    //处理回调结果使用
    self.bindingHandler = completionHandler;
    
    // UDP对指定硬件进行单播
    [self.udpSocket sendData:sendData
                      toHost:devIp
                        port:devPort
                 withTimeout:-1
                         tag:0];
    
}

/**
 * AP配置设备联网
 */
- (void)APLink:(NSString *)ssid
      password:(NSString *)password
completionHandler:(void (^)(NSDictionary *, NSError *))completionHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:ssid forKey:@"ssid"];
    [params setObjectDealNil:password forKey:@"password"];
    
    NSError *error = nil;
    NSData *jsonData  = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    if (error) {
        NSLog(@"AP ssid / password error : %@",error.localizedDescription);
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    uint32_t bodyLen = (uint32_t)[jsonString length];
    long bodyLen = [jsonData length];
    
    s_head.magicnum = htonl(0xAA33CC55);
    s_head.version  = htonl(1);  //通信协议类型是JSON
    //2001-AP配置发送消息->3001; 2004-发现局域网中的所有设备:{} ->3004; 2005-绑定设备->3005
    s_head.cmdid    = htonl(2001);
    s_head.seq      = htonl(1); //通信ID自增长序列1,2,3...
    s_head.checksum = htonl(0); //暂忽略
    s_head.flag     = htonl(0); //暂忽略
    s_head.bodylen  = htonl(bodyLen); //计算消息长度
    
    NSData *headData = [[NSData alloc] initWithBytes:&s_head length:sizeof(s_head)];
    NSData *bodyData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //直接拼接header和body数据
    NSMutableData *sendData = [[NSMutableData alloc] initWithCapacity:0];
    [sendData appendData:headData];
    [sendData appendData:bodyData];
    
    //处理回调结果使用
    self.apmodHandler = completionHandler;
    
    //UDP广播
    [self.udpSocket sendData:sendData
                      toHost:UDP_BROADCAST_IP
                        port:DEV_UDP_PORT
                 withTimeout:-1
                         tag:0];
}

/**
 * 智能连接的反馈
 */
- (void)receiveSmartLinkCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler
{
    self.smartHandler = completionHandler;
}

/**
 * 设备入网成功的反馈
 */
- (void)networkSuccessCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler
{
    self.networkHandler = completionHandler;
}

- (void)dealWithDiscoverResultData:(NSData *)data fromAddress:(NSData *)address
{
    //接收硬件反馈信息 IP、Port、message
    NSString *deviceIp  = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t devicePort = [GCDAsyncUdpSocket portFromAddress:address];
    
    //截掉消息协议头部分的消息体
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"client IP = %@, port = %d, message = %@", deviceIp, devicePort, message);
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error || json == nil) {
        NSLog(@"json parse failed err = %@\r\n", error);
        return;
    }
    
    NSString *productId = [json valueForKey:@"productId"];
    NSString *deviceId  = [json valueForKey:@"deviceId"];
    NSString *mac       = [json valueForKey:@"mac"];
    NSString *devPort   = [NSString stringWithFormat:@"%d", devicePort];
    
    NSMutableDictionary *devInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [devInfo setObjectDealNil:deviceIp forKey:@"deviceIp"];
    [devInfo setObjectDealNil:devPort forKey:@"devicePort"];
    [devInfo setObjectDealNil:productId forKey:@"productId"];
    [devInfo setObjectDealNil:deviceId forKey:@"deviceId"];
    [devInfo setObjectDealNil:mac forKey:@"mac"];
    
    //返回发现设备结果
    if (self.discoverHandler) {
        self.discoverHandler(@[devInfo], error);
    }
}

- (void)dealWithBindingResultData:(NSData *)data fromAddress:(NSData *)address
{
    //接收硬件反馈信息 IP、Port、message
    NSString *deviceIp  = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t devicePort = [GCDAsyncUdpSocket portFromAddress:address];
    //截掉消息协议头部分的消息体
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"client IP = %@, port = %d, message = %@", deviceIp, devicePort, message);
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error || json == nil) {
        NSLog(@"json parse failed err = %@\r\n", error);
        return;
    }
    
    NSString *devAccessKey = json[@"accessKey"];
    NSString *devPassword   = json[@"password"];
    NSString *deviceId       = json[@"deviceId"];
    NSString *devTs         = [NSString stringWithFormat:@"%@", json[@"ts"]];
    NSString *devPort        = [NSString stringWithFormat:@"%d", devicePort];
    
    NSMutableDictionary *devInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [devInfo setObjectDealNil:deviceIp forKey:@"deviceIp"];
    [devInfo setObjectDealNil:devPort forKey:@"devicePort"];
    [devInfo setObjectDealNil:devAccessKey forKey:@"accessKey"];
    [devInfo setObjectDealNil:devPassword forKey:@"password"];
    [devInfo setObjectDealNil:deviceId forKey:@"deviceId"];
    [devInfo setObjectDealNil:devTs forKey:@"ts"];
    
    //返回发现设备结果
    if (self.bindingHandler) {
        self.bindingHandler(devInfo, error);
    }
}

- (void)dealWithAPMODResultData:(NSData *)data fromAddress:(NSData *)address
{
    //接收硬件反馈信息 IP、Port、message
    NSString *deviceIp  = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t devicePort = [GCDAsyncUdpSocket portFromAddress:address];
    //截掉消息协议头部分的消息体
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"client IP = %@, port = %d, message = %@", deviceIp, devicePort, message);
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error || json == nil) {
        NSLog(@"json parse failed err = %@\r\n", error);
        return;
    }
    
    NSString *productId   = json[@"productId"];
    NSString *deviceId    = json[@"deviceId"];
    NSString *mac         = json[@"mac"];
    
    NSString *devPort = [NSString stringWithFormat:@"%d", devicePort];
    
    NSMutableDictionary *devInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [devInfo setObjectDealNil:deviceIp forKey:@"deviceIp"];
    [devInfo setObjectDealNil:devPort forKey:@"devicePort"];
    [devInfo setObjectDealNil:productId forKey:@"productId"];
    [devInfo setObjectDealNil:deviceId forKey:@"deviceId"];
    [devInfo setObjectDealNil:mac forKey:@"mac"];
    
    //返回设备AP入网处理结果
    if (self.apmodHandler) {
        self.apmodHandler(devInfo, error);
    }
}

- (void)dealWithSmartResultData:(NSData *)data fromAddress:(NSData *)address
{
    //接收硬件反馈信息 IP、Port、message
    NSString *deviceIp  = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t devicePort = [GCDAsyncUdpSocket portFromAddress:address];
    //截掉消息协议头部分的消息体
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"client IP = %@, port = %d, message = %@", deviceIp, devicePort, message);
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error || json == nil) {
        NSLog(@"json parse failed err = %@\r\n", error);
        return;
    }
    
    NSString *productId   = json[@"productId"];
    NSString *deviceId    = json[@"deviceId"];
    NSString *mac         = json[@"mac"];
    
    NSString *devPort = [NSString stringWithFormat:@"%d", devicePort];
    
    NSMutableDictionary *devInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [devInfo setObjectDealNil:deviceIp forKey:@"deviceIp"];
    [devInfo setObjectDealNil:devPort forKey:@"devicePort"];
    [devInfo setObjectDealNil:productId forKey:@"productId"];
    [devInfo setObjectDealNil:deviceId forKey:@"deviceId"];
    [devInfo setObjectDealNil:mac forKey:@"mac"];
    
    //返回设备Smart入网处理结果
    if (self.smartHandler) {
        self.smartHandler(devInfo, error);
    }
}

- (void)dealWithNetworkResultData:(NSData *)data fromAddress:(NSData *)address
{
    //接收硬件反馈信息 IP、Port、message
    NSString *deviceIp  = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t devicePort = [GCDAsyncUdpSocket portFromAddress:address];
    //截掉消息协议头部分的消息体
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"client IP = %@, port = %d, message = %@", deviceIp, devicePort, message);
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error || json == nil) {
        NSLog(@"json parse failed err = %@\r\n", error);
        return;
    }
    
    NSString *productId   = json[@"productId"];
    NSString *deviceId    = json[@"deviceId"];
    NSString *mac         = json[@"mac"];
    
    NSString *devPort = [NSString stringWithFormat:@"%d", devicePort];
    
    NSMutableDictionary *devInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [devInfo setObjectDealNil:deviceIp forKey:@"deviceIp"];
    [devInfo setObjectDealNil:devPort forKey:@"devicePort"];
    [devInfo setObjectDealNil:productId forKey:@"productId"];
    [devInfo setObjectDealNil:deviceId forKey:@"deviceId"];
    [devInfo setObjectDealNil:mac forKey:@"mac"];
    
    //返回设备入网处理结果
    if (self.networkHandler) {
        self.networkHandler(devInfo, error);
    }
}

@end
