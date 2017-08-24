//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by 白 on 16/6/22.
//  Copyright © 2016年 dzk. All rights reserved.
//  自定义提示框

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate <NSObject>

@optional
- (void)screenSuccess:(NSArray *)selectedBtns;

@end

@interface CustomAlertView : UIView


@property (nonatomic,weak)UIViewController *VC;

@property (nonatomic, weak) id<CustomAlertViewDelegate> delegate;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;


-(instancetype)initWithAlertViewFrame:(CGRect)frame viewcontroller:(UIViewController *)vc;

@end
