//
//  UIColor+JZColorful.h
//  jianzhengbeian
//
//  Created by haoxiangfeng on 14-5-13.
//  Copyright (c) 2014年 artron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JZColorful)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;

//随机颜色
+ (UIColor *)randomColor;

/**
 *  color 转 image
 *
 *  @param color
 *
 *  @return image
 */
+ (UIImage *)createImageWithColor:(UIColor*)color;
@end
