//
//  SZTGongjijinService.h
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTResultModel.h"

@interface SZTGongjijinService : NSObject

+ (instancetype)sharedService;

/**
 *    获取验证码
 */
- (void)fetchVerifyCodeImageWithCompletion:(void (^)(UIImage *verifyCodeImage, NSError *error))completionBlock;

/**
 *    查询公积金余额
 *
 *    @param accountNumber 公积金账号
 *    @param IDNumber      身份证号
 *    @param verifyCode    验证码
 */
- (void)queryBalanceWithAccount:(NSString *)accountNumber IDNumber:(NSString *)IDNumber verifyCode:(NSString *)verifyCode completion:(void (^)(SZTResultModel *model, NSError *error))completionBlock;

@end
