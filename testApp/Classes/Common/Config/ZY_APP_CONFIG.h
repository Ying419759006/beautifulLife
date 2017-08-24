//
//  ZY_APP_CONFIG.h
//  testApp
//
//  Created by YanqiaoW on 17/6/5.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#ifndef __ZY_APP_CONFIG_H
#define __ZY_APP_CONFIG_H

#import "ZYConfig.h"

#import <Foundation/Foundation.h>


//服务器地址
#define BASE_URL [ZYConfig BASE_URL]

#define UPLOAD_URL [ZYConfig UPLOAD_URL]

//环信key
#define EASEMOB_KEY [ZYConfig EASEMOB_KEY]

//百度定位
#define BAIDU_MAP_AK [ZYConfig BAIDU_MAP_AK]

//高德地图key
#define AMap_Key [ZYConfig AMap_Key]

//系统发送消息，使用的账号
#define SystemChatId [ZYConfig SystemChatId]

//招呼消息的有效时常(秒) 30分钟
#define CallMsgValidTime [ZYConfig CallMsgValidTime]

// Bugtags appkey
#define BUGTAGS_APP_KEY [ZYConfig BUGTAGS_APP_KEY]

// Bugtags app secret

#define BUGTAGS_APP_SECRET [ZYConfig BUGTAGS_APP_SECRET]

// 支付宝的 URL Schemes
#define ALIPAY_URL_SCHEMES [ZYConfig ALIPAY_URL_SCHEMES]

// 微信AppID

#define WXPAY_APP_ID [ZYConfig WXPAY_APP_ID]

// 汇率 人民币与猫币汇率   一元==定义猫币
#define EXCHANGE_RATE [ZYConfig EXCHANGE_RATE]

// 使用des key 解密 秘钥
#define DES_KEY [ZYConfig DES_KEY]

// 友盟appkey
#define UM_APP_KEY [ZYConfig UM_APP_KEY]

// 是否常显bugtags
#define SHOWBugTAGS [ZYConfig SHOWBugTAGS]

#endif //(__ZY_APP_CONFIG_H)
