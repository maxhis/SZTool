//
//  BaiduAPIUtils.m
//  SZTool
//
//  Created by iStar on 15/6/9.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "BaiduAPIUtils.h"

static NSString *const kWeatherUrl  = @"http://apis.baidu.com/apistore/weatherservice/weather";
static NSString *const kAirUrl      = @"http://apis.baidu.com/apistore/aqiservice/aqi";

@implementation BaiduAPIUtils

/**
 *  获取天气信息
 */
+ (void)fetchWeatherData:(APIDoneBlock) doneBlock
{
    static AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:kBaiduAPIKey forHTTPHeaderField:@"apikey"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    
    NSDictionary *params = @{@"citypinyin" : @"shenzhen"};
    [manager GET:kWeatherUrl
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //NSLog(@"%@", responseObject);
             id data = [responseObject objectForKey:@"retData"];
             if ([data isKindOfClass:[NSDictionary class]]) {
                 doneBlock(data, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //NSLog(@"%@", error.localizedDescription);
             doneBlock(nil, error);
         }];
}

/**
 *  获取空气质量信息
 */
+ (void)fetchAirData:(APIDoneBlock) doneBlock
{
    static AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:kBaiduAPIKey forHTTPHeaderField:@"apikey"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    
    NSDictionary *params = @{@"city" : @"深圳"};
    [manager GET:kAirUrl
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //NSLog(@"%@", responseObject);
             id data = [responseObject objectForKey:@"retData"];
             if ([data isKindOfClass:[NSDictionary class]]) {
                 doneBlock(data, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             doneBlock(nil, error);
         }];
}

@end
