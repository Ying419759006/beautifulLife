//
//  Tool.m
//  SmartDeviceSDK
//
//  Created by YanqiaoW on 16/8/24.
//  Copyright © 2016年 yiweibao. All rights reserved.
//

#import "Tool.h"
#import "SVProgressHUD.h"


@interface Tool()

//errorCode 错误码对应中文提示
@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation Tool

- (NSMutableDictionary *)dictionary
{
    if (!_dictionary) {
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
            [_dictionary setValue:@"签名错误" forKey:@"1001"];
            [_dictionary setValue:@"access_key不合法" forKey:@"1002"];
            [_dictionary setValue:@"UNIX时间戳过期" forKey:@"1003"];
            [_dictionary setValue:@"user_token过期" forKey:@"1004"];
            [_dictionary setValue:@"协议不支持" forKey:@"1005"];
            [_dictionary setValue:@"用户注册时提示用户已存在" forKey:@"1101"];
            [_dictionary setValue:@"用户密码不合法" forKey:@"1102"];
            [_dictionary setValue:@"用户名不合法" forKey:@"1103"];
            [_dictionary setValue:@"用户名不存在" forKey:@"1104"];
            [_dictionary setValue:@"用户密码错误" forKey:@"1105"];
            [_dictionary setValue:@"绑定关系已存在" forKey:@"1106"];
            [_dictionary setValue:@"用户不存在" forKey:@"1107"];
            [_dictionary setValue:@"绑定关系不存在" forKey:@"1108"];
            [_dictionary setValue:@"绑定列表不存在" forKey:@"1109"];
            [_dictionary setValue:@"产品信息不存在" forKey:@"1201"];
            [_dictionary setValue:@"设备信息不存在" forKey:@"1202"];
            [_dictionary setValue:@"设备密码错误" forKey:@"1203"];
            [_dictionary setValue:@"协议对应的端口不存在" forKey:@"1204"];
            [_dictionary setValue:@"固件不存在" forKey:@"1205"];
            [_dictionary setValue:@"固件版本非法" forKey:@"1206"];
            [_dictionary setValue:@"固件文件不存在" forKey:@"1207"];
            [_dictionary setValue:@"白名单不存在" forKey:@"1208"];
            [_dictionary setValue:@"授时异常100" forKey:@"1301"];
            [_dictionary setValue:@"绑定关系已存在" forKey:@"1401"];  //新手动增加
            [_dictionary setValue:@"绑定关系不存在" forKey:@"1402"];  //新手动增加
            [_dictionary setValue:@"内部错误" forKey:@"2000"];
            [_dictionary setValue:@"redis连接异常" forKey:@"2001"];
            [_dictionary setValue:@"broker服务器地址不存在" forKey:@"2002"];
            [_dictionary setValue:@"服务端口不存在" forKey:@"2003"];
    }
    return _dictionary;
}

+ (Tool *)sharedTool {
    static Tool *_sharedTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTool = [[Tool alloc] init];
    });
    return _sharedTool;
}
- (NSString *)userID
{
    
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    NSString *userID = [nd objectForKey:@"userId"];
    if (userID == nil || [userID length] < 1) {
        userID = @"";
    }
    return userID;
    
}

- (void)setUserID:(NSString *)userID
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:userID forKey:@"userId"];
    [nd synchronize];
}

- (NSString *)token
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    NSString *tokenStr = [nd objectForKey:@"userToken"];
    if (tokenStr == nil || [tokenStr length] < 1) {
        tokenStr = @"";
    }
    return tokenStr;
}
- (void)setToken:(NSString *)token
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:token forKey:@"userToken"];
    [nd synchronize];
}

+ (BOOL)hasLogin
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    return [nd boolForKey:@"userLogin"];
}

+ (void)setLogin:(BOOL)flag
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setBool:flag forKey:@"userLogin"];
    [nd synchronize];
}

+ (BOOL)isLink
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    return [nd boolForKey:@"isLink"];
}

+ (void)setIsLink:(BOOL)flag
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setBool:flag forKey:@"isLink"];
    [nd synchronize];
}

- (NSString *)lastUsername
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    NSString *lastUsername = [nd objectForKey:@"lastUsername"];
    if (lastUsername == nil || [lastUsername length] < 1) {
        lastUsername = @"";
    }
    return lastUsername;
}

- (void)setLastUsername:(NSString *)lastUsername
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:lastUsername forKey:@"lastUsername"];
    [nd synchronize];
}

- (NSString *)username
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    NSString *username = [nd objectForKey:@"username"];
    if (username == nil || [username length] < 1) {
        username = @"";
    }
    return username;
}

- (void)setUsername:(NSString *)username
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:username forKey:@"username"];
    [nd synchronize];
}

- (NSString *)password
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    NSString *password = [nd objectForKey:@"userPassword"];
    if (password == nil || [password length] < 1) {
        password = @"";
    }
    return password;
}

- (void)setPassword:(NSString *)password
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:password forKey:@"userPassword"];
    [nd synchronize];
}

- (BOOL)isChangeAccount
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    BOOL isChangeAccount = [[nd objectForKey:@"isChangeAccount"] boolValue];
    return isChangeAccount;
}

