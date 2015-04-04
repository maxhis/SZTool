//
//  SZTHomeGridController.m
//  SZTool
//
//  Created by iStar on 15/3/28.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeController.h"
#import "SZTGongjijinController.h"
#import "SZTShebaoViewController.h"
#import "SZTYaohaoViewController.h"
#import "SZTAboutViewController.h"
#import "RZTransitionsNavigationController.h"
#import "RZTransitionsManager.h"

#define kCenterX DTScreenWidth/2
#define kCenterY DTScreenHeight/2 - 44

#define kEdgeMargin 10

@interface SZTHomeController ()

@property (nonatomic, strong) UIButton *gongjijinButton;
@property (nonatomic, strong) UIButton *shebaoButton;
@property (nonatomic, strong) UIButton *yaohaoButton;
@property (nonatomic, strong) UIButton *settingsButton;

@end

@implementation SZTHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUIComponent];
}

- (void)loadUIComponent
{
    self.title = @"深圳通";
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"home_bg"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    UIColor *textColor = [UIColor dt_colorWithHexString:@"f0f6fc"];
    CGFloat buttonWidth;
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        buttonWidth = 150;
    } else {
        buttonWidth = 100;
    }
    
    _gongjijinButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    _gongjijinButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_gongjijinButton setImage:[UIImage imageNamed:@"gongjijin"] forState:UIControlStateNormal];
    [_gongjijinButton setTitle:@"公积金" forState:UIControlStateNormal];
    [_gongjijinButton setTitleColor:textColor forState:UIControlStateNormal];
    _gongjijinButton.showsTouchWhenHighlighted = YES;
    _gongjijinButton.dt_right = kCenterX - kEdgeMargin;
    _gongjijinButton.dt_bottom = kCenterY - kEdgeMargin;
    [self textUnderImageButton:_gongjijinButton];
    [_gongjijinButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_gongjijinButton];
    
    _shebaoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    _shebaoButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_shebaoButton setImage:[UIImage imageNamed:@"shebao"] forState:UIControlStateNormal];
    [_shebaoButton setTitle:@"社保" forState:UIControlStateNormal];
    [_shebaoButton setTitleColor:textColor forState:UIControlStateNormal];
    _shebaoButton.showsTouchWhenHighlighted = YES;
    _shebaoButton.dt_left = kCenterX + kEdgeMargin;
    _shebaoButton.dt_bottom = kCenterY - kEdgeMargin;
    [self textUnderImageButton:_shebaoButton];
    [_shebaoButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_shebaoButton];
    
    _yaohaoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    _yaohaoButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_yaohaoButton setImage:[UIImage imageNamed:@"yaohao"] forState:UIControlStateNormal];
    [_yaohaoButton setTitle:@"汽车摇号" forState:UIControlStateNormal];
    [_yaohaoButton setTitleColor:textColor forState:UIControlStateNormal];
    _yaohaoButton.dt_left = _gongjijinButton.dt_left;
    _yaohaoButton.showsTouchWhenHighlighted = YES;
    _yaohaoButton.dt_top = kCenterY + kEdgeMargin;
    [self textUnderImageButton:_yaohaoButton];
    [_yaohaoButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_yaohaoButton];
    
    _settingsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    _settingsButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_settingsButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [_settingsButton setTitle:@"关于" forState:UIControlStateNormal];
    [_settingsButton setTitleColor:textColor forState:UIControlStateNormal];
    _settingsButton.dt_left = _shebaoButton.dt_left;
    _settingsButton.showsTouchWhenHighlighted = YES;
    _settingsButton.dt_top = kCenterY + kEdgeMargin;
    [self textUnderImageButton:_settingsButton];
    [_settingsButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_settingsButton];
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

#pragma mark - button click event
- (void)buttonPressed:(id)sender
{
    UIViewController *destVC;
    if ([sender isEqual:_gongjijinButton])
    {
        destVC = [[SZTGongjijinController alloc] init];
    }
    else if ([sender isEqual:_shebaoButton])
    {
        destVC = [[SZTShebaoViewController alloc] init];
    }
    else if ([sender isEqual:_yaohaoButton])
    {
        destVC = [[SZTYaohaoViewController alloc] init];
    }
    else if ([sender isEqual:_settingsButton])
    {
        destVC = [[SZTAboutViewController alloc] init];
    }
    
    [self.navigationController pushViewController:destVC animated:YES];
}

@end
