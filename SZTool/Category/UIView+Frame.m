//
//  UIView+Frame.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (CGFloat)dt_left
{
    return self.frame.origin.x;
}

- (void)setDt_left:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = ceilf(x);
    self.frame = frame;
}

- (CGFloat)dt_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setDt_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = ceilf(right - frame.size.width);
    self.frame = frame;
}

- (CGFloat)dt_top
{
    return self.frame.origin.y;
}

- (void)setDt_top:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = ceilf(y);
    self.frame = frame;
}

- (CGFloat)dt_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setDt_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = ceilf(bottom - frame.size.height);
    self.frame = frame;
}

- (CGFloat)dt_centerX
{
    return self.center.x;
}

- (void)setDt_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(ceilf(centerX), self.center.y);
}

- (CGFloat)dt_centerY
{
    return self.center.y;
}

- (void)setDt_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, ceilf(centerY));
}

- (CGFloat)dt_width
{
    return self.frame.size.width;
}

- (void)setDt_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = ceilf(width);
    self.frame = frame;
}

- (CGFloat)dt_height
{
    return self.frame.size.height;
}

- (void)setDt_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = ceilf(height);
    self.frame = frame;
}

- (CGPoint)dt_origin
{
    return self.frame.origin;
}

- (void)setDt_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)dt_size
{
    return self.frame.size;
}

- (void)setDt_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
