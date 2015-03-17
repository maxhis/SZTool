//
//  SZTShebaoService.h
//  SZTool
//
//  Created by iStar on 15/3/17.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTResultModel.h"

@interface SZTShebaoService : NSObject

+ (instancetype)sharedService;

/**
 *    获取验证码
 */
- (void)fetchVerifyCodeImageWithCompletion:(void (^)(UIImage *verifyCodeImage, NSError *error))completionBlock;

/**
 *    查询社保余额
 *
 *    @param accountNumber 电脑号
 *    @param IDNumber      身份证号
 *    @param verifyCode    验证码
 */
- (void)queryBalanceWithAccount:(NSString *)accountNumber
                       IDNumber:(NSString *)IDNumber
                     verifyCode:(NSString *)verifyCode
                     completion:(void (^)(SZTResultModel *model, NSError *error))completionBlock;


@end
