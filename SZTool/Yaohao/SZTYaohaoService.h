//
//  SZTYaohaoService.h
//  SZTool
//
//  Created by iStar on 15/3/17.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ApplyType) {
    ApplyTypePerson,
    ApplyTypeUnit
};

@interface SZTYaohaoService : NSObject

+ (instancetype)sharedService;

/**
 *    查询是否摇中
 *
 *    @param applyCode       申请码
 *    @param issueNumber     期数
 *    @param applyType       个人或单位
 *    @param completionBlock <#completionBlock description#>
 */
- (void)queryStatusWithApplycode:(NSString *)applyCode
                      issueNmber:(NSString *)issueNumber
                            type:(ApplyType)applyType
                      completion:(void (^)(BOOL hit, NSError *error))completionBlock;

@end
