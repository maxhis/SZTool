//
//  SZTGongjijinService.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTGongjijinService.h"
#import "AFHTTPRequestOperationManager.h"
#import "SZTResultItem.h"

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
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                completionBlock(nil, error);
                                            }];
    [requestOperation start];
}

- (void)queryBalanceWithAccount:(NSString *)accountNumber IDNumber:(NSString *)IDNumber verifyCode:(NSString *)verifyCode completion:(void (^)(SZTResultModel *model, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"accnum": accountNumber,
                             @"certinum":IDNumber,
                             @"qryflag":@"1",
                             @"verifycode":verifyCode};
    [manager POST:kQueryUrl
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
              NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
              SZTResultModel *result = [self handleResponse:responseStr];
              
              completionBlock(result, nil);
              NSLog(@"responseObject %@", responseStr);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completionBlock(nil, error);
              NSLog(@"Error: %@", error);
          }];
}

/**
 *    处理返回的非格式化数据
 *
 *    @param response e.g. {success:true,cardstat:'2',newaccnum:'20610581693',msg:'6720.00',peraccstate:'0',oppsucc:false,sbbalance:'0.00'}
 *    {success:false,msg:'无此记录',oppsucc:false}
 */
- (SZTResultModel *)handleResponse:(NSString *)response
{
    NSString *jsonText = [self transferToJsonString:response];
    NSData *jsonData = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    
    SZTResultModel *result = [[SZTResultModel alloc] init];
    
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error)
    {
        NSLog(@"parse json error:%@", error.description);
    }
    else
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            BOOL success = [[results valueForKey:@"success"] boolValue];

            result.success = success;
            if (success)
            {
                NSMutableArray *resultItems = [[NSMutableArray alloc] initWithCapacity:5];
                SZTResultItem *item = [[SZTResultItem alloc] init];
                
                item.name = @"个人公积金账号:";
                item.value = [results valueForKey:@"newaccnum"];
                [resultItems addObject:item];
                
                item = [[SZTResultItem alloc] init];
                item.name = @"状态:";
                int peraccstate = [[results valueForKey:@"peraccstate"] intValue];
                if (peraccstate == 0) {
                    item.value = @"正常";
                } else if (peraccstate == 1) {
                    item.value = @"封存";
                } else if(peraccstate == 8) {
                    item.value = @"销户未结算";
                } else if(peraccstate == 9) {
                    int cardstat = [[results valueForKey:@"cardstat"] intValue];
                    if (cardstat == 0) {
                        item.value = @"账户未生效-新账户";
                    } else if(cardstat == 1) {
                        item.value = @"账户未生效-核查中";
                    } else if(cardstat == 2) {
                        item.value = @"销户";
                    } else if(cardstat == 3) {
                        item.value = @"账户未生效-核查失败";
                    }
                } else {
                    item.value = @"非正常";
                }
                [resultItems addObject:item];
                
                item = [[SZTResultItem alloc] init];
                item.name = @"账户余额:";
                item.value = [results valueForKey:@"msg"];
                [resultItems addObject:item];
                
                item = [[SZTResultItem alloc] init];
                item.name = @"社保移交金额:";
                item.value = [results valueForKey:@"sbbalance"];
                [resultItems addObject:item];
                
                result.message = resultItems;
            }
            else
            {
                result.message = [results valueForKey:@"msg"];
            }
            
        }
    }
    
    return result;
}

/**
 *    转换成标准格式的JSON字符串
 *
 *    @param rawtext
 *
 *    @return <#return value description#>
 */
- (NSString *)transferToJsonString:(NSString *)rawtext
{
    NSMutableString *mutableString = [rawtext mutableCopy];
    return [[[[[[[[mutableString stringByReplacingOccurrencesOfString:@"success" withString:@"\"success\""]
    stringByReplacingOccurrencesOfString:@"cardstat" withString:@"\"cardstat\""]
    stringByReplacingOccurrencesOfString:@"newaccnum" withString:@"\"newaccnum\""]
    stringByReplacingOccurrencesOfString:@"msg" withString:@"\"msg\""]
    stringByReplacingOccurrencesOfString:@"peraccstate" withString:@"\"peraccstate\""]
    stringByReplacingOccurrencesOfString:@"oppsucc" withString:@"\"oppsucc\""]
    stringByReplacingOccurrencesOfString:@"sbbalance" withString:@"\"sbbalance\""]
    stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
}

@end
