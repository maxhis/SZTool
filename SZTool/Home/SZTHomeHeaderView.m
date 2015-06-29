//
//  SZTHomeHeaderView.m
//  SZTool
//
//  Created by Andy on 15/6/29.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeHeaderView.h"
#import "SZTWidgetView.h"

static CGFloat const kWidgetWidth   = 120;

@interface SZTHomeHeaderView ()

@property (nonatomic, strong) UIView *widgetPanel;
@property (nonatomic, strong) SZTWidgetView *airView;
@property (nonatomic, strong) SZTWidgetView *weatherView;

@property (nonatomic, assign) BOOL displayingWeather;

@end

@implementation SZTHomeHeaderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews
{
    _widgetPanel = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kWidgetWidth, 0, kWidgetWidth, kWidgetWidth)];
    [self addSubview:_widgetPanel];
    
    _airView = [[SZTWidgetView alloc] initWithFrame:CGRectMake(0, 0, kWidgetWidth, kWidgetWidth) type:WidgetTypeAir];
    [_widgetPanel addSubview:_airView];
    _weatherView = [[SZTWidgetView alloc] initWithFrame:CGRectMake(0, 0, kWidgetWidth, kWidgetWidth) type:WidgetTypeWeather];
    [_widgetPanel addSubview:_weatherView];
    _weatherView.hidden = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(flip)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)flip
{
    [UIView transitionWithView:self.widgetPanel
                      duration:1.0
                       options:(self.displayingWeather ? UIViewAnimationOptionTransitionFlipFromRight :
                                UIViewAnimationOptionTransitionFlipFromLeft)
                    animations: ^{
                        if(self.displayingWeather)
                        {
                            self.weatherView.hidden = true;
                            self.airView.hidden = false;
                        }
                        else
                        {
                            self.weatherView.hidden = false;
                            self.airView.hidden = true;
                        }
                    }
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.displayingWeather = !self.displayingWeather;
                        }
                    }];
}

@end
