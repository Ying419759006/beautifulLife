//
//  DevicexxMessage.m
//  AESMessage
//
//  Created by Zhaoying on 16/11/29.
//  Copyright © 2016年 Device++. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "DevicexxMessage.h"
#import "AESMessage.h"
#import "GetDevicePassword.h"

#if 1 // set to 1 to enable logs

#define LogV(tag, frmt, ...) NSLog(@"[V]<%@>:" frmt, tag, ##__VA_ARGS__);
#define LogD(tag, frmt, ...) NSLog(@"[D]<%@>:" frmt, tag, ##__VA_ARGS__);
#define LogI(tag, frmt, ...) NSLog(@"[I]<%@>:" frmt, tag, ##__VA_ARGS__);
#define LogW(tag, frmt, ...) NSLog(@"[W]<%@>:" frmt, tag, ##__VA_ARGS__);
#define LogE(tag, frmt, ...) NSLog(@"[E]<%@>:" frmt, tag, ##__VA_ARGS__);

#else

#define LogV(tag, frmt, ...) {}
#define LogD(tag, frmt, ...) {}
#define LogI(tag, frmt, ...) {}
#define LogW(tag, frmt, ...) {}
#define LogE(tag, frmt, ...) {}

#endif

/**
 * Device++ message implementation
 */

@implementation DevicexxMessage

{
    BOOL isDebugMode;
}

//单例
/**
 * Device++ message instance
 */
+ (DevicexxMessage *)sharedInstance
{
    static DevicexxMessage *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DevicexxMessage alloc] init];
    });
    return _instance;
}

- (BOOL)setDebugModel:(BOOL)isDebug
{
    isDebugMode = isDebug;
    return isDebugMode;
}

/*******************************************************/

//加密message
/**
 * Encrypt Device++ message
 *
 * @param message     Dictionary message that to be decrypt
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
{
    NSData *bodyData = [self messageBodyBuilder:message deviceId:deviceId];
    uint32_t bodylen = (uint32_t)[bodyData length];
    NSData *headerData = [self messageHeadBuilder:version bodylen:bodylen cmdid:cmdid seq:seq checksum:checksum flag:flag];
    
    //拼接header 与 body
    NSMutableData *mutableMessageData = [NSMutableData dataWithCapacity:0];
    [mutableMessageData appendData:headerData];
    [mutableMessageData appendData:bodyData];
    
    //获得加密数据
    return mutableMessageData;
    
}

//解析Message
/**
 * Decrypt Device++ message
 *
 * @param data        Data that to be decrypt
 * @return NSData     Dictionary message that decrypted
 */
- (NSDictionary *)messageParser:(NSData *)message
                       deviceId:(NSString *)deviceId;
{
    return [self messageParser:message
                      deviceId:deviceId
                        header:nil];
}

//解析Message
/**
 * Decrypt Device++ message
 *
 * @param data        Data that to be decrypt
 * @param header      Header of message
 * @return NSData     Dictionary message that decrypted
 */
- (NSDictionary *)messageParser:(NSData *)message
                       deviceId:(NSString *)deviceId
                         header:(PushHead_t *)header;
{
    
    //解析json
    if ([self parseJson:message]) {
        return [self parseJson:message];
    }
    
    if ([message length] > sizeof(PushHead_t)) {
        // 通信头数据28个字节
        PushHead_t * messageHeader = [self messageHeadParser:message];
        if(nil != messageHeader) {
            if(nil != header) {
                * header = * messageHeader;
            }
            
            uint32_t magicnum = messageHeader->magicnum;
            uint32_t version = messageHeader->version;
            
            //此body为截取头28字节后剩余部分
            NSData *body = [message subdataWithRange:NSMakeRange(sizeof(PushHead_t),
                                                                 [message length]-sizeof(PushHead_t))];
            
            if (magicnum == MESSAGE_MAGICNUMBER && version == MESSAGE_VER_AES) {
                
                //AES数据
                return [self messageBodyParser:body deviceId:deviceId version:MESSAGE_VER_AES];
                
            }
            
            if (magicnum == MESSAGE_MAGICNUMBER && version == MESSAGE_VER_JSON) {
                
                //JSON数据
                return [self messageBodyParser:body deviceId:deviceId version:MESSAGE_VER_JSON];
                
            }
        }
    }
    return nil;
}



