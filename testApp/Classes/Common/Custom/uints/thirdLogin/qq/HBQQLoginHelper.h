////
////  HBQQLoginHelper.h
////  hibar
////
////  Created by HXJG-Applemini on 16/5/24.
////  Copyright © 2016年 lan. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//
//typedef NS_ENUM(NSInteger, HBQQShareInChatType) {
//    HBQQShareInChatTypeChat,            //qq聊天
//    HBQQShareInChatTypeQZone,           //qq控件
//};
//
//@interface HBQQUser : NSObject
//
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,copy) NSString *userName;
//@property (nonatomic,copy) NSString *headImage;
//@property (nonatomic,copy) NSString *accessToken;
//@property (nonatomic,copy) NSString *openId;
//@property (nonatomic,copy) NSString *expirationDate;
//@property (nonatomic,copy) NSString *gender;
//
//@end
//
//@interface HBQQLoginHelper : NSObject
//
//+ (HBQQLoginHelper *)sharedInstance;
//
//- (void)setupAppId:(NSString *)appId;
//
////QQ登录回调
//- (void)loginWithCompletion:(void (^)(HBQQUser *user, NSString *error))completion;
//
////QQ登出
//- (void)logOut;
//
//+ (BOOL)handleOpenURL:(NSURL *)url;
//
//+ (void)shareWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content type:(HBQQShareInChatType)type;
//
//@end
