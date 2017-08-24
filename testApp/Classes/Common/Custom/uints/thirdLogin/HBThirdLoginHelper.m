////
////  HBThirdLoginHelper.m
////  hibar
////
////  Created by HXJG-Applemini on 16/5/24.
////  Copyright © 2016年 lan. All rights reserved.
////
//
//#import "HBThirdLoginHelper.h"
//#import "HBQQLoginHelper.h"
//#import "HBWeixinLoginHelper.h"
//#import "HBSinaLoginHelper.h"
//#import "HBCommon.h"
//#import "HBConfig.h"
//
//@implementation HBThirdUser
//
//@end
//
//@implementation HBThirdLoginHelper
//
//+ (void)loginWithType:(HBThirdLoginType)loginType completion:(void (^)(HBThirdUser *, NSString *))completion{
//    switch (loginType) {
//        case HBThirdLoginTypeQQ:{
//            [[HBQQLoginHelper sharedInstance] setupAppId:[HBConfig QQ_APP_ID]];
//            [[HBQQLoginHelper sharedInstance] loginWithCompletion:^(HBQQUser *user, NSString *error) {
//                HBThirdUser *thirdUser = [[HBThirdUser alloc]init];
//                thirdUser.userId = user.userId;
//                thirdUser.userName = user.userName;
//                thirdUser.headImage = user.headImage;
//                thirdUser.gender = user.gender;
//                thirdUser.type = loginType;
//                completion(thirdUser,error);
//            }];
//            break;
//        }
//        case HBThirdLoginTypeWeixin:{
//            
//            [[HBWeixinLoginHelper sharedInstance] setupAppId:WXPAY_APP_ID andSecret:[HBConfig WX_APP_SECRET]];
//            [[HBWeixinLoginHelper sharedInstance] loginWithCompletion:^(HBWeixinUser *user, NSString *error) {
//                HBThirdUser *thirdUser = [[HBThirdUser alloc]init];
//                thirdUser.userId = user.userId;
//                thirdUser.userName = user.userName;
//                thirdUser.headImage = user.headImage;
//                thirdUser.gender = user.gender;
//                thirdUser.type = loginType;
//                completion(thirdUser,error);
//            }];
//            
//            break;
//        }
//        case HBThirdLoginTypeSina:{
//            
//            [[HBSinaLoginHelper sharedInstance] setupAppKey:[HBConfig Sina_APP_KEY] andSecret:[HBConfig Sina_APP_SECRET]];
//            [[HBSinaLoginHelper sharedInstance] loginWithCompletion:^(HBSinaUser *user, NSString *error) {
//                HBThirdUser *thirdUser = [[HBThirdUser alloc]init];
//                thirdUser.userId = user.userId;
//                thirdUser.userName = user.userName;
//                thirdUser.headImage = user.headImage;
//                thirdUser.gender = user.gender;
//                thirdUser.type = loginType;
//                completion(thirdUser,error);
//            }];
//            
//            break;
//        }
//            
//        default:
//            break;
//    }
//}
//
//+ (void)logoutWithType:(HBThirdLoginType)loginType{
//    switch (loginType) {
//        case HBThirdLoginTypeQQ:{
//            [[HBQQLoginHelper sharedInstance] logOut];
//            break;
//        }
//        case HBThirdLoginTypeWeixin:{
//            [[HBWeixinLoginHelper sharedInstance] logOut];
//            break;
//        }
//        case HBThirdLoginTypeSina:{
//            [[HBSinaLoginHelper sharedInstance] logOut];
//            break;
//        }
//            
//        default:
//            break;
//    }
//}
//
//+ (BOOL)handleOpenURL:(NSURL *)url{
//    if ([url.scheme hasPrefix:@"wx"]) {
//        [HBWeixinLoginHelper handleOpenURL:url];
//    }else if ([url.scheme hasPrefix:@"tencent"]) {
//        [HBQQLoginHelper handleOpenURL:url];
//    }else if ([url.scheme hasPrefix:@"wb"]) {
//        [HBSinaLoginHelper handleOpenURL:url];
//    }
//    return YES;
//}
//
//+ (NSString *)getPrefixStrWithThirdType:(HBThirdLoginType)type{
//    NSString *str;
//    switch (type) {
//        case HBThirdLoginTypeWeixin:{
//            str = @"wx";
//            break;
//        }
//        case HBThirdLoginTypeQQ:{
//            str = @"qq";
//            break;
//        }
//        case HBThirdLoginTypeSina:{
//            str = @"wb";
//            break;
//        }
//            
//        default:
//            break;
//    }
//    return str;
//}
//
//
//+(void)shareWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content type:(HBThirdShareType)type{
//    switch (type) {
//        case HBThirdShareTypeWeiChatSession:{
//            [HBWeixinLoginHelper shareWithUrl:url title:title conent:@"" type:HBWeiChatTypeChat];
//            break;
//        }
//        case HBThirdShareTypeWeiChatTimeline:{
//            [HBWeixinLoginHelper shareWithUrl:url title:title conent:content type:HBWeiChatTypeTimeline];
//            break;
//        }
//        case HBThirdShareTypeQQFriend:{
//            [HBQQLoginHelper shareWithUrl:url title:title content:content type:HBQQShareInChatTypeChat];
//            break;
//        }
//        case HBThirdShareTypeQZone:{
//            [HBQQLoginHelper shareWithUrl:url title:title content:content type:HBQQShareInChatTypeQZone];
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//+ (void)shareWineToFriend:(NSString *)storageId type:(HBThirdShareType)type{
//    
//    HB12607Req *req = [[HB12607Req alloc]init];
//    
//    req.storageId = storageId;
//    
//    
//    [HBHttpHelper postRequest:req sucBlock:^(NSString *jsonString) {
//        
//        HB12607Resp *resp = [[HB12607Resp alloc]initWithString:jsonString error:nil];
//        [HBThirdLoginHelper shareWithUrl:resp.url title:resp.title content:resp.content type:type];
//        
//    } responseErrorBlock:^(HBResponseError *respError) {
//        
//    } endRefreshBlock:^{
//        
//    }];
//    
//}
//
//@end
