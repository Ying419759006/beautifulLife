//
//  CalendarView.m
//  ChinaClean
//
//  Created by    zhaoying on 17/3/16.
//  Copyright © 2017年 YL. All rights reserved.
//

#import "CalendarView.h"
#import "FDCalendar.h"
@implementation CalendarView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
        __weak typeof(self) safeSelf = self;
        calendar.calendarViewDidSelectedDayBlock = ^(NSDate *selectedDate){
        
            if (safeSelf.calendarViewDidSelectedDayBlock) {
                safeSelf.calendarViewDidSelectedDayBlock(selectedDate); 
            }
            
        };
        CGRect frame = calendar.frame;
        frame.origin.y = (self.height - calendar.height) / 2;
        calendar.frame = frame;
        [self addSubview:calendar];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    }
    
    return self;
}

@end
