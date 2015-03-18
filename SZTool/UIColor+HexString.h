//
//  UIColor+HexString.h
//  Shark
//
//  Created by Connect King on 11-11-15.
//  Copyright 2011年 alpha. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#define UIColorFromRGB(rgb) [UIColor dt_colorWithHexValue:rgb]

#define UIColorFromRGBA(rgb, a) [UIColor dt_colorWithHexValue:rgb alpha:a]


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface UIColor (HexString)

/**
*  16进制数转换为色值，alpha值为1
*
*  @param hexValue 16进制数值
*
*  @return 颜色
*/
+ (UIColor *)dt_colorWithHexValue:(NSUInteger)hexValue;

/**
 *  16进制数转换为色值
 *
 *  @param hexValue 16进制数值
 *  @param alpha    透明度
 *
 *  @return 颜色
 */
+ (UIColor *)dt_colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;

/**
 *  16进制数转换为色值
 *
 *  @param hexValue 16进制数值
 *  @param alpha    透明度
 *
 *  @return 颜色
 */
+ (UIColor *)dt_colorWithHexStringWithAlpha:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 *  16进制数转换为色值，请不要含有alpha值，即只含rgb值
 *
 *  @param hexString 16进制字符串，不含alpha值
 *
 *  @return 颜色
 */
+ (UIColor *)dt_colorWithHexString:(NSString *)hexString;

/**
 *  16进制数转换为色值，含有alpha值，即只含arbg值,必须注意argb的值设置的顺序
 *
 *  @param hexString 16进制字符串
 *
 *  @return 颜色
 */
+ (UIColor *)dt_colorWithHexStringWithAlpha:(NSString *)hexString;
@end
