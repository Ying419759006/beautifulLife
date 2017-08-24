//
//  YLDateTool.m
//  ToolClassDemo
//
//  Created by    任亚丽 on 16/8/12.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLDateTimeTool.h"

@implementation YLDateTimeTool
#pragma mark NSDate ——>NSString
/**
 * NSDate转换为标准格式日期+时间字符串 return（2014-04-16 15:30:16）
 */
+ (NSString *)normalDateTimeStringWithDate:(NSDate *)date
{
    return [YLDateTimeTool dateStringWithDate:date andStyleStr:@"yyyy-MM-dd HH:mm:ss"];

}

/**
 * NSDate转换为自定义格式日期+时间字符串
 *style:时间格式字符串（MM:dd HH:mm）
 年yyyy 月MM 日dd 时HH(如时间只想显示一位数 写一个小写h) 分mm 秒ss 星期几EEEE 周几EEE aa上午/下午  如 M月dd日 aah:mm（8月15日 下午4:54）
 */
+ (NSString *)dateStringWithDate:(NSDate *)date andStyleStr:(NSString *)styleStr
{
    if ([date isEqual:[NSNull null]] || !date) {
        return nil;
    }
    
    if ([styleStr isEqual:[NSNull null]] || ![styleStr length]) {
        styleStr = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:styleStr];
    return [formatter stringFromDate:date];
}

/**
 * 时间戳（以秒为单位）转换为自定义格式字符串
 * timeIntervalSce:时间戳
 *style:日期格式字符串
 */
+ (NSString *)dateStringWithTimeIntervalSince1970:(NSTimeInterval)timeIntervalSce andStyleStr:(NSString *)styleStr
{
    return [YLDateTimeTool dateStringWithDate:[NSDate dateWithTimeIntervalSince1970: timeIntervalSce] andStyleStr:styleStr];
    
}

/**
 * NSDate转换为日期字符串
 * style:日期格式枚举值 (NSDateFormatterShortStyle)
 NSDateFormatterNoStyle:
 NSDateFormatterShortStyle:14-4-16
 NSDateFormatterMediumStyle:2014年4月16日
 NSDateFormatterLongStyle:2014年4月16日
 NSDateFormatterFullStyle:2014年4月16日 星期三
 */
+ (NSString *)dateStringWithDate:(NSDate *)date andDateFormatterStyle:(NSDateFormatterStyle)style
{
    
    if (!date || [date isEqual:[NSNull null]]) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    
    return [formatter stringFromDate:date];
}

/**
 * datestring转换为日期字符串
 * style:日期格式 默认为yyyy-MM-dd
   返回12:25 今天  12.26明天  12:29 周四
 */
+ (NSString *)todayDateStringWithDateString:(NSString *)dateStr andFormatterStyle:(NSString *)dateStyle
{
    
    if (!dateStr || [dateStr isEqual:[NSNull null]]) {
        return nil;
    }
    
    if ([dateStyle isEqual:[NSNull null]] || ![dateStyle length]) {
        dateStyle = @"yyyy-MM-dd";
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateStyle];
    
    NSString *today = [formatter stringFromDate:[NSDate date]];
    NSTimeInterval todayS = [[formatter dateFromString:today] timeIntervalSince1970];
    NSString *tomorrow = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:todayS + 24 * 60 * 60]];
//    NSString *yesterday = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:todayS - 24 * 60 * 60]];
//    NSString *aftertomorrow = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:todayS + 2 * 24 * 60 * 60]];
    
    NSDate *theDate = [formatter dateFromString:dateStr];

    if ([dateStr isEqualToString:today]) {
        [formatter setDateFormat:@"MM月dd日"];
        return [NSString stringWithFormat:@"%@ 今天",[formatter stringFromDate:theDate]];

    } else if ([dateStr isEqualToString:tomorrow]) {
        [formatter setDateFormat:@"MM月dd日"];
        return [NSString stringWithFormat:@"%@ 明天",[formatter stringFromDate:theDate]];

    
    } else {
        [formatter setDateFormat:@"MM月dd日 EEE"];
        return [formatter stringFromDate:theDate];

    }
    
}
#pragma mark NSString ——>NSDate
/**
 * 自定义格式日期+时间字符串转换为NSDate
 * style:日期+时间格式字符串（yy-MM-dd HH:mm）
 */
