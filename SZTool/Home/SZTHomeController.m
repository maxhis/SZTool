//
//  SZTHomeController.m
//  SZTool
//
//  Created by iStar on 15/3/18.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeController.h"
#import "CNPGridMenu.h"
#import "SZTGongjijinController.h"
#import "SZTYaohaoViewController.h"
#import "SZTShebaoViewController.h"
#import "RZTransitionsManager.h"

@interface SZTHomeController () <CNPGridMenuDelegate>

@property (nonatomic, strong) CNPGridMenu *gridMenu;

@property (nonatomic, strong) CNPGridMenuItem *gongjijinItem;
@property (nonatomic, strong) CNPGridMenuItem *shebaoItem;
@property (nonatomic, strong) CNPGridMenuItem *yaohaoItem;
@property (nonatomic, strong) CNPGridMenuItem *settingsItem;

@end

@implementation SZTHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIComponet];
}

- (void)loadUIComponet
{
    self.title = @"深圳通";
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:bgView];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(DTScreenWidth/2 - 50, DTScreenHeight/2, 100, 50)];
    [menuButton addTarget:self action:@selector(showGridMenu:) forControlEvents:UIControlEventTouchUpInside];
    menuButton.layer.cornerRadius = 4;
    menuButton.backgroundColor = [UIColor dt_colorWithHexString:@"007cd8"];
    [menuButton setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:menuButton];
    
    [self initMenu];
}

- (void)initMenu
{
    _gongjijinItem = [[CNPGridMenuItem alloc] init];
    _gongjijinItem.icon = [UIImage imageNamed:@"gongjijin"];
    _gongjijinItem.title = @"公积金";
    
    _shebaoItem = [[CNPGridMenuItem alloc] init];
    _shebaoItem.icon = [UIImage imageNamed:@"shebao"];
    _shebaoItem.title = @"社保";
    
    _yaohaoItem = [[CNPGridMenuItem alloc] init];
    _yaohaoItem.icon = [UIImage imageNamed:@"yaohao"];
    _yaohaoItem.title = @"摇号";
    
    _settingsItem = [[CNPGridMenuItem alloc] init];
    _settingsItem.icon = [UIImage imageNamed:@"settings"];
    _settingsItem.title = @"设置";

    _gridMenu = [[CNPGridMenu alloc] initWithMenuItems:@[_gongjijinItem, _shebaoItem, _yaohaoItem, _settingsItem]];
    _gridMenu.delegate = self;
    
}

- (void)showGridMenu:(id)sender
{
    [self presentGridMenu:_gridMenu animated:YES completion:^{
        NSLog(@"Grid Menu Presented");
    }];
}

#pragma mark - CNPGridMenuDelegate

- (void)gridMenuDidTapOnBackground:(CNPGridMenu *)menu
{
    [self dismissGridMenuAnimated:YES completion:^{
        NSLog(@"Grid Menu Dismissed With Background Tap");
    }];
}

- (void)gridMenu:(CNPGridMenu *)menu didTapOnItem:(CNPGridMenuItem *)item
{
    [self dismissGridMenuAnimated:YES completion:^{
        NSLog(@"Grid Menu Did Tap On Item: %@", item.title);
    }];
    
    UIViewController *destVC;
    if ([item isEqual:_gongjijinItem])
    {
        destVC = [[SZTGongjijinController alloc] init];
    }
    else if ([item isEqual:_shebaoItem])
    {
        destVC = [[SZTShebaoViewController alloc] init];
    }
    else if ([item isEqual:_yaohaoItem])
    {
        destVC = [[SZTYaohaoViewController alloc] init];
    }
    else if ([item isEqual:_settingsItem])
    {
        destVC = [[SZTGongjijinController alloc] init];
    }
    destVC.title = item.title;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:destVC];
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
    [navigationController setTransitioningDelegate:[RZTransitionsManager shared]];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
