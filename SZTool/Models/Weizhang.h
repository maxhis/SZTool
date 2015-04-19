//
//  Weizhang.h
//  SZTool
//
//  Created by iStar on 15/4/18.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weizhang : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * chepaiNumber;
@property (nonatomic, retain) NSString * chepaiType;
@property (nonatomic, retain) NSString * chejiaNumber;
@property (nonatomic, retain) NSString * engineNumber;

@end
