//
//  NSString+Attribute.m
//  ToolClassDemo
//
//  Created by    任亚丽 on 16/8/16.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "NSString+Attribute.h"

@implementation NSString (Attribute)


/**
 * 组装NSMutableAttributedString1
 */
+ (NSMutableAttributedString *)getAttributedStringFromString:(NSString *)str Color:(UIColor *)color Fount:(UIFont *)font
{
    if ([NSString isEmpty:str]) {
        return nil;
    }

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];

    if (font && color)
    {
        [attributedStr addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} range:NSMakeRange(0, str.length)];
        
    } else
    {
    
        if (font)
        {
            [attributedStr addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, str.length)];
            
        }
        if (color)
        {
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, str.length)];
        }
    
    }
    return attributedStr;
}

/**
 * 组装NSMutableAttributedString2
 */
+ (NSMutableAttributedString *)getAttributedStringFromString:(NSString *)str1 Color:(UIColor *)color1 Fount:(UIFont *)font1 AndString:(NSString *)str2 Color:(UIColor *)color2 Fount:(UIFont *)font2
{
    if ([NSString isEmpty:str2] && [NSString isEmpty:str2]) {
        return nil;
    }
    
    if ([NSString isEmpty: str1]){
        str1 = @"";
    }
    
    if ([NSString isEmpty: str2]){
        str2 = @"";
    }

    
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    if (str1.length) {
        if (font1 && color1) {
            [attributedStr addAttributes:@{NSFontAttributeName:font1,NSForegroundColorAttributeName:color1} range:NSMakeRange(0, str1.length)];
            
        } else if (font1) {
            
            [attributedStr addAttributes:@{NSFontAttributeName:font1} range:NSMakeRange(0, str1.length)];
            
        } else if (color1) {
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:color1} range:NSMakeRange(0, str1.length)];
            
        } else {
            
        }
        
    }
    if (str2.length) {
        if (font2 && color2) {
            [attributedStr addAttributes:@{NSFontAttributeName:font2,NSForegroundColorAttributeName:color2} range:[str rangeOfString:str2]];
            
        } else if (font2) {
            
            [attributedStr addAttributes:@{NSFontAttributeName:font2} range:[str rangeOfString:str2]];
            
        } else if (color2) {
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:color2} range:[str rangeOfString:str2]];
            
        } else {
            
        }
        
    }
    return attributedStr;
}

/**
 * 组装图片NSMutableAttributedString
 */
+ (NSMutableAttributedString *)getAttributedStringFromString:(NSString *)str Color:(UIColor *)color Fount:(UIFont *)font AndImage:(NSString *)img Bounds:(CGRect)bounds
{
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //给附件添加图片
    textAttachment.image = [UIImage imageNamed:img];
    if (!CGRectEqualToRect(bounds, CGRectZero)) {
        textAttachment.bounds = bounds;

    }
    NSAttributedString *imageattr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString *textattr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSString getAttributedStringFromString:str Color:color Fount:font]];
    [textattr insertAttributedString:imageattr atIndex:0];
    
    return textattr;
}

/**
 * 组装attributesDictory
 */
+ (NSDictionary *)getAttributedStringDicWithTextColor:(UIColor *)textColor BackgroundColor:(UIColor *)bgColor Fount:(UIFont *)font LineSpace:(NSInteger)lineSpace
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:3];
    if (textColor) {
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    }
    if (bgColor) {
        [attributes setObject:bgColor forKey:NSBackgroundColorAttributeName];

    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];

    }
    if (lineSpace > 0) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0;
        //    paragraphStyle.alignment = NSTextAlignmentLeft;
        //    paragraphStyle.headIndent = 4.0;
        //    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }

    
    return attributes;
}

/**
 *  将带有表情符的文字转换为图文混排的文字
 *
 *  @param text      带表情符的文字
 *  @param plistName 表情符与表情对应的plist文件
 *  @param y         图片的y偏移值
 *
 *  @return 转换后的文字
 */
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text y:(CGFloat)y
{
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[em2_[0-9][0-9]\\]";; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        for (int i = 1; i <= 20; i ++) {
            NSString *str = [NSString stringWithFormat:@"[em2_%02d]",i];
            
            if ([str isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                NSString *pic = [NSString stringWithFormat:@"%02d",i];
                textAttachment.image = [UIImage imageNamed:pic];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, y, textAttachment.image.size.width, textAttachment.image.size.height);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
}

+ (NSMutableAttributedString *)exchangeString:(NSString *)string withText:(NSString *)text imageName:(NSString *)imageName
{
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    
    //2、匹配字符串
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:string options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
//        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //3、获取所有的图片以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //新建文字附件来存放我们的图片(iOS7才新加的对象)
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [UIImage imageNamed:imageName];
        //修改一下图片的位置,y为负值，表示向下移动
        textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        //把图片和图片对应的位置存入字典中
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [imageDic setObject:imageStr forKey:@"image"];
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        //把字典存入数组中
        [imageArray addObject:imageDic];
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    
    return attributeString;
}



/**
 * 计算AttributedString的大小
 * attributesDic: AttributedString设置
 * maxSize: 边界size 返回的size不会大于maxSize
 */
+ (CGSize)attributesStringSizeWith:(NSString *)str andAttributes:(NSDictionary *)attributesDic andConstrainedToSize:(CGSize)maxSize
{
    if ([NSString isEmpty:str]) {
        return CGSizeZero;
    }
    return [str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin   attributes:attributesDic context:Nil].size;

}

/**
 * 计算AttributedString的大小
 * attributesDic: AttributedString设置
 * maxSize: 边界size 返回的size不会大于maxSize
 */
- (CGSize)attributesStringSizeWithAttributes:(NSDictionary *)attributesDic andConstrainedToSize:(CGSize)maxSize
{
    return [NSString attributesStringSizeWith:self andAttributes:attributesDic andConstrainedToSize:maxSize];
}

+ (BOOL)isEmpty:(id)str {
    
    if ([str isEqual:[NSNull null]] || [str length] == 0) {
        
        return YES;
    }
    
    return NO;
}

@end
