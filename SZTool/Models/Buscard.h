//
//  Buscard.h
//  SZTool
//
//  Created by Andy on 15/8/20.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Buscard : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * title;

@end
