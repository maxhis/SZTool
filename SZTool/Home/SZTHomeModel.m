//
//  SZTHomeModel.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeModel.h"

@implementation SZTHomeModel

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super init];
    if (self)
    {
        self.icon = icon;
        self.title = title;
        self.subTitle = subTitle;
    }
    return self;
}

@end
