//
//  NSString+DT.h
//  SZTool
//
//  Created by iStar on 15/3/19.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DT)

/**
 *  生成一个新的UUID字符串
 */
+ (NSString *)dt_UUIDString;

// trim
- (NSString *)dt_trim;

// md5
- (NSString *)dt_md5String;

// urlencode
- (NSString *)dt_urlEncode;

// urldecode
- (NSString *)dt_urlDecode;

-(BOOL)isValidEmail;

- (BOOL)isDigits;

@end
