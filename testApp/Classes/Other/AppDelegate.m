//
//  AppDelegate.m
//  testApp
//
//  Created by YanqiaoW on 17/6/5.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYTabBarController.h"
#import "GuidePageView.h"

#import "ZY_APP_CONFIG.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupRootViewContrllor];
    
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = AMap_Key;
    
//    [self setupEaseMob:application didFinishLaunchingWithOptions:launchOptions];
//    
//    [self setupBugTags];
//    
//    [self setupBaiDuMap];
//    
//    [[HBLocationHelper getInstance]start];
//    
//    [[HBPayHelper sharedInstance] registerWxPay];
//    
//    [HBUMengHelper startUMeng];
//    
//    [HBDataHelper saveGiftList:nil];
    

    return YES;
}

#pragma mark 设置RootViewContrllor
-(void)setupRootViewContrllor{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ZYTabBarController *tabBar = [[ZYTabBarController alloc]init];
    
    self.window.rootViewController = tabBar;
    
    [self.window makeKeyAndVisible];
    
//    // 获取当前版本号
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"Version"];
//    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    
//    if (lastVersion == nil || [currentVersion compare:lastVersion options:NSNumericSearch] == NSOrderedDescending){
//        NSArray *imageArray = @[@"引导页1.png",@"引导页2.png",@"引导页3.png"];
//        GuidePageView * guidePageView = [[GuidePageView alloc]initWithFrame:self.window.bounds imageArray:imageArray];
//        [tabBar.view addSubview: guidePageView];
//        
//        //第一次进入完成后 记录一下
//        [[NSUserDefaults standardUserDefaults]setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"Version"];
//    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