+(NSDate *)dateWithDateString:(NSString *)dateStr andDateFormatterStyle:(NSString *)dateStyle
{
    if (!dateStr || [dateStr isEqual:[NSNull null]]) {
        return nil;
    }
    
    if ([dateStyle isEqual:[NSNull null]] || ![dateStyle length]) {
        dateStyle = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:dateStyle];
    
    return [formatter dateFromString:dateStr];
    
    
}

#pragma mark NSString ——>NSString
/**
 * 自定义格式日期+时间字符串转换
 */
+(NSString *)dateStringWithDateString:(NSString *)dateStr fromFormatterStyle:(NSString *)sourceStyle toFormatterStyle:(NSString *)targetStyle
{
    if ([dateStr isEqual:[NSNull null] ] || ![dateStr length]) {
        return nil;
    }
    
    if ([sourceStyle isEqual:[NSNull null] ] || ![sourceStyle length]) {
        sourceStyle = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:sourceStyle];
    
    NSDate *date = [formatter dateFromString:dateStr];
    
    if ([targetStyle isEqual:[NSNull null] ] || ![targetStyle length]) {
        targetStyle = @"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:targetStyle];
    
    return [formatter stringFromDate:date];
    
}


#pragma mark 获取当前时间
/**
 * 获取yyyy-MM-dd HH:mm:ss格式当前日期时间
 */
+ (NSString *)currentNormalDateTimeString
{
    return  [YLDateTimeTool dateStringWithDate:[NSDate date] andStyleStr:@"yyyy-MM-dd HH:mm:ss"];
}

/**
 * 获取yyyy-MM-dd格式当前日期
 */
+ (NSString *)currentNormalDateString
{
    return [YLDateTimeTool dateStringWithDate:[NSDate date] andStyleStr:@"yyyy-MM-dd"];
}

/**
 * 获取HH:mm:ss格式当前时间
 */
+ (NSString *)currentNormalTimeString
{
    return [YLDateTimeTool dateStringWithDate:[NSDate date] andStyleStr:@"HH:mm:ss"];
}


/**
 * 获取自定义格式当前日期
 */
+ (NSString *)currentFormatDateString:(NSString *)styleStr
{
    if ([styleStr isEqual:[NSNull null]] || ![styleStr length]) {
        styleStr = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return [YLDateTimeTool dateStringWithDate:[NSDate date] andStyleStr:styleStr];

}


/**
 * 获取当前时间戳 秒为单位
 */
+ (NSTimeInterval)currentDatetimeIntervalSince1970
{
   return [[NSDate date] timeIntervalSince1970];
}



#pragma mark 判断日期
/**
 * 判断所选日期是否大于指定日期
 * selectedDate:所选日期
 * appointDate: 指定日期
 */
+(BOOL)judgeSelectedDate:(NSDate *)selectedDate ISMoreThanAppointDate:(NSDate *)appointDate
{
    
    //    NSLog(@"%d",[selectedDate compare:appointDate]);
    if ([selectedDate compare:appointDate] == -1) {
        return NO;
    }
    
    return YES;
}

/**
 * 判断所选日期是否几天后的日期
 * selectedDate:所选日期
 * day: 指定天数
 */
+(BOOL)judgeSelectedDate:(NSDate *)selectedDate ISLaterToday:(NSInteger)day
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval theInterval = [[formatter dateFromString:[formatter stringFromDate:selectedDate]] timeIntervalSince1970];
    NSTimeInterval nowInterval = [[formatter dateFromString:[formatter stringFromDate:[NSDate date]]] timeIntervalSince1970];
    if (theInterval - nowInterval >= 86400*day) {
        
        return YES;
    }
    
    return NO;
    
}

/**
 * 获取几天后的日期字符串
 * day: 指定天数
 * style:返回日期的格式
 */
//
+ (NSString *)getDateStrlaterTaday:(NSInteger)day andDateStyle:(NSString *)style
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval nowInterval = [[formatter dateFromString:[formatter stringFromDate:[NSDate date]]] timeIntervalSince1970];
    
    NSTimeInterval theInterval =  nowInterval + 86400 * day;
    
    if ([style isEqual:[NSNull null]] || ![style length]) {
        style = @"yyyy-MM-dd";
    }
    [formatter setDateFormat:style];
    
    return [formatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:theInterval]];
}

/**
 * 判断所选日期是否是周末
 * selectedDate:日期
 */
