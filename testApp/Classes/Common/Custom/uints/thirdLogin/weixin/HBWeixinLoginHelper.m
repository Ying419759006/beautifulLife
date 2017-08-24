////
////  HBWeixinLoginHelper.m
////  hibar
////
////  Created by HXJG-Applemini on 16/5/23.
////  Copyright © 2016年 lan. All rights reserved.
////
//
//#import "HBWeixinLoginHelper.h"
//#import "HBCommon.h"
//
//@implementation HBWeixinUser
//
//@end
//
//@interface HBWeixinLoginHelper ()<WXApiDelegate>
//
//@property (nonatomic,copy) void (^userLoginHandle)(HBWeixinUser *user, NSString *errorMsg);
//@property (nonatomic,copy) NSString* appId;
//@property (nonatomic,copy) NSString* secret;
//
//@end
//
//@implementation HBWeixinLoginHelper
//
//+ (id)sharedInstance {
//    static HBWeixinLoginHelper *sharedInstance = nil;
//    @synchronized(self) {
//        if (!sharedInstance) {
//            sharedInstance = [[self alloc] init];
//        }
//    }
//    return sharedInstance;
//}
//
//- (void)setupAppId:(NSString *)appId andSecret:(NSString *)secret{
//    _appId = appId;
//    _secret = secret;
//    [WXApi registerApp:appId];
//}
//
//- (void)loginWithCompletion:(void (^)(HBWeixinUser *, NSString *))completion{
//    self.userLoginHandle = completion;
////    if (![WXApi isWXAppInstalled]) {
////        if (self.userLoginHandle) {
////            self.userLoginHandle(nil,@"未安装微信客户端，请安装后使用");
////        }
////    }else {
////        
////    }
//    SendAuthReq *req = [[SendAuthReq alloc]init];
//    req.scope = @"snsapi_userinfo";
//    req.state = @"5356";
////    [WXApi sendReq:req];
//    [WXApi sendAuthReq:req viewController:[HBUtils getCurrentVC] delegate:self];
//}
//
//- (void)onResp:(BaseResp *)resp{
//    
//    if([resp isKindOfClass:[SendAuthResp class]]){
//        SendAuthResp *myResp = (SendAuthResp *)resp;
//        if (myResp.errCode == WXSuccess) {
//            [self getAccess_tokenWithCode:myResp.code];
//        }else if (myResp.errCode == WXErrCodeUserCancel) {
//            if (self.userLoginHandle) {
//                self.userLoginHandle(nil,@"取消登录");
//            }
//        }else {
//            if (self.userLoginHandle) {
//                self.userLoginHandle(nil,@"登录失败");
//            }
//        }
//    }
//}
//
//- (void)getAccess_tokenWithCode:(NSString *)code{
//    NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",_appId,_secret,code];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *url = [NSURL URLWithString:urlStr];
//        NSString *zoneStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"---------%@",dic);
//                [self getUserInfoWithAccess_token:[dic objectForKey:@"access_token"] andOpenID:[dic objectForKey:@"openid"]];
//                
//            }else {
//                if (self.userLoginHandle) {
//                    self.userLoginHandle(nil,@"登录失败");
//                }
//            }
//        });
//    });
//}
//
//- (void)getUserInfoWithAccess_token:(NSString *)access_token andOpenID:(NSString *)openID{
//    NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openID];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *url = [NSURL URLWithString:urlStr];
//        NSString *zoneStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"+++++++++%@",dic);
//                HBWeixinUser *user = [[HBWeixinUser alloc]init];
//                user.userId = [dic objectForKey:@"openid"];
//                user.userName = [dic objectForKey:@"nickname"];
//                user.headImage = [dic objectForKey:@"headimgurl"];
////                user.gender = [dic objectForKey:@"sex"];
//                if (self.userLoginHandle) {
//                    self.userLoginHandle(user,nil);
//                }
//            }else {
//                if (self.userLoginHandle) {
//                    self.userLoginHandle(nil,@"登录失败");
//                }
//            }
//        });
//    });
//}
//
//- (void)logOut{
//    
//}
//
//+ (BOOL)handleOpenURL:(NSURL *)url{
//    
//    return [WXApi handleOpenURL:url delegate:[HBWeixinLoginHelper sharedInstance]];
//}
//
//+ (void)shareWithUrl:(NSString *)url title:(NSString *)title conent:(NSString *)content type:(HBWeiChatType)type{
//    
//    if (![WXApi isWXAppInstalled]) {
//        [HBUtils toast:@"未安装微信客户端，请安装后使用"];
//        return;
//    }
//    
//    WXMediaMessage *message = [[WXMediaMessage alloc]init];
//    message.title = title;
//    message.description = content;
//    
//    WXWebpageObject *webpageObject = [WXWebpageObject object];
//    webpageObject.webpageUrl = url;
//    message.mediaObject = webpageObject;
//    
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = type;
//    
//    [WXApi sendReq:req];
//}
//
//@end
