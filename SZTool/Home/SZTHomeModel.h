//
//  SZTHomeModel.h
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SZTHomeModel : NSObject

@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subTitle;

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSString *)subTitle;

@end
