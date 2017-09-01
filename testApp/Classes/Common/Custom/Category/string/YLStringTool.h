//
//  StringTool.h
//  ToolClassDemo
//
//  Created by    任亚丽 on 16/8/16.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 字符串处理工具（判空 转换等）
 */

@interface YLStringTool : NSObject
#pragma mark 判空 去空格
/**
 * 字符串判空 (空指针nil 空对象[NSNull null] 空内容[str length] == 0)
 */
+ (BOOL)isEmpty:(NSString*)str;

/**
 * 判断是否为非空字符串
 * return YES 表示不是空字符串
 * return NO  表示是空字符串
 */
+ (BOOL)notEmpty:(NSString*)str;

/**
 * 判断字符串是否全为空格或换行
 */
+ (BOOL)isEqualToSpaceString:(NSString*)str;


/**
 * 去除左右两边换行和空格
 */
+ (NSString *)removeBoundarySpace:(NSString *)str;


/**
 * 去除所有空格
 */
+(NSString *)removeAllSpace:(NSString *)str;

/**
 * 删除末尾空格 换行
 */
+ (NSString *)deleteFooterSpaces:(NSString *)str;

/**
 * 删除开头空格 换行
 */
+ (NSString *)deleteHeaderSpaces:(NSString *)str;


#pragma json转化
/**
 * 数组或字典转json字符串
 */
+ (NSString *)toJsonStrFromid:(id)data;

/**
 * json字符串转化数组或字典
 */
+ (id)jsonValue:(NSString *)jsonstr;



#pragma mark URL编码
/**
 * URL编码 （汉字..）
 */
+ (NSString *)URLEncodedString:(NSString *)str;

/**
 * URL反编码
 */
+ (NSString*)URLDecodedString:(NSString *)str;

+ (NSString *) generateUUID;

//判断是否包含表情符
+ (BOOL)stringContainsEmoji:(NSString *)string;

#pragma mark 通过字典生成签名字符串
+ (NSString *)genSign:(NSDictionary *)signParams;

#pragma mark MD5加密
+ (NSString *)MD5OfString:(NSString *)str;
+ (NSString *)MD5OfData:(NSData *)data;

@end
