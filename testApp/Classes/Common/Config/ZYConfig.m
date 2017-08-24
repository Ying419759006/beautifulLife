//
//  ZYConfig.m
//  testApp
//
//  Created by YanqiaoW on 17/6/5.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import "ZYConfig.h"

//是否是发布
const static BOOL publish=NO;

@interface ZYConfig()

@property (nonatomic,strong) NSDictionary* config;

@end


@implementation ZYConfig

+(ZYConfig*)sharedConfig{
    
    static ZYConfig * __sharedConfig;
    
    if(__sharedConfig==nil){
        
        __sharedConfig=[[ZYConfig alloc]init];
        
    }
    return __sharedConfig;
}

-(instancetype)init{
    if (self=[super init]) {
        NSString *fileName;
        if (publish) {
            fileName=@"ReleaseConfig";
        }else{
            fileName=@"TestConfig";
        }
        
        NSString *path=[[NSBundle mainBundle]pathForResource:fileName ofType:@".plist"];
//        NSLog(@"path : %@",path);
        _config=[[NSDictionary alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    }
    return self;
}

//服务器地址
+(NSString*)BASE_URL{
    return [[ZYConfig sharedConfig].config objectForKey:@"ServerURL"];
}

//上传地址
+(NSString*)UPLOAD_URL{
    return [[ZYConfig sharedConfig].config objectForKey:@"ServerUploadURL"];
}

//环信的key值
+(NSString*)EASEMOB_KEY{
    return [[ZYConfig sharedConfig].config objectForKey:@"EaseMobKey"];
}

//百度的Key值
+(NSString*)BAIDU_MAP_AK{
    return [[ZYConfig sharedConfig].config objectForKey:@"BAIDU_MAP_AK"];
}

//高德地图的Key值
+(NSString*)AMap_Key{
    return [[ZYConfig sharedConfig].config objectForKey:@"AMap_Key"];
}

//环信消息发过来时，判断的系统帐号
+(NSString*)SystemChatId{
    return [[ZYConfig sharedConfig].config objectForKey:@"SystemChatId"];
}

//招呼消息的有效时常配置
+(CGFloat)CallMsgValidTime{
    return [[[ZYConfig sharedConfig].config objectForKey:@"CallMsgValidTime"] floatValue];
}

//bugtag的key
+(NSString*)BUGTAGS_APP_KEY{
    return [[ZYConfig sharedConfig].config objectForKey:@"BUGTAGS_APP_KEY"];
}

//bugtag的secret
+(NSString*)BUGTAGS_APP_SECRET{
    return [[ZYConfig sharedConfig].config objectForKey:@"BUGTAGS_APP_SECRET"];
}

//支付宝的URL Schemes
+(NSString*)ALIPAY_URL_SCHEMES{
    return [[ZYConfig sharedConfig].config objectForKey:@"ALIPAY_URL_SCHEMES"];
}

//微信AppID
+(NSString*)WXPAY_APP_ID{
    return [[ZYConfig sharedConfig].config objectForKey:@"WXPAY_APP_ID"];
}

// 微信appSecret
+(NSString*)WX_APP_SECRET{
    return [[ZYConfig sharedConfig].config objectForKey:@"WX_APP_SECRET"];
}

// 汇率 人民币与猫币汇率   一元==10猫币
+(CGFloat)EXCHANGE_RATE{
    return [[[ZYConfig sharedConfig].config objectForKey:@"EXCHANGE_RATE"] floatValue];
}

// 使用des key 解密 秘钥
+(NSString*)DES_KEY{
    return [[ZYConfig sharedConfig].config objectForKey:@"DES_KEY"];
}

//是否加密
+(BOOL)DES_ENABLE{
    return [[[ZYConfig sharedConfig].config objectForKey:@"DES_ENABLE"] boolValue];
}

// 友盟appkey
+(NSString*)UM_APP_KEY{
    return [[ZYConfig sharedConfig].config objectForKey:@"UM_APP_KEY"];
}

// 是否常显bugtags
+(BOOL)SHOWBugTAGS{
    return [[[ZYConfig sharedConfig].config objectForKey:@"SHOWBugTAGS"] boolValue];
}

// qq appid
+(NSString*)QQ_APP_ID{
    return [[ZYConfig sharedConfig].config objectForKey:@"QQ_APP_ID"];
}

// qq appkey
+(NSString*)QQ_APP_KEY{
    return [[ZYConfig sharedConfig].config objectForKey:@"QQ_APP_KEY"];
}

// 新浪微博 app Key
+(NSString*)Sina_APP_KEY{
    return [[ZYConfig sharedConfig].config objectForKey:@"Sina_APP_KEY"];
}

// 新浪微博 app secret
+(NSString*)Sina_APP_SECRET{
    return [[ZYConfig sharedConfig].config objectForKey:@"Sina_APP_SECRET"];
}

+(NSString*)Apns_Push_Debug{
    return [[ZYConfig sharedConfig].config objectForKey:@"Apns_Push_Debug"];
}

+(NSString*)Apns_Push{
    return [[ZYConfig sharedConfig].config objectForKey:@"Apns_Push"];
}


@end
