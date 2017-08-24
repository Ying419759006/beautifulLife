////
////  HBQQLoginHelper.m
////  hibar
////
////  Created by HXJG-Applemini on 16/5/24.
////  Copyright © 2016年 lan. All rights reserved.
////
//
//#import "HBQQLoginHelper.h"
//#import "TencentOpenAPI/QQApiInterface.h"
//#import "HBConfig.h"
//
//@implementation HBQQUser
//
//@end
//
//@interface HBQQLoginHelper ()<TencentSessionDelegate>
//
//@property (nonatomic,copy) void (^userLoginHandle)(HBQQUser *user, NSString* errorMsg);
//@property (nonatomic,strong) TencentOAuth *tencentOAuth;
//@property (nonatomic,strong) NSArray* permissions;
//
//@end
//
//@implementation HBQQLoginHelper
//
//+ (HBQQLoginHelper *)sharedInstance{
//    static HBQQLoginHelper *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[HBQQLoginHelper alloc]init];
//    });
//    return sharedInstance;
//}
//
//- (void)setupAppId:(NSString *)appId{
//    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:appId andDelegate:self];
//    _permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_ADD_TOPIC,kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
//}
//
//- (void)loginWithCompletion:(void (^)(HBQQUser *, NSString *))completion{
//    self.userLoginHandle = completion;
//    [_tencentOAuth authorize:_permissions inSafari:NO];
//}
//
//- (void)logOut{
//    [_tencentOAuth logout:self];
//}
//
//#pragma mark TencentSessionDelegate Mothed
//- (void)tencentDidLogin{
//    //    NSLog(@"tencentDidLogin");
//    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]) {
//        [_tencentOAuth getUserInfo];
//    }
//}
//
//- (void)tencentDidLogout{
//    
//    //    NSLog(@"tencentDidLogout");
//    
//}
//
//- (void)tencentDidNotLogin:(BOOL)cancelled{
//    
//    //    NSLog(@"tencentDidNotLogin");
//    NSString *errorMessage;
//    if (cancelled) {
//        errorMessage = @"取消登录";
//    }else {
//        errorMessage = @"登录失败";
//    }
//    if (self.userLoginHandle) {
//        self.userLoginHandle(nil,errorMessage);
//    }
//}
//
//- (void)tencentDidNotNetWork{
//    //    NSLog(@"tencentDidNotNetWork");
//    if (self.userLoginHandle) {
//        self.userLoginHandle(nil,@"无网络连接，请重新设置网络");
//    }
//}
//
//- (void)getUserInfoResponse:(APIResponse *)response{
//    HBQQUser *qqUser = [[HBQQUser alloc]init];
//    NSLog(@"userInfo : %@",response.jsonResponse);
//    qqUser.userName = response.jsonResponse[@"nickname"];
//    qqUser.headImage = response.jsonResponse[@"figureurl_qq_2"];
//    qqUser.userId = [_tencentOAuth openId];
//    NSString *gender = response.jsonResponse[@"gender"];
//    if (![gender isEqualToString:@""] && gender != nil) {
//        qqUser.gender = [gender isEqualToString:@"男"]?@"1":@"2";
//    }
//    
//    if (self.userLoginHandle) {
//        self.userLoginHandle(qqUser,nil);
//    }
//}
//
//+ (BOOL)handleOpenURL:(NSURL *)url{
//    return [TencentOAuth HandleOpenURL:url];
//}
//
//+ (void)shareWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content type:(HBQQShareInChatType)type{
//    [[HBQQLoginHelper sharedInstance] setupAppId:[HBConfig QQ_APP_ID]];
//    //分享图预览图URL地址
//    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:content previewImageURL:[NSURL URLWithString:@""]];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
//    switch (type) {
//        case HBQQShareInChatTypeChat:{
//            //将内容分享到qq
//            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//            break;
//        }
//        case HBQQShareInChatTypeQZone:{
//            //将内容分享到qzone
//            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
//            break;
//        }
//            
//        default:
//            break;
//    }
//    
//    
//
//}
//
//@end
