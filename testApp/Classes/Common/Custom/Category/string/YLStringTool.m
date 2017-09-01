//
//  StringTool.m
//  ToolClassDemo
//
//  Created by    任亚丽 on 16/8/16.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLStringTool.h"
#import <CommonCrypto/CommonDigest.h>


@implementation YLStringTool
#pragma mark 判空 去空格

/**
 * 字符串判空 (空对象[NSNull null]  空指针nil  空内容[str length] == 0)
 nil：指向oc中对象的空指针(自己理解指针指向的对象不存在)
 Nil：指向oc中类的空指针
 NULL：0地址（空地址）  指向其他类型的空指针，如一个c类型的内存指针
 NSNull：在集合对象中，表示空值的对象
 */
+ (BOOL)isEmpty:(NSString*)str
{
    if ((NSNull *)str == [NSNull null]) {
        return YES;
    }
    
    if (!str) {
        return YES;
    }
    str = [NSString stringWithFormat:@"%@",str];
    return [str length] <= 0;
}

/**
 * 判断是否为非空字符串
 * return YES 表示不是空字符串
 * return NO  表示是空字符串
 */
+ (BOOL)notEmpty:(NSString*)str
{
    return ![self isEmpty:str];
}

/**
 * 判断字符串是否全为空格或换行
 */
+ (BOOL)isEqualToSpaceString:(NSString*)str
{
    if ([self isEmpty:str]) {
        return YES;
    } else {
        
        BOOL isSpace = YES;
        for (int i = 0; i < [str length]; i ++) {
            if (![[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:@" "] && ![[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"\n"]) {
                isSpace = NO;
            }
        }
        return isSpace;
    }
}


/**
 * 去除左右两边换行和空格
 controlCharacterSet  去除最后的换行
 newlineCharacterSet  去除左右换行
 whitespaceCharacterSet  去除左右的空格
 whitespaceAndNewlineCharacterSet  去除左右的空格和换行
 */
+ (NSString *)removeBoundarySpace:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return str;
}

/**
 * 去除所有空格
 */
+(NSString *)removeAllSpace:(NSString *)str
{
    str = [self removeBoundarySpace:str];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];//用空字符串替换空格
    return str;
}

/**
 * 删除末尾空格 换行
 */
+ (NSString *)deleteFooterSpaces:(NSString *)str
{
    NSInteger length = [str length];
    while (length) {
        NSString *s = [str substringWithRange:NSMakeRange(length - 1, 1)];
        if ([s isEqualToString:@" "]||[s isEqualToString:@"\n"]) {
            length--;
        } else {
            break;
        }
        
    }
    return [str substringToIndex:length];
}


/**
 * 删除开头空格 换行
 */
+ (NSString *)deleteHeaderSpaces:(NSString *)str
{
    while (str.length) {
        NSString *s = [str substringWithRange:NSMakeRange(0, 1)];
        if ([s isEqualToString:@" "]||[s isEqualToString:@"\n"]) {
            if (str.length > 1) {
                str = [str substringFromIndex:1];

            } else {
                str = @"";
                break;
            }
        } else {
            break;
        }
        
    }
    return str;

    
}

/**
 * 净化网络字符串
 */
+ (NSString *)purifyStr:(NSString *)str
{
    if ([self isEmpty:str]) {
        return @"";
    }
    str = [str stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&rdquo；" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&quot；" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&ldquo；" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;&nbsp;&nbsp;" withString:@"     "];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp；&nbsp；&nbsp；" withString:@"     "];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"     "];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp；" withString:@"     "];
    str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    
    str = [str stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"-"];
    
    str = [str stringByReplacingOccurrencesOfString:@"&lt;p&gt;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;/p&gt;" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;B&gt;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;/B&gt;" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"&lt;br /&gt;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;br/&gt;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;br&gt;" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"好大夫" withString:@"名医汇"];
    str = [str stringByReplacingOccurrencesOfString:@"haodf.com" withString:@"mingyihui.com"];
    
    
    return str;
}


//净化url字符串
+ (NSString *)purifyURLStr:(NSString *)str
{
 
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
}


#pragma json转化
/**
 * 数组或字典转json字符串
 */
+ (NSString *)toJsonStrFromid:(id)data
{
    NSData *jsonData = [YLStringTool toJSONData:data];
    if (nil == jsonData) {
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    }
}

// 将字典或者数组转化为JSONData
+ (NSData *)toJSONData:(id)theData{
    
    if (theData == nil || [theData isEqual:[NSNull null]]) {
        return nil;
    }

//    if (theData == nil || [theData count] == 0 || [theData isEqual:[NSNull null]]) {
//        return nil;
//    }

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length]!=0 && error == nil){
        return jsonData;
    }else{
        NSLog(@"%@",[error description]);
        return nil;
    }
}

/**
 * json字符串转化数组或字典
 */
+ (id)jsonValue:(NSString *)jsonstr
{
    if ([self isEmpty:jsonstr]) {
        NSLog(@"空字符");
        return nil;
        
    }
    jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"&quot" withString:@"\n"];
    NSError *err;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonstr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
    if (err) {
        NSLog(@"解析错误");
        return nil;
    } else {
        return jsonObject;
    }
    
}


#pragma mark URL编码
/**
 * URL编码 （汉字..）
 */
+ (NSString *)URLEncodedString:(NSString *)str
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4) {
        
      return  [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@" "].invertedSet];
        
    } else { //iOS9之前
        
        //        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(" "),kCFStringEncodingUTF8));
        
        return result;
        
    }

}

/**
 * URL反编码
 */
+ (NSString*)URLDecodedString:(NSString *)str
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4) {
        
        return [str stringByRemovingPercentEncoding];
        
        return  (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, (CFStringRef)@""))
        ;

    } else { //iOS9之前
        
        //    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)str, CFSTR(""), kCFStringEncodingUTF8));
        
        return result;

    }
   
    
}

+ (NSString *) generateUUID
{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    CFRelease(uuidObject);
    
    //生成去除“-”的UUID
    NSString *UUIDStr = [uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return UUIDStr;
}

//判断是否包含表情符
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                NSLog(@"%c",hs);
                                
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}



#pragma mark 通过字典生成签名字符串
+ (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    return sign;
}

#pragma mark MD5加密
+ (NSString *)MD5OfString:(NSString *)str{
    const char *cStr = str.UTF8String;
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
+ (NSString *)MD5OfData:(NSData *)data{
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    CC_MD5_Update(&md5, [data bytes], (CC_LONG)[data length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}
@end
