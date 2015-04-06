//
//  SZTCarTypeManager.m
//  SZTool
//
//  Created by iStar on 15/4/6.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTCarTypeManager.h"

@implementation SZTCarTypeManager

static NSArray *displayNames;
static NSArray *values;

+ (instancetype)sharedManager
{
    static SZTCarTypeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SZTCarTypeManager alloc] init];
        displayNames = @[@"大型汽车", @"小型汽车", @"境外汽车", @"外籍汽车", @"两、三轮摩托车", @"境外摩托车", @"外籍摩托车", @"挂车", @"教练车", @"临时入境汽车", @"临时入境摩托车", @"临时行驶汽车", @"公安警车", @"香港入境车", @"澳门入境车", @"其它"];
        values       = @[@"01",      @"02",     @"05",      @"06",      @"07",          @"11",        @"12",       @"15",  @"16",    @"20",         @"21",             @"22",         @"23",    @"26",         @"27",       @"99"];
    });
    return manager;
}

- (NSArray *)displayNames
{
    return displayNames;
}

- (NSString *)valueForName:(NSString *)name
{
    NSUInteger index = [displayNames indexOfObject:name];
    if (index != NSNotFound)
    {
        return values[index];
    }
    
    return nil;
}

@end
