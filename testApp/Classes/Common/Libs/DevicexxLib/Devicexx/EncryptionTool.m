//
//  EncryptionTool.m
//  Devicexx
//
//  Created by yager on 16/8/18.
//  Copyright © 2016年 device++. All rights reserved.
//

#import "EncryptionTool.h"

#import "CommConfig.h"

#import <CommonCrypto/CommonDigest.h>

@implementation EncryptionTool

+ ( NSData *)dataWithDictionary:(NSDictionary *)dict
{
    NSMutableData *data = [[ NSMutableData alloc ] init ];
    NSKeyedArchiver *archiver = [[ NSKeyedArchiver alloc ] initForWritingWithMutableData:data];
    
    [archiver encodeObject:dict forKey:@"dict" ];
    [archiver finishEncoding ];

    return data;
}

+ (NSString *)md5String:(NSString *)inputStr
{
    const char *cStr = [inputStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//根据参数生产签名
// content = (access_key(value) + password(value) + ts(ts) + username(value))
// signature = md5（content + access_secret)
+ (NSString *)generateSignature:(NSDictionary *)params
{
    if (params == nil) {
        return nil;
    }
    NSArray *keys = [[params allKeys] sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        return (NSComparisonResult)[obj1 compare:obj2 options:NSLiteralSearch];
    }];
    
    NSMutableString *conentString = [[NSMutableString alloc] initWithCapacity:0];
    for (NSString *key in keys) {
        [conentString appendString:key];
        [conentString appendString:[params valueForKey:key]];
        NSLog(@"key = %@, value = %@", key, [params valueForKey:key]);
    }
    NSLog(@"conentString == %@", conentString);
    
    NSString *beforeSignature = [NSString stringWithFormat:@"%@%@", conentString, ACCESS_SECRET];
    NSString *signature = [EncryptionTool md5String:beforeSignature];
    return signature;
}

@end
