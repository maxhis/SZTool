//
//  BaiduAPIUtils.h
//  SZTool
//
//  Created by iStar on 15/6/9.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APIDoneBlock)(NSDictionary *result, NSError *error);

@interface BaiduAPIUtils : NSObject

/**
 *  获取天气信息
 *  @param {
 WD = "\U65e0\U6301\U7eed\U98ce\U5411";
 WS = "\U5fae\U98ce(<10m/h)";
 altitude = 40;
 city = "\U6df1\U5733";
 citycode = 101280601;
 date = "15-06-09";
 "h_tmp" = 32;
 "l_tmp" = 27;
 latitude = "22.544";
 longitude = "114.109";
 pinyin = shenzhen;
 postCode = 518001;
 sunrise = "05:38";
 sunset = "19:07";
 temp = 32;
 time = "11:00";
 weather = "\U5c0f\U96e8";
 }
 */
+ (void)fetchWeatherData:(APIDoneBlock) doneBlock;

/**
 *  获取空气质量信息
 *  @param doneBlock：{
 aqi = 36;
 city = "\U6df1\U5733";
 core = "";
 level = "\U4f18";
 time = "2015-06-09T22:00:00Z";
 }
 */
+ (void)fetchAirData:(APIDoneBlock) doneBlock;

@end
