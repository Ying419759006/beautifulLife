//
//  ZYConfig.h
//  testApp
//
//  Created by YanqiaoW on 17/6/5.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYConfig : NSObject


//服务器地址
+(NSString*)BASE_URL;

//上传地址
+(NSString*)UPLOAD_URL;

//环信的key值
+(NSString*)EASEMOB_KEY;

//百度的Key值
+(NSString*)BAIDU_MAP_AK;

//高德地图的Key值
+(NSString*)AMap_Key;

//环信消息发过来时，判断的系统帐号
+(NSString*)SystemChatId;

//招呼消息的有效时常配置
+(CGFloat)CallMsgValidTime;

//bugtag的key
+(NSString*)BUGTAGS_APP_KEY;

//bugtag的secret
+(NSString*)BUGTAGS_APP_SECRET;

//支付宝的URL Schemes
+(NSString*)ALIPAY_URL_SCHEMES;

//微信AppID
+(NSString*)WXPAY_APP_ID;

// 微信appSecret
+(NSString*)WX_APP_SECRET;

// 汇率 人民币与猫币汇率   一元==10猫币
+(CGFloat)EXCHANGE_RATE;

// 使用des key 解密 秘钥
+(NSString*)DES_KEY;

//是否加密
+(BOOL)DES_ENABLE;

// 友盟appkey
+(NSString*)UM_APP_KEY;

// 是否常显bugtags
+(BOOL)SHOWBugTAGS;

// qq appid
+(NSString*)QQ_APP_ID;

// qq appkey
+(NSString*)QQ_APP_KEY;

// 新浪微博 app Key
+(NSString*)Sina_APP_KEY;

// 新浪微博 app secret
+(NSString*)Sina_APP_SECRET;

+(NSString*)Apns_Push_Debug;

+(NSString*)Apns_Push;

@end
