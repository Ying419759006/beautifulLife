//
//  DeviceManager.m
//  Devicexx
//
//  Created by yager on 8/15/2016.
//  Copyright © 2016年 device++. All rights reserved.
//

#import "DeviceManager.h"

#import "CommConfig.h"

//#import "GCDAsyncUdpSocket.h"

//#import "MQTTClient.h"
#import "MQTTKit/MQTTKit.h"

#import "MKNetworkKit.h"

#import "EncryptionTool.h"

#import "UserManager.h"

#import "NSMutableDictionary+dealNil.h"

#import "DevicexxMessage.h"


//控制设备消息订阅和发布
#define kSubscribeTopicPrefix @"dev2app/"
#define kPublishTopicPrefix   @"app2dev/"


@interface DeviceManager ()

//MQTTsession 字典数组
@property (nonatomic, strong) NSMutableDictionary *sessionDictionary;

typedef void (^DeviceControlCompletionHandler)(NSString *deviceId, NSDictionary *info, NSError *error);
typedef void (^DeviceControlRawDataCompletionHandler)(NSString *deviceId, NSData *data, NSError *error);

@property (nonatomic, copy) DeviceControlCompletionHandler controlHandler;
@property (nonatomic, copy) DeviceControlRawDataCompletionHandler controlRawDataHandler;

@end

@implementation DeviceManager

+ (DeviceManager *)sharedInstance
{
    static DeviceManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DeviceManager alloc] init];
    });
    return _instance;
}

- (NSMutableDictionary *)sessionDictionary
{
    if (!_sessionDictionary) {
        _sessionDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _sessionDictionary;
}

- (void)openMQTTServerWithUserId:(NSString *)userId
                       serverUrl:(NSString *)serverUrl
                        userName:(NSString *)username
                        password:(NSString *)password
                            uuid:(NSString *)uuid
               completionHandler:(void (^)(NSString *deviceId, NSDictionary *devInfo, NSError *error))completionHandler
{
    // call through to parent class implementation, if you want
    [self openMQTTServerWithUserId:userId
                         serverUrl:serverUrl
                          userName:username
                          password:password
                              uuid:uuid
                 completionHandler:completionHandler
          rawDataCompletionHandler:nil];
}

- (void)openMQTTServerWithUserId:(NSString *)userId
                       serverUrl:(NSString *)serverUrl
                        userName:(NSString *)username
                        password:(NSString *)password
                            uuid:(NSString *)uuid
               completionHandler:(void (^)(NSString *deviceId, NSDictionary *devInfo, NSError *error))completionHandler
        rawDataCompletionHandler:(void (^)(NSString *deviceId, NSData *data, NSError *error))rawDataCompletionHandler
{
    self.controlHandler = completionHandler;
    self.controlRawDataHandler = rawDataCompletionHandler;
    
    
    NSArray *hostPort = [self getHostAndPortByUrl:serverUrl];
    
    if ([hostPort count] <= 1) { //跳转页面
        NSLog(@"serverUrl error");
        return;
    }
    
    NSString *serverHost = hostPort[0];
    
    MQTTClient *session = [[MQTTClient alloc] initWithClientId:[NSString stringWithFormat:@"u:%@:ios:%@", userId, uuid] cleanSession:NO];
    session.username = username;
    session.password = password;
    //新增session数组
    if (![self.sessionDictionary.allKeys containsObject:serverUrl]) {
        [self.sessionDictionary setObjectDealNil:session forKey:serverUrl];
    }
    
    [session connectToHost:serverHost completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
            NSLog(@"MQTTConnectionReturnCode ConnectionAccepted");
            
        }
    }];
    
    //反馈回调
    [session setMessageHandler:^(MQTTMessage *message) {
        
        // NSString *jsonString = [message payloadString];
        NSData *payloadData = message.payload;
        NSString *deviceId = [message.topic componentsSeparatedByString:@"/"][1];
        
        NSError *err = nil;
        
        if (payloadData) {
            
            NSLog(@"MQTT receive payloadData success:%@",payloadData);
            
            if (rawDataCompletionHandler) {
                rawDataCompletionHandler(deviceId, payloadData, err);
            }
            
            NSDictionary *dic = [[DevicexxMessage sharedInstance] messageParser:payloadData deviceId:deviceId];
            
            if(!dic) {
                
                NSLog(@"MQTT receive payloadData parse to dictionary fail");
                
            } else {
                
                if ([[DevicexxMessage sharedInstance] isContainsKeys:dic]) { //指定的key的json才返回
                    //外加deviceId
                    NSMutableDictionary *reusultInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
                    //                    [reusultInfo setObjectDealNil:deviceId forKey:@"deviceId"];
                    
                    if (completionHandler) {
                        completionHandler(deviceId, reusultInfo, err);
                    }
                }
                
            }
        } else {
            // payload无返回值
            NSLog(@"Warning : MQTTMessage *message payload == nil");
            
        }
    }];
}

