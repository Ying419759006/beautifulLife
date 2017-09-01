//
//  NSString+Size.h
//  ToolClassDemo
//
//  Created by    任亚丽 on 16/8/16.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * 计算文本大小（用于布局）
 */
@interface NSString (Size)

/**
 * 计算文本大小
 * font: 字体大小
 * maxSize: 边界size 返回的size不会大于maxSize
 */
- (CGSize)stringSizeWithFont:(UIFont *)font andConstrainedToSize:(CGSize)maxSize;

@end
