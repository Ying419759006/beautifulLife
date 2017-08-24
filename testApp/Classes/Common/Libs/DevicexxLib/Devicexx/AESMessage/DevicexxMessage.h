//
//  DevicexxMessage.h
//  AESMessage
//
//  Created by Zhaoying on 16/11/29.
//  Copyright © 2016年 Device++. All rights reserved.
//

#import <Foundation/Foundation.h>

//协议宏定义
#define MESSAGE_MAGICNUMBER (0xAA33CC55)

//协议版本定义
typedef enum {
    MESSAGE_VER_RESV,
    MESSAGE_VER_JSON = 1,
    MESSAGE_VER_RAW = 2,
    MESSAGE_VER_AES = 3,
    MESSAGE_VER_MAX
} MessageVersion_t;

//协议头部结构体
/**
 * Device++ message header
 */
typedef struct PushHead_t {
    uint32_t magicnum;    //Magic Code, 0xAA33CC55
    uint32_t version;     //版本号, 默认为PUSH_VERSION_JSON
    uint32_t bodylen;     //包体长度(不含包头)
    uint32_t cmdid;       //命令号, 表示包体格式
    uint32_t seq;         //请求包序列号, 递增, 回传
    uint32_t checksum;    //包体校验码, 预留
    uint32_t flag;        //请求包的一些标志, 预留
} PushHead_t;

/**
 * Device++ message interface
 */
@interface DevicexxMessage : NSObject

//单例
/**
 * Device++ message instance
 */
+ (DevicexxMessage *)sharedInstance;

/**
 * @return BOOL is    Debug model?
 */
- (BOOL)setDebugModel:(BOOL)isDebug;

//加密message
/**
 * Encrypt Device++ message
 *
 * @param message     Dictionary message that to be encrypt
 * @param deviceId    Device ID
 * @param version     Message version
 * @param bodylen     Message body length
 * @param cmdid       Command ID
 * @param seq         Sequence ID
 * @param checksum    Checksum of message body
 * @param flag        Flag of this message
 * @return NSData     Device++ encrypted Message
 */
- (NSData *)messageBuilder:(NSDictionary *)message
                  deviceId:(NSString *)deviceId
                   version:(uint32_t)version
                     cmdid:(uint32_t)cmdid
                       seq:(uint32_t)seq
                  checksum:(uint32_t)checksum
                      flag:(uint32_t)flag;

//解析Message
/**
 * Decrypt Device++ message
 *
 * @param message           Data that to be decrypt
 * @param deviceId          deviceId
 * @return NSDictionary     Dictionary that decrypted
 */
- (NSDictionary *)messageParser:(NSData *)message
                       deviceId:(NSString *)deviceId;

//解析Message
/**
 * Decrypt Device++ message
 *
 * @param message           Data that to be decrypt
 * @param deviceId          deviceId
 * @return header           return header in message
 * @return NSDictionary     Dictionary that decrypted
 */
- (NSDictionary *)messageParser:(NSData *)message
                       deviceId:(NSString *)deviceId
                         header:(PushHead_t *)header;

//header加密
/**
 * Build Device++ message header
 *
 * @param version     Message version
 * @param bodylen     Message body length
 * @param cmdid       Command ID
 * @param seq         Sequence ID
 * @param checksum    Checksum of message body
 * @param flag        Flag of this message
 * @return NSData     Device++ message header data
 */
- (NSData *)messageHeadBuilder:(uint32_t)version
                         bodylen:(uint32_t)bodylen
                           cmdid:(uint32_t)cmdid
                             seq:(uint32_t)seq
                        checksum:(uint32_t)checksum
                            flag:(uint32_t)flag;

//header解密
/**
 * Parse Device++ message header
 *
 * @param data        Header data
 * @return PushHead_t Header struct
 */
- (PushHead_t *)messageHeadParser:(NSData *)data;

//body加密
/**
 * Encrypt Device++ message body
 *
 * @param body        Dictionary body that to be encrypt
 * @param deviceId    Device ID
 * @return NSData     Device++ encrypted Message body
 */
- (NSData *)messageBodyBuilder:(NSDictionary *)body
                      deviceId:(NSString *)deviceId;

//body解密
/**
 * Decrypt Device++ message body
 *
 * @param body        Body data that to be encrypt
 * @param deviceId    Device ID
 * @param version     Message version
 * @return NSData     Device++ decrypted Message body dictionary
 */
- (NSDictionary *)messageBodyParser:(NSData *)body
                           deviceId:(NSString *)deviceId
                            version:(int)version;

//获取随机16字节iv值
- (NSData *)getIv;

//获取key
- (NSData *)getKey:(NSString *)deviceId iv:(NSData *)ivData;

//解析json
- (NSDictionary *)parseJson:(NSData *)data;

//检测是否为包含指定key("i","d","t")的dictionary
- (bool)isContainsKeys:(NSDictionary *)dictionary;

@end
