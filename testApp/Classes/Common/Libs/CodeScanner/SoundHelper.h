//
//  SoundHelper.h
//  SmartDevice
//
//  Created by YanqiaoW on 16/12/14.
//  Copyright © 2016年 ewbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundHelper : NSObject

+ (void)clearSoundCache;
+ (void)playSoundFromURL:(NSURL *)soundFileURL asAlert:(BOOL)alert;
+ (void)playSoundFromFile:(NSString *)soundFileName fromBundle:(NSBundle *)bundle asAlert:(BOOL)alert;

@end
