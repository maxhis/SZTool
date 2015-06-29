//
//  SZTHomeModel.m
//  SZTool
//
//  Created by Andy on 15/6/26.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeModel.h"

@implementation SZTHomeModel

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title
{
    self = [super init];
    if (self) {
        _icon = icon;
        _title = title;
    }
    return self;
}

@end
