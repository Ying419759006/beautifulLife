//
//  TCPHelper.m
//  AiThinkerDemoAPP
//
//  Created by Anter_Mac on 16/9/3.
//  Copyright © 2016年 Anter. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "TCPHelper.h"
#import "GCDAsyncSocket.h"
#import "DevicexxMessage.h"
#import "NSMutableDictionary+dealNil.h"


PushHead_t send_head;
PushHead_t receive_head;

@interface TCPHelper () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) id <TCPDelegate> tcpDelegate;

@end

@implementation TCPHelper
{
    GCDAsyncSocket *clientSocket;
    
    NSString *_hostString;
    uint16_t _portUint;
    NSString *_deviceId;
    NSString *_devicePassword;
    
    uint32_t tcpSequence;
    
    //tcp心跳
    NSTimer *_heartbeatTimer;
    
    BOOL _isDisconnectByUser;
    BOOL _isTCPConnected;
}

+ (TCPHelper *)sharedInstance
{
    static TCPHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TCPHelper alloc] init];
    });
    return _instance;
}

- (void)openTCPServerWithDelegate:(id)delegate deviceIp:(NSString *)deviceIp devicePassword:(NSString *)devicePassword deviceId:(NSString *)deviceId
{

    _hostString = deviceIp;
    _portUint = 12518;
    _deviceId = deviceId;
    _devicePassword = devicePassword;
    tcpSequence = 0;
    self.tcpDelegate = delegate;
    _isDisconnectByUser = NO;
    NSError *error = [[NSError alloc] init];
    
    clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    [clientSocket connectToHost:hostString onPort:portUint error:nil];
    
    if ([clientSocket connectToHost:_hostString onPort:_portUint error:&error]) {
        NSLog(@"connecting to tcp.");
    }else{
        NSLog(@"error connecting to tcp. == %@", error);
    }
    
    [clientSocket readDataWithTimeout:-1 tag:100];

}

#pragma TCP 操作 start

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    NSLog(@"didConnectToHost:%@ port:%d", host, port);
    _isTCPConnected = YES;
    if (self.tcpDelegate && [self.tcpDelegate respondsToSelector:@selector(isTCPConnected:)]) {
        [self.tcpDelegate isTCPConnected:YES];
    }
    [self loginTcpDevice];
}

/**
 *  TCP登录局域网设备
 */
- (void)loginTcpDevice{
    
    long ts = [[NSDate date] timeIntervalSince1970];
    NSNumber *tsNum = [NSNumber numberWithLong:ts];
    NSString *tsString = [NSString stringWithFormat:@"%ld", ts];
    NSString *signature = [NSString stringWithFormat:@"%@%@%@", _deviceId, _devicePassword, tsString];
    
    signature = [self md5HexDigest:signature];
    
    //发送的内容
    NSDictionary *jsonBodyDic = [NSDictionary dictionaryWithObjectsAndKeys:signature, @"signature", tsNum, @"ts", nil];
    
    NSData *sendData = [[DevicexxMessage sharedInstance] messageBuilder:jsonBodyDic
                                                               deviceId:_deviceId
                                                                version:MESSAGE_VER_AES
                                                                  cmdid:2101
                                                                    seq:tcpSequence
                                                               checksum:0
                                                                   flag:0];
    
    [self send:sendData];
    
    //登录成功后开始发送心跳包
    [self tcpHeartbeat];
}

/**
 * TCP心跳包定时器
 */
-(void)tcpHeartbeat{
    
    _heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:18.0
                                                      target:self
                                                    selector:@selector(heartbeatTimerTask)
                                                    userInfo:nil
                                                     repeats:YES];
}

/**
 *  tcp 心跳Task
 */
- (void)heartbeatTimerTask{
    
    long ts = [[NSDate date] timeIntervalSince1970];
    NSString *tsString = [NSString stringWithFormat:@"%ld", ts];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObjectDealNil:tsString forKey:@"ts"];
    
    NSData *sendData = [[DevicexxMessage sharedInstance] messageBuilder:params
                                                               deviceId:_deviceId
                                                                version:MESSAGE_VER_AES
                                                                  cmdid:2102
                                                                    seq:tcpSequence
                                                               checksum:0
                                                                   flag:0];
    
    [self send:sendData];
}

/**
 *  tcp发送控制指令
 *
 *  @param params 指令字典格式
 */
- (void)tcpSendDictionary:(NSDictionary *)params{
    if((nil != params) &&
       
       ([params count] >0)) {
        
        NSData *sendData = [[DevicexxMessage sharedInstance] messageBuilder:params
                                                                   deviceId:_deviceId
                                                                    version:MESSAGE_VER_AES
                                                                      cmdid:2103
                                                                        seq:tcpSequence
                                                                   checksum:0
                                                                       flag:0];

        [self send:sendData];
    }
}

