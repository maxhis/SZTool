//
//  SZTHomeModel.h
//  SZTool
//
//  Created by Andy on 15/6/26.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTHomeModel : NSObject

@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title;

@end
