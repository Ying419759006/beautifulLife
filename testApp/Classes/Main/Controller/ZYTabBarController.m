//
//  ZYTabBarController.m
//  SmartDevice
//
//  Created by YanqiaoW on 16/11/18.
//  Copyright © 2016年 ewbao. All rights reserved.
//

#import "ZYTabBarController.h"
#import "ZYTabBar.h"
#import "ZYNavigationController.h"
#import "PSController.h"
#import "HBPhotosViewController.h"
#import "CenterController.h"
#import "UIImage+Render.h"

@interface ZYTabBarController ()

@end

@implementation ZYTabBarController

+ (void)load
{
    // 获取当前类的tabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    // 设置所有item的选中时颜色
    // 设置选中文字颜色
    // 创建字典去描述文本
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    // 文本颜色 -> 描述富文本属性的key -> NSAttributedString.h
    attr[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attr forState:UIControlStateSelected];

    // 通过normal状态设置字体大小
    // 字体大小 跟 normal
    NSMutableDictionary *attrnor = [NSMutableDictionary dictionary];
   
    // 设置字体
    attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrnor[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    [item setTitleTextAttributes:attrnor forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加所有子控制器
    [self setupAllChildViewController];
    
    // 设置tabBar上对应按钮内容 -> 由对应的子控制器的tabBarItem 决定
    [self setupAllTileButton];
    
    // 自定义tabBar
    [self setupTabBar];
}

#pragma mark - 添加所有的子控制器
- (void)setupAllChildViewController
{
    //ps界面
    PSController *vc0 = [[PSController alloc] init];
    ZYNavigationController *nav0 = [[ZYNavigationController alloc] initWithRootViewController:vc0];
    [self addChildViewController:nav0];
    
    //相册-->滤镜界面
    HBPhotosViewController *vc2 = [[HBPhotosViewController alloc] init];
    ZYNavigationController *nav2 = [[ZYNavigationController alloc] initWithRootViewController:vc2];
    [self addChildViewController:nav2];
    
}


#pragma mark - 自定义tabBar
- (void)setupTabBar
{
    ZYTabBar *tabBar = [[ZYTabBar alloc] init];
 
    // 替换系统的tabBar KVC:设置readonly属性
    [self setValue:tabBar forKey:@"tabBar"];
}

/*
 Changing the delegate of 【a tab bar managed by a tab bar controller】 is not allowed.
 被UITabBarController所管理的UITabBar，它的delegate不允许被修改
 */

#pragma mark - 设置所有标题按钮内容
- (void)setupAllTileButton
{
    // PS靓图
    UINavigationController *nav = self.childViewControllers[0];
    // 标题
    nav.tabBarItem.title = @"靓图";
    // 图片
    nav.tabBarItem.image = [UIImage imageNamed:@"PS"];
    // 选中
    nav.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"PS"];
    
    
    
//    // 吃货
//    UINavigationController *nav1 = self.childViewControllers[1];
//    // 标题
//    nav1.tabBarItem.title = @"关心";
//    // 图片
//    nav1.tabBarItem.image = [UIImage imageNameWithOriginal:@"爱心"];
//    // 选中
//    nav1.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"爱心选中"];
    
    
    // 滤镜
    UINavigationController *nav2 = self.childViewControllers[1];
    // 标题
    nav2.tabBarItem.title = @"滤镜";
    // 图片
    nav2.tabBarItem.image = [UIImage imageNamed:@"相册"];
    // 选中
    nav2.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"相册"];
  
}

@end
