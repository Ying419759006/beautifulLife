////
////  HBThirdLoginHelper.h
////  hibar
////
////  Created by HXJG-Applemini on 16/5/24.
////  Copyright © 2016年 lan. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
////#import "HBUserBean.h"
//
//typedef NS_ENUM(NSInteger, HBThirdLoginType) {
//    HBThirdLoginTypeWeixin = 300,      // 微信登录
//    HBThirdLoginTypeQQ,                // QQ登录
//    HBThirdLoginTypeSina,              // 微博登录
//};
//
//// 分享
//typedef NS_ENUM(NSInteger, HBThirdShareType) {
//    HBThirdShareTypeWeiChatSession,         // 微信聊天
//    HBThirdShareTypeWeiChatTimeline,        // 微信朋友圈
//    HBThirdShareTypeQQFriend,               // QQ好友
//    HBThirdShareTypeQZone,                  // QQ空间
//    HBThirdShareTypeOWLFriend               //OWL好友
//};
//
//@interface HBThirdUser : NSObject
//
//@property (nonatomic,copy) NSString* userId;
//@property (nonatomic,copy) NSString* userName;
//@property (nonatomic,copy) NSString* headImage;
//@property (nonatomic,copy) NSString* gender;
//@property (nonatomic,assign) HBThirdLoginType type;
//
//@end
//
//@interface HBThirdLoginHelper : NSObject
//
////QQ登录回调
//+ (void)loginWithType:(HBThirdLoginType)loginType completion:(void (^)(HBThirdUser *user, NSString *error))completion;
//
//+ (void)logoutWithType:(HBThirdLoginType)loginType;
//
//+ (BOOL)handleOpenURL:(NSURL *)url;
//
//+ (NSString *)getPrefixStrWithThirdType:(HBThirdLoginType)type;
//
//+(void)shareWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content type:(HBThirdShareType)type;
//
//+ (void)shareWineToFriend:(NSString *)storageId type:(HBThirdShareType)type;
//
//@end
