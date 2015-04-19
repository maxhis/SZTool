//
//  Gongjijin.h
//  SZTool
//
//  Created by iStar on 15/4/18.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Gongjijin : NSManagedObject

@property (nonatomic, retain) NSString * accountNumber;
@property (nonatomic, retain) NSString * identityNumber;
@property (nonatomic, retain) NSString * title;

@end
