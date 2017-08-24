//
//  ZYTabBar.m
//  SmartDevice
//
//  Created by YanqiaoW on 16/11/18.
//  Copyright © 2016年 ewbao. All rights reserved.


#import "ZYTabBar.h"
#import "UIView+category.h"


@interface ZYTabBar ()

@property (nonatomic, weak) UIButton *plusButton;

/** 上一次点击的tabBar按钮 */
@property (nonatomic, weak) UIControl *previousClickedTabBarButton;
//
@end
//
@implementation ZYTabBar
//
- (UIButton *)plusButton
{
    if (_plusButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"爱心"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"爱心选中"] forState:UIControlStateHighlighted];
        
        // 根据自己内容(图片,标题)去计算尺寸
        [btn sizeToFit];
        
        _plusButton = btn;
        
        [self addSubview:btn];
    }
    
    return _plusButton;
}
/*
    发现系统有这个类,但是就是敲不出来,说明这个类 私有API
    私有API : 只能苹果使用, 你使用不了
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
     //中间是自定义按钮的tabbar
    NSInteger count = self.items.count + 1;
    
    // 调整内部子控件的位置
//    NSLog(@"%@",self.subviews);
    CGFloat btnX = 0;
    CGFloat btnY = 0;

    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    int i = 0;
    // 遍历子控件
    for (UIControl *tabBarButton in self.subviews) {
        if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        if (i == 0 && self.previousClickedTabBarButton == nil) { // 最前面的tabBarButton
            self.previousClickedTabBarButton = tabBarButton;
        }
        
        if (i == 1) {
            i += 1;
        }
        
        btnX = i * btnW;
        
        //  UITabBarButton
        tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        i++;
        
        // 监听点击
        // 短时间内连续点击按钮就会触发UIControlEventTouchDownRepeat事件
//        [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchDownRepeat];
        [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 设置加号按钮居中
//    self.plusButton.center = self.center;
    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
//    if (self.previousClickedTabBarButton == tabBarButton) {
//        // 告诉外界，tabBarButton被重复点击了
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarButtonDidRepeatClickNotification" object:nil];
//    }
//    
//    self.previousClickedTabBarButton = tabBarButton;
}
@end
