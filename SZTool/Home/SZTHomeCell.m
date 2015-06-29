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
//        UIColor *textColor = [UIColor dt_colorWithHexString:@"f0f6fc"];
//        CGFloat buttonWidth;
//        if (IS_IPHONE_6 || IS_IPHONE_6P) {
//            buttonWidth = 150;
//        } else {
//            buttonWidth = 100;
//        }
//        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
//        _button.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        [_button setTitleColor:textColor forState:UIControlStateNormal];
//        _button.showsTouchWhenHighlighted = YES;
//        _button.center = self.contentView.center;
//        _button.enabled = NO;
//        [self.contentView addSubview:_button]; 
    }
    
    return self;
}

- (void)configWithModel:(SZTHomeModel *)model
{
    [self configWithIcon:model.icon title:model.title];
}

- (void)configWithIcon:(UIImage *)icon title:(NSString *)title
{
//    [_button setImage:icon forState:UIControlStateNormal];
//    [_button setTitle:title forState:UIControlStateNormal];
//    [self textUnderImageButton:_button];
    
    self.iconView.image = icon;
    self.titleLabel.text = title;
}

/**
 *    将文字放在图片之下
 */
- (void)textUnderImageButton:(UIButton *)button
{
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

@end
