//
//  SZTWeizhangService.m
//  SZTool
//
//  Created by iStar on 15/4/6.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTWeizhangService.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "HTMLParser.h"
#import "SZTWeizhangModel.h"

static NSString *const kVerifyCodeUrl = @"http://210.76.69.58/wfcx/captcha/_queryCph.jsp";

static NSString *const kQueryUrl = @"http://210.76.69.58/wfcx/_queryCph.jsp";

static NSString *const kResultUrl = @"http://210.76.69.58/wfcx/cphResultList.jsp";

NSArray const *kWeizhangItemNames;

@implementation SZTWeizhangService

+ (instancetype)sharedService
{
    static SZTWeizhangService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[SZTWeizhangService alloc] init];
        kWeizhangItemNames = @[@"车牌号", @"违法时间", @"违法地址", @"违法行为", @"处理标记", @"处理机关", @"处理地址"];
    });
    
    return service;
}

- (void)fetchVerifyCodeImageWithCompletion:(void (^)(UIImage *, NSError *))completionBlock
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


- (void)queryWeizhangWithChepaiNumber:(NSString *)chepaiNumber
                           chepaiType:(NSString *)chepaiType
                         chejiaNumber:(NSString *)chejiaNumber
                         engineNumber:(NSString *)engineNumber
                           verifyCode:(NSString *)verifyCode
                           completion:(void (^)(SZTResultModel *model, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"hphm": chepaiNumber,
                             @"hpzl":chepaiType,
                             @"clsbdh":chejiaNumber,
                             @"djzsbh":engineNumber,
                             @"captcha":verifyCode
                             };
    
    [manager POST:kQueryUrl
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError* error;
              NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                     error:&error];
              if ([[json objectForKey:@"type"] isEqualToString:@"success"])
              {
                  [self handleResultWithCompletion:completionBlock];
              }
              else
              {
                  SZTResultModel *result = [[SZTResultModel alloc] init];
                  result.success = NO;
                  result.message = [json objectForKey:@"detail"];
                  completionBlock(result, nil);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completionBlock(nil, error);
              NSLog(@"Error: %@", error.localizedDescription);
          }];
}

/**
 *    解析查询结果
 */
- (void)handleResultWithCompletion:(void (^)(SZTResultModel *model, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kResultUrl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             SZTResultModel *result = [[SZTResultModel alloc] init];
             NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             result.success = YES;
             result.message = [self parseHtml:html];
             completionBlock(result, nil);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completionBlock(nil, error);
             NSLog(@"Error: %@", error.localizedDescription);
         }];
}

- (NSArray *)parseHtml:(NSString *)html
{
    NSMutableArray *result = [NSMutableArray array];
    
    NSError *error;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (!error)
    {
        HTMLNode *bodyNode = [parser body];
        NSArray *trNodes = [bodyNode findChildTags:@"tr"];
        for (HTMLNode *trNode in trNodes) {
            if ([[trNode getAttributeNamed:@"class"] isEqualToString:@"zt_listTbody"]) {
                NSArray *tdNodes = [trNode findChildTags:@"td"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:7];
                for (NSInteger i = 0; i < tdNodes.count; i++)
                {
                    [dic setObject:[tdNodes[i] contents] forKey:kWeizhangItemNames[i]];
                }
                [result addObject:dic];
            }
        }
    }
    else
    {
        NSLog(@"Error: %@", error);
    }
    
    return result;
}

@end
