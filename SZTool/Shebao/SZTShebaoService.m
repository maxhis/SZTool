//
//  SZTShebaoService.m
//  SZTool
//
//  Created by iStar on 15/3/17.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTShebaoService.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SZTResultItem.h"
#import "HTMLParser.h"

static NSString *const kVerifyCodeUrl = @"https://wssb6.szsi.gov.cn/NetApplyWeb/CImages";

static NSString *const kQueryUrl = @"https://wssb6.szsi.gov.cn/NetApplyWeb/personacctoutResult.jsp";

@implementation SZTShebaoService

+ (instancetype)sharedService
{
    static SZTShebaoService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[SZTShebaoService alloc] init];
    });
    return service;
}

- (void)fetchVerifyCodeImageWithCompletion:(void (^)(UIImage *verifyCodeImage, NSError *error))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kVerifyCodeUrl]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(responseObject, nil);
    }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                completionBlock(nil, error);
                                            }];
    [requestOperation start];
}

- (void)queryBalanceWithAccount:(NSString *)accountNumber
                       IDNumber:(NSString *)IDNumber
                     verifyCode:(NSString *)verifyCode
                     completion:(void (^)(SZTResultModel *model, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"bacode": accountNumber,
                             @"id":IDNumber,
                             @"PSINPUT":verifyCode};
    [manager POST:kQueryUrl
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
              NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:encoding];
              SZTResultModel *result = [self handleResponse:responseStr];
              
              completionBlock(result, nil);
//              NSLog(@"responseObject %@", responseStr);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completionBlock(nil, error);
              NSLog(@"Error: %@", error);
          }];
}

- (SZTResultModel *)handleResponse:(NSString *)response
{
    SZTResultModel *result = [[SZTResultModel alloc] init];
    
    // 查询成功，直接展示返回的HTML
    if ([response rangeOfString:@"alert"].location == NSNotFound)
    {
        result.message = [self parseHtml:response];
        result.success = YES;
    }
    else // 查询出错，截取alert的内容
    {
        result.message = [self handleAlertString:response];
        result.success = NO;
    }
    return result;
}

- (NSArray *)parseHtml:(NSString *)html
{
    NSError *error;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    HTMLNode *body = [parser body];
    
    NSArray *tdTags = [body findChildTags:@"td"];
    HTMLNode *tdNode;
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i = 0; i < tdTags.count; i++)
    {
        tdNode = tdTags[i];
        if (tdNode.children.count == 1 && tdNode.firstChild.nodetype == HTMLTextNode)
        {
            NSString *content = tdNode.contents;
            if (!content || [[content dt_trim] isEqualToString:@""])
            {
                continue;
            }
            SZTResultItem *item = [[SZTResultItem alloc] init];
            HTMLNode *nextNode = tdTags[++i];
            item.name = content;
            item.value = [nextNode.contents dt_trim];
            [items addObject:item];
        }
    }
    
    return items;
}

- (NSString *)handleAlertString:(NSString *)rawText
{
    NSString *newText;
    
    NSError  *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"alert\\('[\\w+，！]+'\\)" options:0 error:&error];
    
    NSRange range = [regEx rangeOfFirstMatchInString:rawText options:0 range:NSMakeRange(0, rawText.length)];
    if (range.location == NSNotFound) {
        newText = @"查询出错";
    }
    else
    {
        NSString *matchedString = [rawText substringWithRange:range]; // alert('验证码不正确，请重新输入！')
        newText = [matchedString componentsSeparatedByString:@"'"][1];
    }
    
    return newText;
}

@end
