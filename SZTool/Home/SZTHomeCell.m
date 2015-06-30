//
//  SZTHomeCell.m
//  SZTool
//
//  Created by Andy on 15/6/26.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeCell.h"
#import "SZTHomeModel.h"

@interface SZTHomeCell ()
@property (nonatomic, strong) UIButton *button;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SZTHomeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)configWithModel:(SZTHomeModel *)model
{
    [self configWithIcon:model.icon title:model.title];
}

- (void)configWithIcon:(UIImage *)icon title:(NSString *)title
{
    self.iconView.image = icon;
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor dt_colorWithHexString:@"f0f6fc"];
}

@end
