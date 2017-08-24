//
//  UIView+category.h
//  BaseProjectOC
//
//  Created by zhaoying on 16/7/22.
//  Copyright © 2016年 赵莹. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

//手势管理器-类型
typedef NS_ENUM(NSInteger, GestureRecognizerType) {
    UITapGestureRecognizerStyle = 0,
    UISwipeGestureRecognizerDirectionLeftStyle,
    UISwipeGestureRecognizerDirectionRightStyle,
    UISwipeGestureRecognizerDirectionUpStyle,
    UIPanGestureRecognizerStyle,
};

@interface UIView (category)
/**
 *  手势管理器
 *
 *  @param style    手势的样式
 *  @param delegate 代理
 *  @param section  方法
 */
-(UIGestureRecognizer *)AddGestureRecognizer:(GestureRecognizerType)style delegate:(id)delegate  Section:(SEL)section;

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@property CGFloat centerY;
@property CGFloat centerX;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;


@end
