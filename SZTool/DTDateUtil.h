//
//  DTDateUtil.h
//  DingTalk
//
//  Created by Lings on 14-8-12.
//  Copyright (c) 2014年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTDateUtil : NSObject

/**
 *  获取简明的时间字串，比如“刚刚”、“昨天”之类的
 *
 *  @param date 时间
 *
 *  @return 简明时间字串
 */
+ (NSString *)simpleDateStringWithDate:(NSDate *)date;

/**
 *  获取简明的时间字串，比如“刚刚”、“昨天”之类的
 *
 *  @param timeInterval 秒数 timeIntervalSince1970
 *
 *  @return 简明时间字串
 */
+ (NSString *)simpleDateStringWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  获取简明的时间字串，比如“刚刚”、“昨天”之类的
 *
 *  @param milliseconds 毫秒数 timeIntervalSince1970 * 1000.0
 *
 *  @return 简明时间字串
 */
+ (NSString *)simpleDateStringWithMilliseconds:(int64_t)milliseconds;

@end
