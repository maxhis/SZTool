//
//  NSString+DT.h
//  DingTalk
//
//  Created by Lings on 14-9-2.
//  Copyright (c) 2014年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
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

@end
