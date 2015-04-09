//
//  SZTWeizhangService.h
//  SZTool
//
//  Created by iStar on 15/4/6.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTResultModel.h"

extern NSArray const *kWeizhangItemNames;

@interface SZTWeizhangService : NSObject

+ (instancetype)sharedService;

/**
 *    获取验证码
 */
- (void)fetchVerifyCodeImageWithCompletion:(void (^)(UIImage *verifyCodeImage, NSError *error))completionBlock;

/**
 *    查询违章
 *
 *    @param chepaiNumber    车牌号
 *    @param chepaiType      车牌类型
 *    @param chejiaNumber    车架号
 *    @param engineNumber    发动机号
 *    @param verifyCode      验证码
 *    @param completionBlock 查询结果回调
 */
- (void)queryWeizhangWithChepaiNumber:(NSString *)chepaiNumber
                           chepaiType:(NSString *)chepaiType
                         chejiaNumber:(NSString *)chejiaNumber
                         engineNumber:(NSString *)engineNumber
                           verifyCode:(NSString *)verifyCode
                           completion:(void (^)(SZTResultModel *model, NSError *error))completionBlock;


@end
