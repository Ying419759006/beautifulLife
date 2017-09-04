//
//  ZYLogModelFromDic.h
//  testApp
//
//  Created by YanqiaoW on 17/9/1.
//  Copyright © 2017年 ewbao. All rights reserved.
//  字典可以自动打印出模型的属性, 免得手写出错与耗时

#import <Foundation/Foundation.h>

@interface ZYLogModelFromDic : NSObject

// 自动打印属性字符串
+ (void)resolveDict:(NSDictionary *)dict;

@end
