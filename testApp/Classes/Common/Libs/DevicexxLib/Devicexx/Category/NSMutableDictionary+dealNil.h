//
//  NSMutableDictionary+dealNil.h
//  Devicexx
//
//  Created by YanqiaoW on 16/11/15.
//  Copyright © 2016年 device++. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (dealNil)

- (void)setObjectDealNil:(id)anObject forKey:(id<NSCopying>)aKey;

@end
