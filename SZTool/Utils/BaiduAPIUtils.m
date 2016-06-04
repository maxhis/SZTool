//
//  BaiduAPIUtils.m
//  SZTool
//
//  Created by iStar on 15/6/9.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "BaiduAPIUtils.h"
#import "HTMLParser.h"

static NSString *const kWeatherUrl   = @"http://apis.baidu.com/apistore/weatherservice/weather";
static NSString *const kAirUrl       = @"http://apis.baidu.com/apistore/aqiservice/aqi";
static NSString *const kGasPriceUrl  = @"http://apis.baidu.com/showapi_open_bus/oil_price/find";
static NSString *const kWeatherV2Url = @"http://m.weather.com.cn/mweather/101280601.shtml";
static NSString *const kYaohaoUrl    = @"https://sp0.baidu.com/9_Q4sjW91Qh3otqbppnN2DJv/pae/common/api/yaohao?city=%E6%B7%B1%E5%9C%B3&format=json&resource_id=4003";

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

+ (void)fetchWeatherDataV2:(APIDoneBlock)doneBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kWeatherV2Url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             [self parseHtml:html withBlock:doneBlock];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             doneBlock(nil, error);
    }];
}

+ (void )parseHtml:(NSString *)html withBlock:(APIDoneBlock)doneBlock
{
    NSError *error;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error) {
        doneBlock(nil, error);
        return ;
    }
    
    HTMLNode *body = [parser body];
    NSArray *tdTags = [body findChildTags:@"td"];
    NSString *temp, *weather;
    for (HTMLNode *node in tdTags) {
        // <td width="50%" class="wd">28℃</td>
        if ([[node getAttributeNamed:@"class"] isEqualToString:@"wd"]) {
            temp = [[node contents] componentsSeparatedByString:@"℃"][0];
        }
        else { // <td width="30%"><span>多云</span><span>无持续风向</span><span>微风</span></td>
            NSArray *spanNodes = [node findChildTags:@"span"];
            if (spanNodes.count > 0) {
                weather = [spanNodes[0] contents];
            }
        }
    }
    if (temp && weather) {
        doneBlock(@{@"temp":temp, @"weather": weather}, nil);
    }
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

/**
 * 获取今日油价
 */
+ (void)fetchGasPriceOfProvinc:(NSString *)province doneBlock:(APIDoneBlock)doneBlock;
{
    static AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:kBaiduAPIKey forHTTPHeaderField:@"apikey"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    
    NSDictionary *params = @{@"prov" : province};
    [manager GET:kGasPriceUrl
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *result = (NSDictionary *)responseObject;
             NSDictionary *resultBody = result[@"showapi_res_body"];
             NSArray *data = resultBody[@"list"];
             if(data.count > 0) {
                 doneBlock(data[0], nil);
             }
//             NSLog(@"%@", responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             doneBlock(nil, error);
         }
     ];
}

+ (void)getYaohaoResultWithName:(NSString *)name doneBlock:(APIDoneBlock)doneBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *params = @{@"name" : name};
    [manager GET:kYaohaoUrl
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *result = (NSDictionary *)responseObject;
             NSArray *datas = result[@"data"];
             if (datas.count) {
                 doneBlock([datas firstObject], nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             doneBlock(nil, error);
         }
    ];
}

@end
