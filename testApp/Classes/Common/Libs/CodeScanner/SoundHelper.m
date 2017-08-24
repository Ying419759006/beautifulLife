//
//  SoundHelper.m
//  SmartDevice
//
//  Created by YanqiaoW on 16/12/14.
//  Copyright © 2016年 ewbao. All rights reserved.
//

#import "SoundHelper.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SoundHelper

static NSMutableDictionary *soundDictionary = nil;

//static void finishedPlaying(SystemSoundID soundId, void* clientData) {
//    AudioServicesDisposeSystemSoundID(soundId);
//}

+ (void)initialize {
    if (soundDictionary == nil) {
        soundDictionary = [NSMutableDictionary new];
    }
}

+ (void)clearSoundCache {
    for (NSNumber *n in soundDictionary.allValues) {
        AudioServicesDisposeSystemSoundID((UInt32)[n unsignedIntegerValue]);
    }
    [soundDictionary removeAllObjects];
}

+ (void)playSoundFromURL:(NSURL *)soundFileURL asAlert:(BOOL)alert {
    SystemSoundID soundId;
    
    id key = [soundFileURL absoluteString];
    NSNumber *n = [soundDictionary objectForKey:key];
    
    if (n == nil && key) {
        if (soundFileURL && AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundFileURL, &soundId) == noErr) {
            n = [NSNumber numberWithUnsignedInteger:soundId];
            [soundDictionary setObject:n forKey:key];
        }
    }
    
    soundId = (UInt32)[n unsignedIntegerValue];
    
    if (soundId) {
        if (alert) {
            AudioServicesPlayAlertSound(soundId);
        } else {
            AudioServicesPlaySystemSound(soundId);
        }
    }
}

+ (void)playSoundFromFile:(NSString *)soundFileName fromBundle:(NSBundle *)bundle asAlert:(BOOL)alert {
    NSString *extension = [soundFileName pathExtension];
    NSString *basename = [soundFileName stringByDeletingPathExtension];
    
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    NSURL *alertSound = soundFileName ? [bundle URLForResource: basename
                                                 withExtension: extension] : nil;
    
    [self playSoundFromURL:alertSound asAlert:alert];
}

@end
