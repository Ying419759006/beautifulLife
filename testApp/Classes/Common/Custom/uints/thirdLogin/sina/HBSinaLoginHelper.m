////
////  HBSinaLoginHelper.m
////  hibar
////
////  Created by HXJG-Applemini on 16/5/24.
////  Copyright © 2016年 lan. All rights reserved.
////
//
//#import "HBSinaLoginHelper.h"
//
//@implementation HBSinaUser
//
//+(BOOL)propertyIsOptional:(NSString *)propertyName{
//    return YES;
//}
//
//- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
//    self = [super init];
//    if (self) {
//        self.userId = [dict objectForKey:@"idstr"];
//        self.userName = [dict objectForKey:@"screen_name"];
//        self.headImage = [dict objectForKey:@"profile_image_url"];
//        self.error_code = [dict objectForKey:@"error_code"];
//        self.error = [dict objectForKey:@"error"];
//        NSString *gender = [dict objectForKey:@"gender"];
//        self.gender = [gender isEqualToString:@"m"]?@"1":@"2";
//    }
//    return self;
//}
//
//@end
//
//@interface HBSinaLoginHelper ()
//
//@property (nonatomic,copy) void (^userLoginHandle)(HBSinaUser *user, NSString* errorMsg);
//@property (nonatomic,copy) void (^beforeQueryUserHandle)();
//@property (nonatomic,copy) NSString* secret;
//
//@end
//
//@implementation HBSinaLoginHelper
//
//+ (id)sharedInstance {
//    static HBSinaLoginHelper *sharedInstance = nil;
//    @synchronized(self) {
//        if (!sharedInstance) {
//            sharedInstance = [[self alloc] init];
//        }
//    }
//    return sharedInstance;
//}
//
//- (void)setupAppKey:(NSString *)appKey andSecret:(NSString *)secret{
//    
//    _secret = secret;
//    [WeiboSDK enableDebugMode:NO];
//    [WeiboSDK registerApp:appKey];
//}
//
//-(void)loginWithCompletion:(void (^)(HBSinaUser *, NSString *))completion beforeQueryUserBlock:(void (^)())beforeQueryUserBlock{
//    self.beforeQueryUserHandle = beforeQueryUserBlock;
//    [self loginWithCompletion:completion];
//}
//
//- (void)loginWithCompletion:(void (^)(HBSinaUser *, NSString *))completion{
//    self.userLoginHandle = completion;
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = @"http://open.weibo.com/apps/79208112/info/advanced";
//    request.scope = @"all";
////    [KJGlobalObjects sharedInstance].isWeiboLogin = YES;
//    [WeiboSDK sendRequest:request];
//    
//}
//
//- (WBMessageObject *)messageToShare{
//    WBMessageObject *message = [WBMessageObject message];
//    message.text = @"测试使用";
//    return message;
//}
//
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
//    
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
//    
//    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
//        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
//            [self getUserInfoWithUid:[(WBAuthorizeResponse *)response userID] accessToken:[(WBAuthorizeResponse *)response accessToken]];
//        }else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
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
//- (void)getUserInfoWithUid:(NSString *)userID accessToken:(NSString *)accessToken{
//    if(self.beforeQueryUserHandle){
//        self.beforeQueryUserHandle();
//    }
//    NSString * userInfoUrl = @"https://api.weibo.com/2/users/show.json";
//    [WBHttpRequest requestWithAccessToken:accessToken url:userInfoUrl httpMethod:@"GET" params:@{@"uid":userID,@"access_token":accessToken} delegate:self withTag:@"userInfo"];
//}
//
//- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
//    NSLog(@"result:%@",result);
//    
//    HBSinaUser *user = [[HBSinaUser alloc]initWithString:result error:nil];
//    if (user.error_code.integerValue != 0) {
//        if (self.userLoginHandle) {
//            self.userLoginHandle(nil,user.error);
//        }
//        return;
//    }
//    if (self.userLoginHandle) {
//        self.userLoginHandle(user,nil);
//    }
//}
//
//- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
//    if (self.userLoginHandle) {
//        self.userLoginHandle(nil,@"登录失败");
//    }
//}
//
//- (void)logOut{
//    [WeiboSDK logOutWithToken:_secret delegate:[HBSinaLoginHelper sharedInstance] withTag:@"haibar"];
//}
//
//+ (BOOL)handleOpenURL:(NSURL *)url{
//    
//    return [WeiboSDK handleOpenURL:url delegate:[HBSinaLoginHelper sharedInstance]];
//}
//
//
//@end
