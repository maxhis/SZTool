//
//  SZTYaohaoService.m
//  SZTool
//
//  Created by iStar on 15/3/17.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTYaohaoService.h"
#import "AFHTTPRequestOperationManager.h"
#import "HTMLParser.h"

static NSString *const kQueryUrlPerson = @"http://apply.sztb.gov.cn/apply/app/status/norm/person";
static NSString *const kQueryUrlUnit   = @"http://apply.sztb.gov.cn/apply/app/status/norm/unit";

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
//              NSLog(@"result:%@", responseStr);
              completionBlock([self handleResult:responseStr], nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completionBlock(NO, error);
          }];
}

/**
 *    查询是否中签
 */
- (BOOL)handleResult:(NSString *)response
{
    NSError *error;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:response error:&error];
    HTMLNode *body = [parser body];
    
    NSArray *trTags = [body findChildTags:@"tr"];
    for (HTMLNode *node in trTags)
    {
        if ([[node getAttributeNamed:@"class"] isEqualToString:@"content_data"])
        {
            return (node.children.count == 5); // 这个地方很诡异，这个库不太好用
        }
    }
    
    return NO;
}

@end
