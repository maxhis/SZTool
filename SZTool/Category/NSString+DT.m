//
//  NSString+DT.m
//  DingTalk
//
//  Created by Lings on 14-9-2.
//  Copyright (c) 2014年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import "NSString+DT.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (DT)

+ (NSString *)dt_UUIDString
{
    return [[NSUUID UUID] UUIDString];
}

- (NSString *)dt_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)dt_md5String
{
    const char *concat_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
    
	NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
		[hash appendFormat:@"%02x", result[i]];
	}
    
	return [hash lowercaseString];
}

- (NSString *)dt_urlEncode
{
    NSString *resultString = self;
    NSString *temString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                (CFStringRef)self,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8));
    if ([temString length])
    {
        resultString = [NSString stringWithString:temString];
    }
    
    return resultString;
}

- (NSString *)dt_urlDecode
{
    NSString *resultString = self;
    NSString *temString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                                (CFStringRef)self,
                                                                                                                CFSTR(""),
                                                                                                                kCFStringEncodingUTF8));
    
    if ([temString length])
    {
        resultString = [NSString stringWithString:temString];
    }
    
    return resultString;
}


@end
