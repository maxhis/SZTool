//
//  SZTWidgetView.h
//  SZTool
//
//  Created by iStar on 15/6/10.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WidgetType) {
    WidgetTypeWeather,
    WidgetTypeAir
};

/**
 *  桌面小控件，用于展示天气、空气质量
 */
@interface SZTWidgetView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(WidgetType)type;

@end