+(BOOL)judgeSelectedDateISWeekend:(NSDate *)selectedDate
{
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components: NSCalendarUnitWeekday fromDate:selectedDate] weekday];
    
    NSLog(@"week : %zd",week);
    if (week == 7 || week == 1) {
        return YES;
    }
    return NO;
}



/**
 * 判断所选日期是本年第几周
 */
+(NSInteger)judgeSelectedDateISWeek:(NSDate *)selectedDate
{
    
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
//    NSDateComponents *dateComponents = [myCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:selectedDate];
    
    NSDateComponents *dateComponents = [myCalendar components:NSCalendarUnitEra| NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:selectedDate];
    
    // iOS中规定的是周日为1，周一为2，周二为3，周三为4，周四为5，周五为6，周六为7
    NSLog(@"year(时代): %ld", [dateComponents era]);
    NSLog(@"year(年份): %ld", [dateComponents year]);
    NSLog(@"quarter(季度):%ld", [dateComponents quarter]);
    NSLog(@"month(月份):%ld", dateComponents.month);
    NSLog(@"day(日期):%ld", dateComponents.day);
    NSLog(@"hour(小时):%ld", dateComponents.hour);
    NSLog(@"minute(分钟):%ld", dateComponents.minute);
    NSLog(@"second(秒):%ld", dateComponents.second);
    NSLog(@"weekday(周几):%ld", dateComponents.weekday);
    
        //  Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Friday:5,Thursday:6  Saturday:7
        switch (dateComponents.weekday) {
            case 1:
                NSLog(@"weekday(星期日)");
    
                break;
            case 2:
                NSLog(@"weekday(星期一)");
                break;
            case 3:
                NSLog(@"weekday(星期二)");
                break;
            case 4:
                NSLog(@"weekday(星期三)");
                break;
            case 5:
                NSLog(@"weekday(星期四)");
                break;
            case 6:
                NSLog(@"weekday(星期五)");
                break;
            case 7:
                NSLog(@"weekday(星期六)");
                break;
    
            default:
                break;
        }
    
        //  苹果官方不推荐使用week
//        NSLog(@"week(该年第几周):%li", dateComponents.week);//iOS8之后丢弃
    return dateComponents.weekOfYear;
}


#pragma mark 计算时间间隔
/**
 * 显示指定时间与当前时间的时间差
 * dateString：指定时间
 * style：指定时间格式
 */
+ (NSTimeInterval )getContinuedTimeIntervalWithAppointDateString:(NSString *)dateString TocurrentTimeandDateStyle:(NSString *)style
{
    if (!dateString) {
        return -10000000;
    }
    if (!style) {
        style = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:style];
    NSString *nowDateString = [formatter stringFromDate:[NSDate date]];
    NSTimeInterval theInterval = [[formatter dateFromString:dateString] timeIntervalSince1970];
    NSTimeInterval nowInterval = [[formatter dateFromString:nowDateString] timeIntervalSince1970];
    
    return theInterval - nowInterval;
}

/**
 * 计算间隔时间戳 结束时间与开始时间的时间差
 * startString：开始时间
 * endString： 结束时间
 * startstyle：开始时间指定时间格式
 */
+ (NSTimeInterval )getContinuedTimeIntervalstartDateString:(NSString *)startString ToEndDateSting:(NSString *)endString WithstartDateStyle:(NSString *)startStyle EndDateStyle:(NSString *)endStyle
{
    if (![startString length] || !endString) {
        return -10000000;
    }

    if (!startStyle) {
        startStyle = @"yyyy-MM-dd HH:mm:ss";
    }
    
    if (!endStyle) {
        endStyle = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:startStyle];
    NSTimeInterval startInterval = [[formatter dateFromString:startString] timeIntervalSince1970];
    [formatter setDateFormat:endStyle];
    NSTimeInterval endInterval = [[formatter dateFromString:endStyle] timeIntervalSince1970];
    
    return endInterval - startInterval;
}


/**
 * 计算时间间隔（30以内返回几天前 或 几小时前 几分钟前）
 * theDateStr：传入时间字符串
 * date： 传入日期
 * theInterval： 时间戳 秒为单位

 */
