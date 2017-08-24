//
//  CalendarView.h
//  ChinaClean
//
//  Created by    zhaoying on 17/3/16.
//  Copyright © 2017年 YL. All rights reserved.
//  日历控件封装,引用第三方日历

#import <UIKit/UIKit.h>
/**
 *日历选择控件
 */
@interface CalendarView : UIView

@property (nonatomic, copy) void (^calendarViewDidSelectedDayBlock)(NSDate *date);
@property (nonatomic,copy)  void(^customBlock)(NSDate *date);
@end

