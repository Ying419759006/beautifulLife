//
//  CodeScannerMatchView.h
//  SmartDevice
//
//  Created by YanqiaoW on 16/12/14.
//  Copyright © 2016年 ewbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeScannerMatchView : UIView

@property (nonatomic, strong) UIColor *matchFoundColor;
@property (nonatomic, strong) UIColor *scanningColor;
@property (nonatomic, assign) CGFloat minMatchBoxHeight;

- (void)setFoundMatchWithTopLeftPoint:(CGPoint)topLeftPoint
                        topRightPoint:(CGPoint)topRightPoint
                      bottomLeftPoint:(CGPoint)bottomLeftPoint
                     bottomRightPoint:(CGPoint)bottomRightPoint;
- (void)reset;
- (void)stop;
@end
