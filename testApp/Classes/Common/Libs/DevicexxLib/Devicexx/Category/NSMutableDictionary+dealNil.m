//
//  NSMutableDictionary+dealNil.m
//  Devicexx
//
//  Created by YanqiaoW on 16/11/15.
//  Copyright © 2016年 device++. All rights reserved.
//

#import "NSMutableDictionary+dealNil.h"

@implementation NSMutableDictionary (dealNil)

- (void)setObjectDealNil:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject == nil) {
        NSLog(@"warning : %@ == nil",anObject);
        return;
    }
    [self setObject:anObject forKey:aKey];
}

@end
