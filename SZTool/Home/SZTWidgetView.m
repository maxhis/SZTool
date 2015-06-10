//
//  SZTWidgetView.m
//  SZTool
//
//  Created by iStar on 15/6/10.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTWidgetView.h"
#import "BaiduAPIUtils.h"

@interface SZTWidgetView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *tempView;
@property (weak, nonatomic) IBOutlet UILabel *descView;
@property (weak, nonatomic) IBOutlet UILabel *degreeView;

@end

@implementation SZTWidgetView

- (instancetype)initWithFrame:(CGRect)frame type:(WidgetType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:self options:nil] firstObject];
        self.frame = frame;
        
        if (type == WidgetTypeWeather) {
            [self setupWeather];
        }
        else {
            [self setupAir];
        }
    }
    return self;
}

- (void)setupWeather
{
    [BaiduAPIUtils fetchWeatherData:^(NSDictionary *result, NSError *error) {
        if (error == nil && result) {
            self.tempView.text = result[@"temp"];
            NSString *weather = result[@"weather"];
            self.descView.text = weather;
            
            UIImage *weatherIcon;
            if ([weather isEqualToString:@"晴"]) {
                weatherIcon = [UIImage imageNamed:@"Sunny"];
            }
            else if ([weather isEqualToString:@"雾"]) {
                weatherIcon = [UIImage imageNamed:@"Foggy"];
            }
            else if ([weather isEqualToString:@"多云"] || [weather isEqualToString:@"阴"]) {
                weatherIcon = [UIImage imageNamed:@"Cloudy"];
            }
            else if ([weather rangeOfString:@"雨"].location != NSNotFound) {
                weatherIcon = [UIImage imageNamed:@"Rainy"];
            }
            else if ([weather rangeOfString:@"雪"].location != NSNotFound) {
                weatherIcon = [UIImage imageNamed:@"Snowflake"];
            }
            
            self.iconView.image = weatherIcon;
            self.degreeView.text = @"°";
        }
    }];
}

- (void)setupAir
{
    [BaiduAPIUtils fetchAirData:^(NSDictionary *result, NSError *error) {
        if (error == nil && result) {
            self.tempView.text = [NSString stringWithFormat:@"%@", result[@"aqi"]];
            NSString *level = result[@"level"];
            if (level.length <= 2) {
                level = [NSString stringWithFormat:@"空气质量%@", level];
            }
            self.descView.text = level;
            self.degreeView.text = @"AQI";
        }
    }];
}

@end
