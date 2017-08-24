//
//  PSView.m
//  testApp
//
//  Created by YanqiaoW on 17/7/25.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import "PSView.h"

@implementation PSView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCoverView:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)panCoverView:(UIPanGestureRecognizer *)pan
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(panPSView:pan:)]) {
        [self.delegate panPSView:self pan:pan];
    }
    
}



@end
