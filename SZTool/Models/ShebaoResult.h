//
//  ShebaoResult.h
//  SZTool
//
//  Created by Andy on 15/8/7.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShebaoResult : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * yanglaoBalance;
@property (nonatomic, retain) NSString * yiliaoBalance;

@end
