//
//  GongjijinResult.h
//  SZTool
//
//  Created by Andy on 15/8/7.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GongjijinResult : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * balance;
@property (nonatomic, retain) NSString * transferBalance;
@property (nonatomic, retain) NSDate * updatedAt;

@end