//@"mqtt://s1.vcd.io:1883"
- (NSArray *)getHostAndPortByUrl:(NSString *)url
{
    NSRange range = [url rangeOfString:@"://"];
    url = [url substringFromIndex:range.location + 3];
    NSArray *arr = [url componentsSeparatedByString:@":"];
    NSLog(@"serverUrl host:%@ , port:%@",arr[0],arr[1]);
    return arr;
}

//取消所有client
- (void)disconnectAllServerUrl
{
    [self.sessionDictionary removeAllObjects];
}

//此MQTT连接是否可以用来发布(控制)设备
- (BOOL)isCanPublish:(NSString *)serverUrl
{
    return [[self.sessionDictionary objectForKey:serverUrl] connected];
}

- (void)publishMessage:(NSString *)deviceId serverUrl:(NSString *)serverUrl params:(NSDictionary *)params
{
    // Check parameters
    if((nil!= deviceId) &&
       (nil!= serverUrl) &&
       (nil!=params)&&
       (deviceId.length>0)&&
       (serverUrl.length>0)&&
       ([params count]>0)) {
        
        NSData *messageData = [[DevicexxMessage sharedInstance] messageBuilder:params deviceId:deviceId version:3 cmdid:2203 seq:1 checksum:0 flag:0];
        
        NSLog(@"publishMessageData :%@",messageData);
        
        //测试使用
        //                NSDictionary *dic = [[DevicexxMessage sharedInstance] messageParser:messageData deviceId:deviceId];
        //                NSLog(@"dic : %@",dic);
        
        //发布消息
        NSString *topic = [NSString stringWithFormat:@"%@%@", kPublishTopicPrefix, deviceId];
        
        // when the client is connected, send a MQTT message
        [[self.sessionDictionary objectForKey:serverUrl] publishData:messageData toTopic:topic withQos:AtMostOnce retain:NO completionHandler:^(int mid) {
            NSLog(@"publish params scusess");
        }];
        
    }
}

- (void)publishMessage:(NSString *)deviceId serverUrl:(NSString *)serverUrl data:(NSData *)data
{
    // Check parameters
    if((nil!= deviceId) &&
       (nil!= serverUrl) &&
       (nil!=data)&&
       (deviceId.length>0)&&
       (serverUrl.length>0)&&
       (data.length>0)) {
        //发布消息
        NSString *topic = [NSString stringWithFormat:@"%@%@", kPublishTopicPrefix, deviceId];
        
        // when the client is connected, send a MQTT message
        [[self.sessionDictionary objectForKey:serverUrl] publishData:data
                                                             toTopic:topic
                                                             withQos:AtMostOnce
                                                              retain:NO
                                                   completionHandler:^(int mid) {
                                                       NSLog(@"publish data scusess");
                                                       
                                                   }];
    }
}

//新增订阅规则
- (void)subscribeMessage:(NSString *)deviceId serverUrl:(NSString *)serverUrl
{
    //订阅Topic
    NSString *topic = [NSString stringWithFormat:@"%@%@", kSubscribeTopicPrefix, deviceId];
    
    [[self.sessionDictionary objectForKey:serverUrl] subscribe:topic withQos:2 completionHandler:^(NSArray *grantedQos) {
        if (grantedQos.count) {
            NSLog(@"Subscription sucessfull! Granted Qos: %@", grantedQos);
        }
    }];
}


@end