+ (NSString *)getContinuedTimeSinceNow:(NSString *)theDateStr orDate:(NSDate *)date orTimeInterval:(NSTimeInterval )theInterval
{
    if ([self stringisEmpty:theDateStr] && [self dateisEmpty:date] && theInterval < 0) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (theDateStr) {
        date = [formatter dateFromString:theDateStr];
        theInterval = [date timeIntervalSince1970];
    } else {
        if (theInterval >= 0) {
            date = [NSDate dateWithTimeIntervalSinceNow:theInterval];
            theDateStr = [self dateStringWithTimeIntervalSince1970:theInterval andStyleStr:nil];
        } else {
            
            if (date) {
                theDateStr = [formatter stringFromDate:date];
                theInterval = [date timeIntervalSince1970];
                
            }
        }
    }
    
    
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = theDateStr;
    NSTimeInterval interval = nowInterval - theInterval;
    if (interval/3600 < 1) {
        timeString = [NSString stringWithFormat:@"%.0f分钟前", interval/60];
        if (interval/60 < 1) {
            timeString = @"刚刚";
        }
        
    }
    if (interval/3600 >= 1 && interval/86400 < 1) {
        timeString = [NSString stringWithFormat:@"%.0f小时前", interval/3600];
    }
    if (interval/86400 >= 1 && interval/86400 <= 30) {
        timeString = [NSString stringWithFormat:@"%.0f天前", interval/86400];
    }
//    if (interval/3600 < 1) {
//        timeString = [NSString stringWithFormat:@"%.0f分钟前", interval/60];
//        if (interval/60 < 1) {
//            timeString = @"刚刚";
//        }
//        
//    }
//    if (interval/3600 >= 1 && interval/86400 < 1) {
//        timeString = [NSString stringWithFormat:@"%.0f小时前", interval/3600];
//    }
//    if (interval/86400 >= 1 && interval/86400 <= 30) {
//        timeString = [NSString stringWithFormat:@"%.0f天前", interval/86400];
//    }
    
    return timeString;
}

/**
 * 以00:00:00显示seconds的持续时间
 * seconds：持续秒数
 */
+ (NSString *)getContinuedTimeWithSecons:(NSTimeInterval)seconds
{
    if (seconds <= 0) {
        return @"00:00:00";
    }
    if (seconds / 3600 > 24) {
        return [NSString stringWithFormat:@"%ld 天",(long)seconds / 86400];
    } else {
    
        return [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",(long)seconds / 3600,((long)seconds % 3600) / 60,((long)seconds % 3600) % 60];
    
    }

}

/**
 * 以00:00:00显示指定时间戳与当前时间的时间差
 * appointSec：指定时间戳(以秒为单位)
 */
+ (NSString *)getContinuedTimeWithAppointTimeIntervalTocurrentTimeInterval:(NSTimeInterval)appointSec
{
    
    return [YLDateTimeTool getContinuedTimeWithSecons:appointSec - [YLDateTimeTool currentDatetimeIntervalSince1970]];
}

/**
 * 以00:00:00显示指定时间与当前时间的时间差
 * dateString：指定时间
 * style：指定时间格式
 */
+ (NSString *)getContinuedTimeStringWithAppointDateString:(NSString *)dateString TocurrentTimeandDateStyle:(NSString *)style
{
    if (!dateString) {
        return nil;
    }
    if (!style) {
        style = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:style];
    NSString *nowDateString = [formatter stringFromDate:[NSDate date]];
    NSTimeInterval theInterval = [[formatter dateFromString:dateString] timeIntervalSince1970];
    NSTimeInterval nowInterval = [[formatter dateFromString:nowDateString] timeIntervalSince1970];
    NSLog(@"%f",theInterval - nowInterval);

    return [YLDateTimeTool getContinuedTimeWithSecons:theInterval - nowInterval];
}

/**
 * 以00:00:00显示当前时间与指定时间戳的时间差
 * appointSec：指定时间戳(以秒为单位)
 */
+ (NSString *)getContinuedTimeWithCurrentTimeIntervalToAppointTimeInterval:(NSTimeInterval)appointSec
{
    
    return [YLDateTimeTool getContinuedTimeWithSecons:[YLDateTimeTool currentDatetimeIntervalSince1970] - appointSec];
}

+ (BOOL)stringisEmpty:(NSString*)str
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

+ (BOOL)dateisEmpty:(NSDate *)date
{
    if ([date isEqual:[NSNull null]] || !date) {
        
        return YES;
    
    }
    
    return NO;
}

//以毫秒为整数值的时间戳转换
//时间戳转化为时间NSDate
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
