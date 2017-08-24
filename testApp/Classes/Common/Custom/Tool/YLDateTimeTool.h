//
//  YLDateTool.h
//  ToolClassDemo
//
//  Created by    任亚丽 on 16/8/12.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 日期时间工具 均为类方法
 */
@interface YLDateTimeTool : NSObject
#pragma mark NSDate——>格式字符串
/**
 * NSDate转换为标准格式日期+时间字符串 return（2014-04-16 15:30:16）
 */
+ (NSString *)normalDateTimeStringWithDate:(NSDate *)date;

/**
 * NSDate转换为自定义格式日期+时间字符串
 *style:时间格式字符串（MM:dd HH:mm）
 */

+ (NSString *)dateStringWithDate:(NSDate *)date andStyleStr:(NSString *)styleStr;

/**
 * 时间戳（以秒为单位）转换为自定义格式字符串
 * timeIntervalSce:时间戳
 *style:日期格式字符串
 */
+ (NSString *)dateStringWithTimeIntervalSince1970:(NSTimeInterval)timeIntervalSce andStyleStr:(NSString *)styleStr;

/**
 * NSDate转换为日期字符串
 * style:日期格式枚举值 (NSDateFormatterShortStyle)
 */

+ (NSString *)dateStringWithDate:(NSDate *)date andDateFormatterStyle:(NSDateFormatterStyle)style;

/**
 * datestring转换为日期字符串
 * style:日期格式 默认为yyyy-MM-dd
 返回12:25 今天  12.26明天  12:29 周四
 */
+ (NSString *)todayDateStringWithDateString:(NSString *)dateStr andFormatterStyle:(NSString *)dateStyle;

#pragma mark NSString ——>NSDate
/**
 * 自定义格式日期+时间字符串转换为NSDate
 * style:日期+时间格式字符串（yy-MM-dd HH:mm）
 */
+(NSDate *)dateWithDateString:(NSString *)dateStr andDateFormatterStyle:(NSString *)dateStyle;

#pragma mark NSString ——>NSString
/**
 * 自定义格式日期+时间字符串转换
 */
+(NSString *)dateStringWithDateString:(NSString *)dateStr fromFormatterStyle:(NSString *)sourceStyle toFormatterStyle:(NSString *)targetStyle;


#pragma mark 获取当前时间
/**
 * 获取yyyy-MM-dd格式当前日期
 */
+ (NSString *)currentNormalDateTimeString;

/**
 * 获取yyyy-MM-dd格式当前日期
 */
+ (NSString *)currentNormalDateString;

/**
 * 获取HH:mm:ss格式当前时间
 */
+ (NSString *)currentNormalTimeString;

/**
 * 获取自定义格式当前日期
 */
+ (NSString *)currentFormatDateString:(NSString *)styleStr;

/**
 * 获取当前时间戳 秒为单位
 */
+ (NSTimeInterval)currentDatetimeIntervalSince1970;


#pragma mark 判断日期
/**
 * 判断所选日期是否大于指定日期
 * selectedDate:所选日期
 * appointDate: 指定日期
 */
+(BOOL)judgeSelectedDate:(NSDate *)selectedDate ISMoreThanAppointDate:(NSDate *)appointDate;

/**
 * 判断所选日期是否几天后的日期
 * selectedDate:所选日期
 * day: 指定天数
 */
+(BOOL)judgeSelectedDate:(NSDate *)selectedDate ISLaterToday:(NSInteger)day;

/**
 * 获取几天后的日期字符串
 * day: 指定天数
 * style:返回日期的格式
 */
//
+ (NSString *)getDateStrlaterTaday:(NSInteger)day andDateStyle:(NSString *)style;

/**
 * 判断所选日期是否是周末
 * style:日期+时间格式字符串（yy-MM-dd HH:mm）
 */
+(BOOL)judgeSelectedDateISWeekend:(NSDate *)selectedDate;

/**
 * 判断所选日期是本年第几周
 */
+(NSInteger)judgeSelectedDateISWeek:(NSDate *)selectedDate;

#pragma mark 计算时间间隔
/**
 * 计算间隔时间戳 结束时间与开始时间的时间差
 * startString：开始时间
 * endString： 结束时间
 * startstyle：开始时间指定时间格式
 */
+ (NSTimeInterval )getContinuedTimeIntervalstartDateString:(NSString *)startString ToEndDateSting:(NSString *)endString WithstartDateStyle:(NSString *)startStyle EndDateStyle:(NSString *)endStyle;

/**
 * 计算时间间隔（30以内返回几天前 或 几小时前 几分钟前）
 * theDateStr：传入时间字符串
 * date： 传入日期
 * theInterval： 时间戳
 
 */
+ (NSString *)getContinuedTimeSinceNow:(NSString *)theDateStr orDate:(NSDate *)date orTimeInterval:(NSTimeInterval )theInterval;

/**
 * 以00:00:00显示seconds的持续时间
 * seconds：持续秒数
 */
+ (NSString *)getContinuedTimeWithSecons:(NSTimeInterval)seconds;

/**
 * 以00:00:00显示指定时间戳与当前时间的时间差
 * appointSec：指定时间戳(以秒为单位)
 */
+ (NSString *)getContinuedTimeWithAppointTimeIntervalTocurrentTimeInterval:(NSTimeInterval)appointSec;

/**
 * 以00:00:00显示指定时间与当前时间的时间差
 * dateString：指定时间
 * style：指定时间格式
 */
+ (NSString *)getContinuedTimeStringWithAppointDateString:(NSString *)dateString TocurrentTimeandDateStyle:(NSString *)style;

/**
 * 显示指定时间与当前时间的时间差
 * dateString：指定时间
 * style：指定时间格式
 */
+ (NSTimeInterval )getContinuedTimeIntervalWithAppointDateString:(NSString *)dateString TocurrentTimeandDateStyle:(NSString *)style;


/**
 * 以00:00:00显示当前时间与指定时间戳的时间差
 * appointSec：指定时间戳(以秒为单位)
 */
+ (NSString *)getContinuedTimeWithCurrentTimeIntervalToAppointTimeInterval:(NSTimeInterval)appointSec;


//时间戳转化为年月日字符串  //以毫秒为整数值的时间戳转换
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;

@end
