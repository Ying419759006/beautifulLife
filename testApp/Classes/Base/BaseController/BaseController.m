//
//  BaseController.m
//  testApp
//
//  Created by YanqiaoW on 17/6/5.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableViewController = [[UITableView alloc] init];
    tableViewController.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
