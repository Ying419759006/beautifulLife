//
//  PSView.h
//  testApp
//
//  Created by YanqiaoW on 17/7/25.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSView;

@protocol PSViewDelegate <NSObject>

//view被拖动就会调用
- (void)panPSView:(PSView *)psView pan:(UIPanGestureRecognizer *)pan;

@end

@interface PSView : UIImageView

@property (nonatomic,weak) id<PSViewDelegate>delegate;

@end
