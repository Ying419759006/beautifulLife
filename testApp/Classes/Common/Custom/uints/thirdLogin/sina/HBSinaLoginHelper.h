////
////  HBSinaLoginHelper.h
////  hibar
////
////  Created by HXJG-Applemini on 16/5/24.
////  Copyright © 2016年 lan. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "JSONModel.h"
//#import "WeiboSDK.h"
//
//@interface HBSinaUser : JSONModel
//
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,copy) NSString *userName;
//@property (nonatomic,copy) NSString *headImage;
//@property (nonatomic,copy) NSString *accessToken;
//@property (nonatomic,copy) NSString *openId;
//@property (nonatomic,copy) NSString *expirationDate;
//@property (nonatomic,strong) NSNumber *error_code;
//@property (nonatomic,copy) NSString *error;
//@property (nonatomic,copy) NSString *gender;
//
//@end
//
//@interface HBSinaLoginHelper : NSObject<WeiboSDKDelegate,WBHttpRequestDelegate>
//
//+ (id)sharedInstance;
//
//- (void)setupAppKey:(NSString *)appKey andSecret:(NSString *)secret;
//
////微博登录回调
//- (void)loginWithCompletion:(void (^)(HBSinaUser *user, NSString *error))completion;
//- (void)loginWithCompletion:(void (^)(HBSinaUser *user, NSString *error))completion beforeQueryUserBlock:(void (^)()) beforeQueryUserBlock;
//
////微博登出
//- (void)logOut;
//
//+ (BOOL)handleOpenURL:(NSURL *)url;
//
//@end
