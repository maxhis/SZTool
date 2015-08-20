//
//  SZTBuscardService.h
//  SZTool
//
//  Created by Andy on 15/8/20.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTResultModel.h"

@interface SZTBuscardService : NSObject

+ (instancetype)sharedService;

- (void)queryBalanceWithAccount:(NSString *)accountNumber completion:(void (^)(SZTResultModel *model, NSError *error))completionBlock;

@end
