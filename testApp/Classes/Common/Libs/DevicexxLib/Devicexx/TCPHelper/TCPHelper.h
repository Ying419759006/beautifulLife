//
//  TCPHelper.h
//  AiThinkerDemoAPP
//
//  Created by Anter_Mac on 16/9/3.
//  Copyright © 2016年 Anter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  代理回调
 */
@protocol TCPDelegate <NSObject>

@optional

//回调：接收到的数据
- (void)tcpReceiveDictionary:(NSDictionary *)receiveDict;

//回调：接收NSData数据
- (void)tcpReceiveData:(NSData *)data;

//回调：是否连接
- (void)isTCPConnected:(BOOL)isTCPConnected;

//回调：接收到心跳包数据
- (void)tcpReceiveHeartbeatDictionary:(NSDictionary *)heartbeatDict;

//回调：接收到login数据
- (void)tcpReceiveLoginDictionary:(NSDictionary *)loginDict;

@end

@interface TCPHelper : NSObject

+ (TCPHelper *)sharedInstance;

/**
 *  初始化 GCDAsyncSocket
 */
- (void)openTCPServerWithDelegate:(id)delegate deviceIp:(NSString *)deviceIp devicePassword:(NSString *)devicePassword deviceId:(NSString *)deviceId;

/**
 *  断开TCP连接
 */
- (void)closeTCPServer;

/**
 *  初始化之后就可以直接调用方法进行发送
 */
- (void)tcpSendDictionary:(NSDictionary *)params;

/**
 *  初始化之后就可以直接调用方法进行发送
 */
- (void)tcpSendData:(NSData *)data;

/**
 *  判断是否连接的方法
 */
- (BOOL)isTCPConnected;

@end