- (void)setIsChangeAccount:(BOOL)isChangeAccount
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:[NSNumber numberWithBool: isChangeAccount] forKey:@"isChangeAccount"];
    [nd synchronize];
}

- (NSMutableDictionary *)vendorIdDictionary{
    
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *vendorIdDictionary = [nd objectForKey:@"vendorIdDictionary"];
    return vendorIdDictionary;
}

- (void)setVendorIdDictionary:(NSMutableDictionary *)vendorIdDictionary
{
    if (vendorIdDictionary == nil) {
        NSLog(@"Warning : Tool vendorIdDictionary == nil");
        return;
    }
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:vendorIdDictionary forKey:@"vendorIdDictionary"];
    [nd synchronize];
}

- (NSString *)mobile
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [nd objectForKey:@"mobile"];
    if (mobile == nil || [mobile length] < 1) {
        mobile = @"";
    }
    return mobile;
}

- (void)setMobile:(NSString *)mobile
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:mobile forKey:@"mobile"];
    [nd synchronize];
}

//通过时间戳获得uuid规则
+ (NSString*)uuid
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *UID = [ud valueForKey:@"uuid"];
    if (UID == nil ||[UID length] != 12) {
        
        long tmpid = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *nLetterValue;
        NSString *str =@"";
        long long int ttmpig;
        for (int i = 0; i<9; i++) {
            ttmpig=tmpid%16;
            tmpid=tmpid/16;
            switch (ttmpig)
            {
                case 10:
                    nLetterValue =@"A";break;
                case 11:
                    nLetterValue =@"B";break;
                case 12:
                    nLetterValue =@"C";break;
                case 13:
                    nLetterValue =@"D";break;
                case 14:
                    nLetterValue =@"E";break;
                case 15:
                    nLetterValue =@"F";break;
                default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                    
            }
            str = [nLetterValue stringByAppendingString:str];
            if (tmpid == 0) {
                break;
            }
            
        }
        if ([str length] > 12) {
            str = [str substringWithRange:NSMakeRange(0,12)];
        } else if ([str length] < 12){
            int NUMBER_OF_CHARS = (12 - (int)str.length);
            char data[NUMBER_OF_CHARS];
            for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
            NSString *str1 = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
            str = [NSString stringWithFormat:@"%@%@",str,str1];
        }
        
        [ud setValue:str forKey:@"uuid"];
        [ud synchronize];
    }
    return UID;
}

//失败提示框, 能自定义拼接文字, 默认灰色, 提示2秒
- (void)showErrorCodeSVProgressHUD:(NSString *)customString withAppendingString:(NSDictionary *)dictionary
{
    NSString *string = @"";
    NSString *key = [NSString stringWithFormat:@"%@",dictionary[@"errorCode"]];
    NSLog(@"key--->%@--->地址%p",key,self.dictionary);
    NSLog(@"responseJSON--->%@",self.dictionary);
    NSLog(@"responseJSON[@errorCode]--->%@",dictionary[@"errorCode"]);
    
    string = [self.dictionary valueForKey:key];
    NSLog(@"string--->%@",string);
    if (string.length == 0 || string == nil) {
        string = @"新errorCode 未知错误";
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    NSString *showString = [customString stringByAppendingString:[NSString stringWithFormat:@"\n%@",string]];
    [SVProgressHUD showErrorWithStatus:showString];
}

//失败提示框, 能自定义拼接文字, 默认灰色, 提示2秒
+ (void)showErrorSVProgressHUDWithStatus:(NSString *)customString withAppendingString:(NSObject *)object
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
     NSString *showString = [customString stringByAppendingString:[NSString stringWithFormat:@"%@",object]];
    [SVProgressHUD showErrorWithStatus:showString];
}

//失败提示框, 只提示输入字符串, 不拼接, 默认灰色, 提示2秒
+ (void)showErrorSVProgressHUDWithStatus:(NSString *)customString
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showErrorWithStatus:customString];
}

//成功提示框, 能自定义拼接文字, 默认灰色, 提示2秒
+ (void)showSuccessSVProgressHUDWithStatus:(NSString *)customString withAppendingString:(NSObject *)object
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    NSString *showString = [customString stringByAppendingString:[NSString stringWithFormat:@"%@",object]];
    [SVProgressHUD showSuccessWithStatus:showString];
}

//成功提示框, 只提示输入字符串, 不拼接, 默认灰色, 提示2秒
+ (void)showSuccessSVProgressHUDWithStatus:(NSString *)customString
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showSuccessWithStatus:customString];
}

//警告提示框, 只提示输入字符串, 不拼接, 默认灰色, 提示2秒
+ (void)showWarningSVProgressHUDWithStatus:(NSString *)customString time:(int)time
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:time];
    [SVProgressHUD showInfoWithStatus:customString];
}

//获取wifi密码
- (NSString *)wifiPassword
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    NSString *wifiPassword = [nd objectForKey:@"wifiPassword"];
    if (wifiPassword == nil || [wifiPassword length] < 1) {
        wifiPassword = @"";
    }
    return wifiPassword;
}

//设置wifi密码
- (void)setWifiPassword:(NSString *)wifiPassword
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setValue:wifiPassword forKey:@"wifiPassword"];
    [nd synchronize];
}

@end
