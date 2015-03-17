//
//  UIView+Frame.h
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat dt_left;
@property (nonatomic, assign) CGFloat dt_right;
@property (nonatomic, assign) CGFloat dt_top;
@property (nonatomic, assign) CGFloat dt_bottom;

@property (nonatomic, assign) CGFloat dt_centerX;
@property (nonatomic, assign) CGFloat dt_centerY;

@property (nonatomic, assign) CGFloat dt_width;
@property (nonatomic, assign) CGFloat dt_height;

@property (nonatomic, assign) CGPoint dt_origin;
@property (nonatomic, assign) CGSize dt_size;

@end
