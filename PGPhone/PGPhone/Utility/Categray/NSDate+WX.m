//
//  NSDate+WX.m
//  openSource
//
//  Created by openSource on 2023/3/14.
//  Copyright © 2023 openSource. All rights reserved.
//

#import "NSDate+WX.h"

@implementation NSDate (WX)

- (NSInteger)year{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)month{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)day{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)hour{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}
- (NSInteger)minute{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}


- (NSInteger)howManyDaysWithMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSInteger day = range.length;
    return day;
}



//@"yyyy-MM-dd HH:mm"
- (NSString *)stringForFormatter:(NSString *)formatter{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:formatter];
    return [format stringFromDate:self];
}

+ (NSDate *)dateForString:(NSString *)string formatter:(NSString *)formatter{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    return [format dateFromString:string];
}

+ (NSDate *)dateYYYYMMddHHmmssForString:(NSString *)string{
    return [NSDate dateForString:string formatter:@"yyyy-MM-dd HH:mm:ssss"];
}

- (NSString *)weekDayWithPrefix:(NSString *)prefix{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    NSString *week = [weekdays objectAtIndex:theComponents.weekday];
    if([prefix isEqualToString:@"星期"] &&[week isEqualToString:@"日"]){
        return @"星期天";
    }
    return [NSString stringWithFormat:@"%@%@",prefix, week];
}

+ (NSString *)MMddWithSeparator:(NSString *)separator{
    if (separator == nil){
        separator = @":";
    }
    return [[NSDate date] stringForFormatter:[NSString stringWithFormat:@"MM%@dd", separator]];
}

+ (NSString *)yyyyMMddWithSeparator:(NSString *)separator{
    if (separator == nil){
        separator = @":";
    }
    return [[NSDate date] stringForFormatter:[NSString stringWithFormat:@"yyyy%@MM%@dd",separator, separator]];
}

+ (NSString *)yyyyMMddHHmmWithSeparators:(NSArray<NSString *> *)separators{
    NSString *prefix = @"-";
    NSString *subfix = @":";

    if (separators.count > 0){
        prefix = separators[0];
    }
    if (separators.count > 1){
        subfix = separators[1];
    }

    
    return [[NSDate date] stringForFormatter:[NSString stringWithFormat:@"yyyy%@MM%@dd HH%@mm",prefix, prefix,subfix]];
}

+ (NSString *)yyyyMMddHHmmssWithSeparators:(NSArray<NSString *> *)separators{
    NSString *prefix = @"-";
    NSString *subfix = @":";
    if (separators.count > 0){
        prefix = separators[0];
    }
    if (separators.count > 1){
        subfix = separators[1];
    }
    return [[NSDate date] stringForFormatter:[NSString stringWithFormat:@"yyyy%@MM%@dd HH%@mm%@ss",prefix, prefix, subfix, subfix]];
}

+ (NSString *)weekDayWithPrefix:(NSString *)prefix{
    return [[NSDate date] weekDayWithPrefix:prefix];
}

+ (NSString *)weekDayWithPrefix:(NSString *)prefix date:(NSDate *)date{
    return [date weekDayWithPrefix:prefix];
}

+ (BOOL)isTodayWithTimeInterval:(NSTimeInterval)timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *dayDate = [NSDate date];

    if ([[date stringForFormatter:@"yyyy-MM-dd"] isEqualToString:[dayDate stringForFormatter:@"yyyy-MM-dd"]]) {
        return YES;
    }
    return NO;
}

@end
