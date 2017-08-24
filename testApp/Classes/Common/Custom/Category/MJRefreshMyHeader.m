//
//  MJRefreshMyHeader.m
//  MJRefreshExample
//
//  Created by haogaoming on 15/9/20.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshMyHeader.h"

@interface MJRefreshMyHeader ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *centerImageView1;
@property (nonatomic,strong) UIImageView *centerImageView2;

@property (nonatomic,assign) BOOL isEndReflshing;
@end

@implementation MJRefreshMyHeader

- (void)prepare
{
    [super prepare];
//    self.backgroundColor = COLORE7E7E7;
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    self.stateLabel.hidden = YES;
    
    self.mj_h = 58;
    
    //点点点
    self.centerImageView.frame = CGRectMake(0, 0, 50, 50);
    self.centerImageView.alpha = 1;
    
    //刷新
    self.centerImageView1.frame = CGRectMake(0, 0, 50, 50);
    self.centerImageView1.alpha = 0;
    self.centerImageView1.hidden = YES;
    
    //对号
    self.centerImageView2.frame = CGRectMake(0, 0, 50, 50);
    self.centerImageView2.alpha = 0;
    self.centerImageView2.hidden = YES;
}

-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];

        _imageView.image = [UIImage imageNamed:@"MJ_Reflsh_main"];
        _imageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0-25, 4, 50, 50);
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(UIImageView *)centerImageView
{
    if (_centerImageView == nil) {
        _centerImageView = [[UIImageView alloc]init];
        _centerImageView.image = [UIImage imageNamed:@"MJ_Reflsh_one"];
        [self.imageView addSubview:_centerImageView];
    }
    return _centerImageView;
}

-(UIImageView *)centerImageView1
{
    if (_centerImageView1 == nil) {
        _centerImageView1 = [[UIImageView alloc]init];
        _centerImageView1.image = [UIImage imageNamed:@"MJ_Reflsh_two"];
        [self.imageView addSubview:_centerImageView1];
    }
    return _centerImageView1;
}

-(UIImageView *)centerImageView2
{
    if (_centerImageView2 == nil) {
        _centerImageView2 = [[UIImageView alloc]init];
        _centerImageView2.image = [UIImage imageNamed:@"MJ_Reflsh_three"];
        [self.imageView addSubview:_centerImageView2];
    }
    return _centerImageView2;
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];

    
    if(self.state == MJRefreshStatePulling) return;
    
    self.isEndReflshing = NO;
    
    //点点点
    self.centerImageView.frame = CGRectMake(0, 0, 50, 50);
    self.centerImageView.alpha = 1;
    
    //刷新
    self.centerImageView1.frame = CGRectMake(0, self.imageView.frame.size.height-5, 50, 50);
    self.centerImageView1.alpha = 0;
    self.centerImageView1.hidden = YES;
    
    //对号
    self.centerImageView2.frame = CGRectMake(0, self.imageView.frame.size.height-5, 50, 50);
    self.centerImageView2.alpha = 0;
    self.centerImageView2.hidden = YES;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        
        //点点点
        self.centerImageView.frame = CGRectMake(0, 0, 50, 50);
        self.centerImageView.alpha = 1;
        
        //刷新
        self.centerImageView1.frame = CGRectMake(0, 0, 50, 50);
        self.centerImageView1.alpha = 0;
        self.centerImageView1.hidden = YES;
        
        //对号
        self.centerImageView2.frame = CGRectMake(0, 0, 50, 50);
        self.centerImageView2.alpha = 0;
        self.centerImageView2.hidden = YES;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    if(state == MJRefreshStateIdle && self.isEndReflshing == NO){
        [UIView animateWithDuration:0.3 animations:^{
            self.centerImageView.alpha = 1;
            self.centerImageView.frame = CGRectMake(self.centerImageView.frame.origin.x, 0, self.centerImageView.frame.size.width, self.centerImageView.frame.size.height);
            
            self.centerImageView1.hidden = YES;
            self.centerImageView1.alpha = 0;
            self.centerImageView1.frame = CGRectMake(0, self.imageView.frame.size.height-25, 50, 50);
        }];
    }
    if (state == MJRefreshStateRefreshing || state == MJRefreshStatePulling){
        [UIView animateWithDuration:0.3 animations:^{
            self.centerImageView.alpha = 0;
            self.centerImageView.frame = CGRectMake(self.centerImageView.frame.origin.x, -20, self.centerImageView.frame.size.width, self.centerImageView.frame.size.height);
            
            self.centerImageView1.hidden = NO;
            self.centerImageView1.alpha = 1;
            self.centerImageView1.frame = CGRectMake(0, 0, 50, 50);
        } completion:^(BOOL finished) {
            
            CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            rotationAnimation.duration = 1.5;
            rotationAnimation.repeatCount = INT_MAX;//10000000;//你可以设置到最大的整数值
            rotationAnimation.cumulative = NO;
            rotationAnimation.removedOnCompletion = YES;
            rotationAnimation.fillMode = kCAFillModeForwards;
            [self.centerImageView1.layer addAnimation:rotationAnimation forKey:@"Rotation"];
        }];
    }
}

-(void)endRefreshing
{
    self.isEndReflshing = YES;
    [self endRefreshingEEE];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super endRefreshing];
    });
}

-(void)endRefreshingEEE
{
    [UIView animateWithDuration:0.3 animations:^{
        self.centerImageView1.alpha = 0;
        self.centerImageView1.frame = CGRectMake(self.centerImageView1.frame.origin.x, -20, self.centerImageView1.frame.size.width, self.centerImageView1.frame.size.height);
        
        self.centerImageView2.hidden = NO;
        self.centerImageView2.alpha = 1;
        self.centerImageView2.frame = CGRectMake(0, self.imageView.frame.size.height/2.0-25, 50, 50);
    } completion:^(BOOL finished) {
        [self.centerImageView1.layer removeAnimationForKey:@"Rotation"];
    }];
    
}


@end
