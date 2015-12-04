//
//  DTDateUtil.h
//  SZTool
//
//  Created by iStar on 15/3/19.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
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
