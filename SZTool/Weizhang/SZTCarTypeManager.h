//
//  SZTCarTypeManager.h
//  SZTool
//
//  Created by iStar on 15/4/6.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTCarTypeManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSArray *displayNames;

- (NSString *)valueForName:(NSString *)name;

@end
