//
//  UIColor+HexString.m
//  Shark
//
//  Created by Connect King on 11-11-15.
//  Copyright 2011年 alpha. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (UIColor *)dt_colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha //(NSUInteger)alpha
{
    CGFloat r = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    CGFloat g = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    CGFloat b = (hexValue & 0x000000FF) / 255.0;
    // CGFloat a = alpha / 255.0;

    return [self colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)dt_colorWithHexValueWithAlpha:(NSUInteger)hexValue
{
    CGFloat a = ((hexValue & 0xFF000000) >> 24) / 255.0;
    CGFloat r = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    CGFloat g = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    CGFloat b = (hexValue & 0x000000FF) / 255.0;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)dt_colorWithHexValue:(NSUInteger)hexValue
{
    return [self dt_colorWithHexValue:hexValue alpha:1.0]; // 255];
}

+ (UIColor *)dt_colorWithHexString:(NSString *)hexString
{
    unsigned long color = strtoul([hexString UTF8String], 0, 16);
    // NSString *str = @"0xff055008";
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型

    // strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    // unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
    // NSLog(@"转换完的数字为：%lx",color);
    return [UIColor dt_colorWithHexValue:color];
}

+ (UIColor *)dt_colorWithHexStringWithAlpha:(NSString *)hexString
{
    if (!hexString)
        hexString = @"0xFF000000";
    unsigned long color = strtoul([hexString UTF8String], 0, 0);
    // NSString *str = @"0xff055008";
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型

    // strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    // unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
    // NSLog(@"转换完的数字为：%lx",color);
    return [UIColor dt_colorWithHexValueWithAlpha:color];
}

+ (UIColor *)dt_colorWithHexStringWithAlpha:(NSString *)hexString alpha:(CGFloat)alpha
{
    if (!hexString)
        hexString = @"0xFF000000";
    unsigned long color = strtoul([hexString UTF8String], 0, 0);
    // NSString *str = @"0xff055008";
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    
    // strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    // unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
    // NSLog(@"转换完的数字为：%lx",color);
    return [UIColor dt_colorWithHexValue:color alpha:alpha];
}

@end
