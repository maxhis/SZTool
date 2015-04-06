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

static NSString *const kVerifyCodeUrl = @"http://210.76.69.58/wfcx/captcha/_queryCph.jsp";

static NSString *const kQueryUrl = @"http://210.76.69.58/wfcx/_queryCph.jsp";

@implementation SZTWeizhangService

+ (instancetype)sharedService
{
    static SZTWeizhangService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[SZTWeizhangService alloc] init];
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
              SZTResultModel *result = [[SZTResultModel alloc] init];
              if ([[json objectForKey:@"type"] isEqualToString:@"success"])
              {
                  result.success = YES;
                  result.message = json;
              }
              else
              {
                  result.success = NO;
                  result.message = [json objectForKey:@"detail"];
              }
              
              completionBlock(result, nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completionBlock(nil, error);
              NSLog(@"Error: %@", error);
          }];
}

@end