/**
 *  tcp发送控制指令
 *
 *  @param data 指令NSData格式
 */
- (void)tcpSendData:(NSData *)data{
    if((nil != data) &&
       (data.length >0)) {
        uint32_t bodyLength = (uint32_t)data.length;
        
        NSData *headerData = [[DevicexxMessage sharedInstance] messageHeadBuilder:MESSAGE_VER_RAW
                                                                          bodylen:bodyLength
                                                                            cmdid:2103
                                                                              seq:tcpSequence
                                                                         checksum:0
                                                                             flag:0];
        
        //拼接header和body数据
        NSMutableData *sendData = [[NSMutableData alloc] initWithCapacity:0];
        [sendData appendData:headerData];
        //TCP透传接口不加密
        [sendData appendData:data];
        
        [self send:sendData];
    }
}

#pragma TCP 操作 end
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    [_heartbeatTimer invalidate];
    _heartbeatTimer = nil;
    _isTCPConnected = NO;
    if (self.tcpDelegate && [self.tcpDelegate respondsToSelector:@selector(isTCPConnected:)]) {
        [self.tcpDelegate isTCPConnected:NO];
    }
    //重连
    if (_isDisconnectByUser) {
        
    }else{
        [clientSocket disconnect];
        NSLog(@"linking ... ");
        [clientSocket connectToHost:_hostString onPort:_portUint error:nil];
        [clientSocket readDataWithTimeout:-1 tag:100];
    }
}

// 断开连接时
- (BOOL)isTCPConnected{
    
    return _isTCPConnected;
}

// TCP 发送数据
- (void)send:(NSData *)sendData{
    //局域网发数据是可以定时器设置超时
    NSLog(@"[TCPHelper] sendData.");
    tcpSequence++;
    [clientSocket writeData:sendData withTimeout:-1 tag:100];
}

/**
 *  TCP 断开连接
 */
- (void)closeTCPServer{
    
    [_heartbeatTimer invalidate];
    NSLog(@"[TCPHelper] stop heartbeat.");
    _heartbeatTimer = nil;
    _isDisconnectByUser = YES;
    [clientSocket disconnect];
    NSLog(@"[TCPHelper] disconnect.");
}

// TCP 接收到服务端的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    // Data length must above 28 bytes
    if ([data length] > sizeof(PushHead_t)) {
        // Get header structure
        PushHead_t *header = [[DevicexxMessage sharedInstance] messageHeadParser:data];
        
        // Check header validation
        if(nil != header) {
            // 截掉通信协议头28个字节后的内容
            NSData *bodyData  = [data subdataWithRange:NSMakeRange(sizeof(PushHead_t), [data length] - sizeof(PushHead_t))];
            
            uint32_t cmdid = header->cmdid;
            uint32_t version = header->version;
            
            NSDictionary *message = [[DevicexxMessage sharedInstance] messageBodyParser:bodyData deviceId:_deviceId version:version];
            
            if (3101 == cmdid) { //tcp登录设备应答
                NSLog(@"[TCPHelper] login :%@",message);
                if (self.tcpDelegate && [self.tcpDelegate respondsToSelector:@selector(tcpReceiveLoginDictionary:)]) {
                    [self.tcpDelegate tcpReceiveLoginDictionary:message];
                }
            }
            if (3102 == cmdid) { //tcp心跳应答
                NSLog(@"[TCPHelper] heartbeat :%@",message);
                if (self.tcpDelegate && [self.tcpDelegate respondsToSelector:@selector(tcpReceiveHeartbeatDictionary:)]) {
                    [self.tcpDelegate tcpReceiveHeartbeatDictionary:message];
                }
            }
            if (3103 == cmdid) { //tcp发送控制指令应答
                
                NSLog(@"[TCPHelper] receive :%@",message);
                //接收NSData类型数据
                if (self.tcpDelegate && [self.tcpDelegate respondsToSelector:@selector(tcpReceiveData:)]) {
                    [self.tcpDelegate tcpReceiveData:bodyData];
                }
                
                if ([[DevicexxMessage sharedInstance] isContainsKeys:message]) { //指定的key的json才返回
                    if (self.tcpDelegate && [self.tcpDelegate respondsToSelector:@selector(tcpReceiveDictionary:)]) {
                        [self.tcpDelegate tcpReceiveDictionary:message];
                    }
                }
            }
        }
    }
    
    //继续监听服务端发送过来的数据
    [clientSocket readDataWithTimeout:-1 tag:100];
    
}

// 32位 MD5加密
- (NSString *)md5HexDigest:(NSString *)password{
    
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        /*
         %02X是格式控制符：‘x’表示以16进制输出，‘02’表示不足两位，前面补0；
         */
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}

@end
