//
//  SZTWeizhangModel.h
//  SZTool
//
//  Created by iStar on 15/4/8.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTWeizhangModel : NSObject

/**
 *    车牌号码
 */
@property (nonatomic, copy) NSString *carNumber;

/**
 *    违法时间
 */
@property (nonatomic, copy) NSString *occurTime;

/**
 *    违法地址
 */
@property (nonatomic, copy) NSString *occurPlace;

/**
 *    违法行为
 */
@property (nonatomic, copy) NSString *violations;

/**
 *    处理标记
 */
@property (nonatomic, copy) NSString *dealFlag;

/**
 *    处理机关
 */
@property (nonatomic, copy) NSString *dealDepartment;

/**
 *    违法处理地址
 */
@property (nonatomic, copy) NSString *dealPlace;

@end
