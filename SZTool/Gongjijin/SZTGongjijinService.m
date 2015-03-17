//
//  SZTGongjijinService.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTGongjijinService.h"
#import "AFHTTPRequestOperationManager.h"

static NSString *const kVerifyCodeUrl = @"http://www.szzfgjj.com/code.jsp";

static NSString *const kQueryUrl = @"http://www.szzfgjj.com/admin/download/download/Com_accountQuery.do";

@implementation SZTGongjijinService

+ (instancetype)sharedService
{
    static SZTGongjijinService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SZTGongjijinService alloc] init];
    });
    
    return instance;
}

- (void)fetchVerifyCodeImageWithCompletion:(void (^)(UIImage *verifyCodeImage, NSError *error))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kVerifyCodeUrl]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    }];
    [requestOperation start];
}

- (void)queryBalanceWithAccount:(NSString *)accountNumber IDNumber:(NSString *)IDNumber verifyCode:(NSString *)verifyCode completion:(void (^)(SZTGongjijinResultModel *model, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"accnum": accountNumber,
                             @"certinum":IDNumber,
                             @"qryflag":@"1",
                             @"verifycode":verifyCode};
    [manager POST:kQueryUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        SZTGongjijinResultModel *result = [self handleResponse:responseStr];
        
        completionBlock(result, nil);
        NSLog(@"responseObject %@", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
        NSLog(@"Error: %@", error);
    }];
}

/**
 *    处理返回的非格式化数据 </br>
 *    TODO 目前的这种做法很low，需要优化
 *
 *    @param response e.g. {success:true,cardstat:'2',newaccnum:'20610581693',msg:'6720.00',peraccstate:'0',oppsucc:false,sbbalance:'0.00'}
 */
- (SZTGongjijinResultModel *)handleResponse:(NSString *)response
{
    BOOL success = ([response rangeOfString:@"success:true"].location != NSNotFound);
    NSArray *splits = [response componentsSeparatedByString:@"'"];
    NSString *msg;
    if (success)
    {
        msg = splits[5];
    }
    else
    {
        msg = splits[1];
    }
    
    SZTGongjijinResultModel *result = SZTGongjijinResultModel.new;
    result.success = success;
    result.message = msg;
    return result;
}

@end
