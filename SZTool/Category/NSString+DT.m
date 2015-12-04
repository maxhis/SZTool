//
//  NSString+DT.m
//  SZTool
//
//  Created by iStar on 15/3/19.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
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

-(BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isDigits
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([self rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        // consists only of the digits 0 through 9
        return YES;
    }
    return NO;
}

@end
