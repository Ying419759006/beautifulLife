////
////  HBWeixinLoginHelper.h
////  hibar
////
////  Created by HXJG-Applemini on 16/5/23.
////  Copyright © 2016年 lan. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "WXApi.h"
//
//typedef NS_ENUM(NSInteger, HBWeiChatType) {
//    HBWeiChatTypeChat = 0,          //聊天界面
//    HBWeiChatTypeTimeline,          //朋友圈
//};
//
//@interface HBWeixinUser : NSObject
//
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,copy) NSString *userName;
//@property (nonatomic,copy) NSString *gender;
//@property (nonatomic,copy) NSString *headImage;
//@property (nonatomic,copy) NSString *accessToken;
//@property (nonatomic,copy) NSString *openId;
//@property (nonatomic,copy) NSString *expirationDate;
//
//@end
//
//@interface HBWeixinLoginHelper : NSObject
//
//+ (id)sharedInstance;
//
//- (void)setupAppId:(NSString *)appId andSecret:(NSString *)secret;
//
////微信登录回调
//- (void)loginWithCompletion:(void (^)(HBWeixinUser *user, NSString *error))completion;
//
////微信登出
//- (void)logOut;
//
//+ (BOOL)handleOpenURL:(NSURL *)url;
//
//+ (void)shareWithUrl:(NSString *)url title:(NSString *)title conent:(NSString *)content type:(HBWeiChatType)type;
//
//@end