/************************************************************/

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
{
    PushHead_t header;
    header.magicnum = MESSAGE_MAGICNUMBER;
    header.version = version;
    header.bodylen = bodylen;
    header.cmdid = cmdid;
    header.seq = seq;
    header.checksum = checksum;
    header.flag = flag;
    
    // Encode push header
    header.magicnum = htonl(header.magicnum);
    header.version = htonl(header.version);
    header.bodylen = htonl(header.bodylen);
    header.cmdid = htonl(header.cmdid);
    header.seq = htonl(header.seq);
    header.checksum = htonl(header.checksum);
    header.flag = htonl(header.flag);
    
    NSData *headerData = [[NSData alloc] initWithBytes:&header length:sizeof(header)];
    
    return headerData;
}

//header解密
/**
 * Parse Device++ message header
 *
 * @param data        Header data
 * @return PushHead_t Header struct
 */
- (PushHead_t *)messageHeadParser:(NSData *)data;
{
    // Initial header, filled with zero
    static PushHead_t header;
    Byte * buffer = (Byte *)(& header);
    memset(buffer, 0, sizeof(PushHead_t));
    // Check parameter
    if(data.length >= sizeof(PushHead_t)) {
        // Get通信头数据28个字节
        //NSData *headerData = [data subdataWithRange:NSMakeRange(0, sizeof(PushHead_t))];
        memcpy(buffer, data.bytes, sizeof(PushHead_t));
        // Decode push header
        header.magicnum = ntohl(header.magicnum);
        header.version = ntohl(header.version);
        header.bodylen = ntohl(header.bodylen);
        header.cmdid = ntohl(header.cmdid);
        header.seq = ntohl(header.seq);
        header.checksum = ntohl(header.checksum);
        header.flag = ntohl(header.flag);
        if(MESSAGE_MAGICNUMBER == header.magicnum) {
            // Check logical length equal with real length
            if(header.bodylen == data.length - sizeof(PushHead_t)){
                return & header;
            } else {
                LogE(NSStringFromSelector(_cmd), @"Message logical length error.");
            }
        } else {
            LogE(NSStringFromSelector(_cmd), @"Message magic number error.");
        }
    }
    // [headerData getBytes:&r_head length:sizeof(r_head)];
    return nil;
}

/************************************************************/

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
{
    NSData *ivData;
    if (isDebugMode) {
        
        //test使用
        Byte ivByte[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
        ivData = [[NSData alloc] initWithBytes:ivByte length:16];
        
    } else {
        
        //获取随机16字节 ivData
        ivData = [self getIv];
    }
    
    //获取key
    NSData *keyData = [self getKey:deviceId iv:ivData];
    
    //    NSString * logString;
    //    logString = @"";
    //    logString = [logString stringByAppendingString: @"\r\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n"];
    //    logString = [logString stringByAppendingString:@"Key:\r\n"];
    //    for(int i=0;i<keyData.length;i++) {
    //        logString = [logString stringByAppendingFormat:@"%02x ", ((uint8_t *)keyData.bytes)[i]];
    //    }
    //    logString = [logString stringByAppendingString: @"\r\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n"];
    
    NSError *err = nil;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:body options:kNilOptions error:&err];
    
    //    logString = [logString stringByAppendingString: @"\r\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n"];
    //    logString = [logString stringByAppendingString:@"Message:\r\n"];
    //    for(int i=0;i<messageData.length;i++) {
    //        logString = [logString stringByAppendingFormat:@"%02x ", ((uint8_t *)messageData.bytes)[i]];
    //    }
    //
    //    logString = [logString stringByAppendingString: @"\r\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n"];
    
    LogV(NSStringFromSelector(_cmd),@"Key:%@", keyData);
    LogV(NSStringFromSelector(_cmd),@"Msg:%@", messageData);
    
    if (err) {
        return nil;
    }
    
    //获得加密数据 前面拼接iv(非加密)
    NSMutableData *result = [NSMutableData dataWithCapacity:0];
    [result appendData:ivData];
    [result appendData:[AESMessage encryptData:messageData key:keyData iv:ivData]];
    return result;
    
}

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
{
    
    if (version == MESSAGE_VER_JSON) {
        //解析json
        if ([self parseJson:body]) {
            return [self parseJson:body];
        }
    }
    
    if (version == MESSAGE_VER_AES) {
        if ([body length] <16) {   //16为iv长度
            return nil;
        }
        //截取iv
        NSData *ivData  = [body subdataWithRange:NSMakeRange(0, 16)];
        NSData *bodyData  = [body subdataWithRange:NSMakeRange(16, [body length]-16)];
        
        //获取key
        NSData *dataKey = [self getKey: deviceId iv:ivData];
        
        //解密
        NSData *newData = [AESMessage decryptData:bodyData key:dataKey iv:ivData];
        
        //去掉iv, 解析json
        if ([self parseJson:newData]) {
            return [self parseJson:newData];
        }
        
    }
    
    return nil;
    
}

