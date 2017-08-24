//
//  UIImage+Render.h
//  SmartDevice
//
//  Created by YanqiaoW on 16/9/21.
//  Copyright © 2016年 ewbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Render)

// 提供一个不要渲染图片方法
+ (UIImage *)imageNameWithOriginal:(NSString *)imageName;

// 生成圆角图片
- (UIImage *)circleImage;

@end
