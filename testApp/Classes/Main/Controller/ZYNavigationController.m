//
//  ZYNavigationComntroller.m
//  SmartDevice
//
//  Created by YanqiaoW on 16/11/18.
//  Copyright © 2016年 ewbao. All rights reserved.
//

#import "ZYNavigationController.h"

@interface ZYNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZYNavigationController

+ (void)load
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    UINavigationBar *bar;
    if (version.doubleValue >= 9.0) {
        //获取指定类下面的导航条
        bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[ZYNavigationController class]]];
    } else {
        bar = [UINavigationBar appearanceWhenContainedIn:[ZYNavigationController class], nil];
    }
    
    [bar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor orangeColor];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    
    [bar setTitleTextAttributes:dict];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 滑动功能
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    
    // 控制器手势什么时候触发
    pan.delegate = self;

    // 清空手势代理,恢复滑动返回功能
    self.interactivePopGestureRecognizer.enabled = NO;

}

#pragma mark - UIGestureRecognizerDelegate
// 是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 在根控制器下 不要 触发手势
    return self.childViewControllers.count > 1;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 非根控制器
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 非根控制器才需要设置返回按钮
        // 设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton sizeToFit];
        
        // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
    }
    
    // 这个方法才是真正执行跳转
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
@end
