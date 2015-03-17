//
//  SZTYaohaoService.m
//  SZTool
//
//  Created by iStar on 15/3/17.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTYaohaoService.h"
#import "AFHTTPRequestOperationManager.h"

static NSString *const kQueryUrlPerson = @"http://apply.sztb.gov.cn/apply/app/status/norm/person";
static NSString *const kQueryUrlUnit   = @"http://apply.sztb.gov.cn/apply/app/status/norm/unit";

static NSString *const kKeyWords = @"中签指标中无此数据";

@implementation SZTYaohaoService

+ (instancetype)sharedService
{
    static SZTYaohaoService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[SZTYaohaoService alloc] init];
    });
    
    return service;
}

- (void)queryStatusWithApplycode:(NSString *)applyCode
                      issueNmber:(NSString *)issueNumber
                            type:(ApplyType)applyType
                      completion:(void (^)(BOOL hit, NSError *error))completionBlock
{
    NSString *url;
    if (ApplyTypeUnit == applyType)
    {
        url = kQueryUrlUnit;
    }
    else
    {
        url = kQueryUrlPerson;
    }
    
    NSDictionary *params = @{ @"issueNumber":issueNumber,
                              @"applyCode": applyCode};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
              NSLog(@"result:%@", responseStr);
              completionBlock([self handleResult:responseStr], nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completionBlock(NO, error);
          }];
}

/**
 *    查询是否中签，这种方式比较low，待优化
 */
- (BOOL)handleResult:(NSString *)response
{
    NSRange range = [response rangeOfString:kKeyWords];
    if (range.location == NSNotFound) {
        return YES;
    }
    return NO;
}

@end
