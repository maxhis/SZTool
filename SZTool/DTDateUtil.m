//
//  DTDateUtil.m
//  DingTalk
//
//  Created by Lings on 14-8-12.
//  Copyright (c) 2014年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import "DTDateUtil.h"

@implementation DTDateUtil

static NSDateFormatter *timeFormatter = nil;
static NSDateFormatter *mediumDateFormatter = nil;
static NSDateFormatter *shortDateFormatter = nil;

+ (NSString *)simpleDateStringWithDate:(NSDate *)date
{
    /**
     http://docs.alibaba-inc.com/display/526proj/005IM
     
     1、时间戳显示最后一条消息的时间，如果消息已经被清空，时间戳则消失；
     2、时间戳格式：一分钟之内（刚刚），今天的（上午/下午 小时:分钟），昨天，前天，n月n日（6月30日），一年之前的 年/月/日（14/6/30）
     */
    
    NSParameterAssert(date);
    
    NSString * simpleString = nil;
    
    NSDate *nowDate = [NSDate date];
    
    /*
     * 因为针对“刚刚”，客户端不会用timer使其随着时间的变化而变化，所以去掉
     *
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
    
    if (nowTimeInterval-timeInterval <= 60)
    {
        // 刚刚
        simpleString = DTLocalizedString(@"common.utils.date.justnow");
        return simpleString;
    }
     */
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *dateComps = [calendar components:unitFlags fromDate:date];
    NSDateComponents *nowComps = [calendar components:unitFlags fromDate:nowDate];
    
    NSDate *ymdDate = [calendar dateFromComponents:dateComps];
    NSDate *nowYmdDate = [calendar dateFromComponents:nowComps];
    
    NSDateComponents *finalComps = [calendar components:unitFlags fromDate:ymdDate toDate:nowYmdDate options:0];
    
    if (finalComps.era == 0
        && finalComps.year == 0
        && finalComps.month == 0
        && finalComps.day == 0)
    {
        // 今天 直接显示 时:分
        if (!timeFormatter)
        {
            timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateStyle:NSDateFormatterNoStyle];
            [timeFormatter setTimeStyle:NSDateFormatterShortStyle]; // 这种方式自动显示成类似status bar上的时间风格，包括24小时制以及非24小时时中午上下午前置，英文AM/PM后置
        }
        
        simpleString = [timeFormatter stringFromDate:date];
        return simpleString;
    }
    
    if (finalComps.era == 0
        && finalComps.year == 0
        && finalComps.month == 0
        && finalComps.day == 1)
    {
        // 昨天
        simpleString = @"昨天";
        return simpleString;
    }
    
    if (finalComps.era == 0
        && finalComps.year == 0)
    {
        // 一年内 显示 x月x日
        if (!shortDateFormatter)
        {
            shortDateFormatter = [[NSDateFormatter alloc] init];
            shortDateFormatter.dateFormat = @"M月d日";
        }
        
        simpleString = [shortDateFormatter stringFromDate:date];
        return simpleString;
    }
    
    // 超过一年的，显示年/月/日
    if (!mediumDateFormatter)
    {
        mediumDateFormatter = [[NSDateFormatter alloc] init];
        mediumDateFormatter.dateFormat = @"yyyy/M/d";
    }
    
    simpleString = [mediumDateFormatter stringFromDate:date];

    return simpleString;
}

+ (NSString *)simpleDateStringWithTimeInterval:(NSTimeInterval)timeInterval
{
    return [self simpleDateStringWithDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

+ (NSString *)simpleDateStringWithMilliseconds:(int64_t)milliseconds
{
    return [self simpleDateStringWithTimeInterval:milliseconds/1000.0];
}

@end