//获取key key拼接方法: (iv id password)的NSData类型 再md5
- (NSData *)getKey:(NSString *)deviceId
                iv:(NSData *)ivData;
{
    
    NSMutableData *mutableData = [NSMutableData dataWithCapacity:0];
    
    NSString *devicePassword = @"";
    if (isDebugMode) {
        devicePassword = @"18500272824";
    } else {
        devicePassword = [[GetDevicePassword sharedInstance] getDevicePassword:deviceId];
    }
    
    NSData *devicePasswordData = [devicePassword dataUsingEncoding:NSUTF8StringEncoding];
    NSData *deviceIdData = [deviceId dataUsingEncoding:NSUTF8StringEncoding];
    
    //拼接顺序 ivData + deviceIdData + passwordData
    [mutableData appendData:ivData];
    [mutableData appendData:deviceIdData];
    [mutableData appendData:devicePasswordData];
    
//    NSString * logString;
//    logString = @"";
//    logString = [logString stringByAppendingString: @"\r\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n"];
//    logString = [logString stringByAppendingString:@"Origin key before md5:\r\n"];
//    for(int i=0;i<mutableData.length;i++) {
//        logString = [logString stringByAppendingFormat:@"%02x ", ((uint8_t *)mutableData.bytes)[i]];
//    }
//    logString = [logString stringByAppendingString: @"\r\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n"];
//    
//    LogV(NSStringFromSelector(_cmd),@"%@",logString);
    
    LogV(NSStringFromSelector(_cmd),@"Origin key before md5:%@", mutableData);
    //再一次MD5加密
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(mutableData.bytes, (CC_LONG)mutableData.length, result); // This is the md5 call
    //    CC_MD5_CTX ctx;
    //    CC_MD5_Init(&ctx);
    //    CC_MD5_Update(&ctx, mutableData.bytes, mutableData.length);
    //    CC_MD5_Final(result, &ctx);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    
}

//获取随机16字节iv值
- (NSData *)getIv;
{
    unsigned char result[16];
    for (int i = 0; i < sizeof(result); i++) {
        result[i] = arc4random() % 256;
    }
    NSData *ivData = [NSData dataWithBytes:result length:sizeof(result)];
    return  ivData;
}

//解析json
- (NSDictionary *)parseJson:(NSData *)data
{
    //去掉header, 解析json
    Byte *bytes = (Byte *)[data bytes];
    NSString *firstStr = [NSString stringWithFormat:@"%c",bytes[0]];
    
    if ([firstStr isEqualToString:@"{"] ) { //初步判断为json
        NSError *err = nil;   //尝试解析json
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if (err) {
            return nil;
        }
        return dic;
    }
    return nil;
}

//是否是包括"i","d","t" key的json
- (bool)isContainsKeys:(NSDictionary *)dictionary
{
    if (dictionary.allKeys.count == 3 && [dictionary.allKeys containsObject:@"i"] && [dictionary.allKeys containsObject:@"d"] & [dictionary.allKeys containsObject:@"t"]) {
        return YES;    //判断key是不是 "i","d", "t"
    }
    return NO;
}

@end
