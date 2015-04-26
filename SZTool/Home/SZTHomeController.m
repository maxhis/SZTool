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
#import "SZTWeizhangViewController.h"

#define kCenterX DTScreenWidth/2
#define kCenterY DTScreenHeight/2 - 44

#define kEdgeMargin 10

@interface SZTHomeController ()

@property (nonatomic, strong) UIButton *gongjijinButton;
@property (nonatomic, strong) UIButton *shebaoButton;
@property (nonatomic, strong) UIButton *yaohaoButton;
@property (nonatomic, strong) UIButton *weizhangButton;
@property (nonatomic, strong) UIButton *infoButton;

/**
 *    是否查询成功
 */
@property (nonatomic, assign) BOOL querySuccess;
@end

@implementation SZTHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUIComponent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_querySuccess)
    {
        [self showPromotingAlertIfNeed];
    }
}

- (void)loadUIComponent
{
    self.title = @"深圳通";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.infoButton];
    
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
    
    _weizhangButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    _weizhangButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_weizhangButton setImage:[UIImage imageNamed:@"weizhang"] forState:UIControlStateNormal];
    [_weizhangButton setTitle:@"粤牌违章" forState:UIControlStateNormal];
    [_weizhangButton setTitleColor:textColor forState:UIControlStateNormal];
    _weizhangButton.dt_left = _shebaoButton.dt_left;
    _weizhangButton.showsTouchWhenHighlighted = YES;
    _weizhangButton.dt_top = kCenterY + kEdgeMargin;
    [self textUnderImageButton:_weizhangButton];
    [_weizhangButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_weizhangButton];
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

- (UIButton *)infoButton
{
    if (_infoButton == nil)
    {
        _infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [_infoButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoButton;
}

#pragma mark - button click event
- (void)buttonPressed:(id)sender
{
    QueryStatusCallback callback = ^void(BOOL success) {
        _querySuccess = success;
    };
    
    SZTViewController *destVC;
    if ([sender isEqual:_gongjijinButton])
    {
        destVC = [[SZTGongjijinController alloc] init];
        destVC.queryStatusCallback = callback;
    }
    else if ([sender isEqual:_shebaoButton])
    {
        destVC = [[SZTShebaoViewController alloc] init];
        destVC.queryStatusCallback = callback;
    }
    else if ([sender isEqual:_yaohaoButton])
    {
        destVC = [[SZTYaohaoViewController alloc] init];
        destVC.queryStatusCallback = callback;
    }
    else if ([sender isEqual:_weizhangButton])
    {
        destVC = [[SZTWeizhangViewController alloc] init];
        destVC.queryStatusCallback = callback;
    }
    else if ([sender isEqual:_infoButton])
    {
        destVC = [[SZTAboutViewController alloc] init];
    }
    [self.navigationController pushViewController:destVC animated:YES];
}

#pragma mark - feedback or promoting app

/**
 *    在用户成功完成一次查询后给出对话框，反馈或评分，最多展示3次，用户点击后不再出现
 */
- (void)showPromotingAlertIfNeed
{
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block NSInteger remainTimes = [[defaults objectForKey:kUserDefaultKeyRemainPromotingTime] integerValue];
    if (remainTimes > 0)
    {
        [UIAlertView showWithTitle:@"期待您的声音"
                           message:@"嘿！App用着还好么？觉得不错可以去评个分支持一下，有任何建议或意见都可以反馈给我们哦！"
                 cancelButtonTitle:@"下次吧"
                 otherButtonTitles:@[@"去评分", @"意见反馈"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              _querySuccess = false;
                              if (buttonIndex == alertView.cancelButtonIndex)
                              {
                                  [defaults setObject:@(--remainTimes) forKey:kUserDefaultKeyRemainPromotingTime];
                              }
                              else if(buttonIndex == alertView.firstOtherButtonIndex)
                              {
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
                                  [defaults setObject:@(0) forKey:kUserDefaultKeyRemainPromotingTime];
                              }
                              else if(buttonIndex == alertView.firstOtherButtonIndex + 1)
                              {
                                  AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
                                  [agent showConversations:self title:@"用户反馈" contact:nil];
                                  [defaults setObject:@(0) forKey:kUserDefaultKeyRemainPromotingTime];
                              }
                          }];
    }
}

@end
