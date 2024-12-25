//
//  NSDate+WX.h
//  openSource
//
//  Created by openSource on 2023/3/14.
//  Copyright © 2023 openSource. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (WX)

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;

@property (nonatomic, readonly) NSInteger howManyDaysWithMonth;


- (NSString *)stringForFormatter:(NSString *)formatter;
+ (NSDate *)dateForString:(NSString *)string formatter:(NSString *)formatter;

+ (NSDate *)dateYYYYMMddHHmmssForString:(NSString *)string;


- (NSString *)weekDayWithPrefix:(NSString *)prefix;

+ (NSString *)MMddWithSeparator:(NSString *)separator;

+ (NSString *)yyyyMMddWithSeparator:(NSString *)separator;

+ (NSString *)yyyyMMddHHmmWithSeparators:(NSArray<NSString *> *)separators;

+ (NSString *)yyyyMMddHHmmssWithSeparators:(NSArray<NSString *> *)separators;


+ (NSString *)weekDayWithPrefix:(NSString *)prefix;

+ (NSString *)weekDayWithPrefix:(NSString *)prefix date:(NSDate *)date;

+ (BOOL)isTodayWithTimeInterval:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
