//
//  SZTBuscardService.m
//  SZTool
//
//  Created by Andy on 15/8/20.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTBuscardService.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "SZTResultItem.h"

@implementation SZTBuscardService

static NSString *const kQueryUrl = @"http://query.shenzhentong.com:8080/sztnet/qryCard.do";

+ (instancetype)sharedService
{
	    static SZTBuscardService *_sharedService = nil;
	    static dispatch_once_t onceToken;
	    dispatch_once(&onceToken, ^{
	        _sharedService = [[SZTBuscardService alloc] init];
	    });
	
	    return _sharedService;
}

- (void)queryBalanceWithAccount:(NSString *)accountNumber completion:(void (^)(SZTResultModel *model, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"cardno": accountNumber};
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
    
    // 解析HTML
    NSError *error;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:response error:&error];
    HTMLNode *body = [parser body];
    HTMLNode *resultNode = [self findResultNode:body];
    if (resultNode) {
        NSArray *tdNodes = [resultNode findChildTags:@"td"];
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < tdNodes.count; i += 2) {
            SZTResultItem *item = [[SZTResultItem alloc] init];
            if(i == 2) { // 卡内余额(截止到2015-08-19 08:20:56)：
                NSString *rawText = [tdNodes[i] contents];
                NSInteger leftPos = [rawText rangeOfString:@"("].location + 4;
                NSInteger rightPos = [rawText rangeOfString:@")"].location;
                
                item.name = [NSString stringWithFormat:@"%@：", [rawText componentsSeparatedByString:@"("][0]];
                item.value = [tdNodes[i+1] contents];
                [items addObject:item];
                
                item = [[SZTResultItem alloc] init];
                item.name = @"截止到：";
                item.value = [rawText substringWithRange:NSMakeRange(leftPos, rightPos - leftPos)];
                [items addObject:item];
            }
            else {
                item.name = [tdNodes[i] contents];
                item.value = [tdNodes[i+1] contents];
                [items addObject:item];
            }
        }
        result.message = items;
        result.success = YES;
    }
    else {
        result.message = @"未查询到该卡相关记录";
        result.success = NO;
    }
    
    return result;
}

- (HTMLNode *)findResultNode:(HTMLNode *)body
{
    NSArray *tableNodes = [body findChildTags:@"table"];
    for (HTMLNode *node in tableNodes) {
        if ([[node getAttributeNamed:@"class"] isEqualToString:@"tableact"]) {
            return node;
        }
    }
    return nil;
}

@end
