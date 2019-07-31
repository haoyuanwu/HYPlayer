//
//  NSDate+HYDate.h
//  HYDate + stretch
//
//  Created by wuhaoyuan on 16/4/21.
//  Copyright © 2016年 HYDate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HYDate)

/**
 *  字符串转时间 StringWithDate
 */
+ (NSDate *)stringWithDate:(NSString *)string Formatter:(NSString *)formatter;

/**
 *  第二天日期 TodayTime
 */
+ (NSDate *)toDayDate;

/**
 *  前后某天的日期 SomedayTime
 *
 *  @param index 当天的第几天  dayNnumber（负数是前一天，正数是未来几天）
 *
 *  @return
 */
+ (NSDate *)dayDateformIndex:(NSInteger)index;

/**
 *  时间转字符串 dateWithString
 */
- (NSString *)string;

/**
 *  时间转字符串
 *
 *  @param formatterStr 类型 dateType
 *
 *  @return 
 */
- (NSString *)stringWithFormatter:(NSString *)formatterStr;

/**
 *  年
 */
- (NSString *)yearString;
/**
 *  月
 */
- (NSString *)monthString;
/**
 *  日
 */
- (NSString *)dayString;

/**
 计算时间点之前的天数时间
 
 @param day  天数
 @param date 时间点
 
 @return
 */
+ (NSTimeInterval)ComputationTimeDay:(id)day date:(NSDate *)date;

/**
 根据用户输入的时间(dateString)确定当天是星期几,

 @param dateString 输入的时间格式 yyyy-MM-dd ,如 2015-12-18
 @return 中/英  星期一/Monday
 */
+ (NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString;

@end
