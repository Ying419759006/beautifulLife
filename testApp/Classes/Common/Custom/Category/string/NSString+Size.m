//
//  NSString+Size.m
//  ToolClassDemo
//
//  Created by    任亚丽 on 16/8/16.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

/**
 * 计算文本大小
 * font: 字体大小
 * maxSize: 边界size 返回的size不会大于maxSize
 */
- (CGSize)stringSizeWithFont:(UIFont *)font andConstrainedToSize:(CGSize)maxSize
{
    if ([self isEqual:[NSNull null]]  || [self length] == 0 ) {
        
        return CGSizeZero;
    } else {
        if (!font) {
            font = [UIFont systemFontOfSize:13];
        }
        CGSize size = CGSizeZero;
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            size = [self boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin   attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle.copy, NSParagraphStyleAttributeName, nil] context:Nil].size;
        } else {
            

        }
        
        return size;
    
    }

}
@end
