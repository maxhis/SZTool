//
//  SZTHomeController.m
//  SZTool
//
//  Created by iStar on 15/3/18.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeController.h"
#import "SZTGongjijinController.h"
#import "SZTYaohaoViewController.h"
#import "SZTShebaoViewController.h"
#import "RZTransitionsManager.h"
#import "AwesomeMenu.h"
#import "RZTransitionsNavigationController.h"

@interface SZTHomeController () <AwesomeMenuDelegate>

// menus
@property (nonatomic, strong) AwesomeMenu *mainMenu;
@property (nonatomic, strong) AwesomeMenuItem *startItem;
@property (nonatomic, strong) AwesomeMenuItem *gongjijinItem;
@property (nonatomic, strong) AwesomeMenuItem *shebaoItem;
@property (nonatomic, strong) AwesomeMenuItem *yaohaoItem;
@property (nonatomic, strong) AwesomeMenuItem *settingsItem;

// labels
@property (nonatomic, strong) UILabel *gongjijinLabel;
@property (nonatomic, strong) UILabel *shebaoLabel;
@property (nonatomic, strong) UILabel *yaohaoLabel;
@property (nonatomic, strong) UILabel *settingsLabel;

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
    
    [self initMenu];
    [self initLabels];
}

- (void)initMenu
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    _gongjijinItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    _shebaoItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    _yaohaoItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                           highlightedImage:storyMenuItemImagePressed
                                               ContentImage:starImage
                                    highlightedContentImage:nil];
    _settingsItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                        highlightedImage:storyMenuItemImagePressed
                                            ContentImage:starImage
                                 highlightedContentImage:nil];
    
    // the start item, similar to "add" button of Path
    _startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];

    _mainMenu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds
                                         startItem:_startItem
                                         menuItems:@[_gongjijinItem, _shebaoItem, _yaohaoItem/*, _settingsItem*/]];
    _mainMenu.delegate = self;
    _mainMenu.startPoint = CGPointMake(DTScreenWidth/2, DTScreenHeight - 30);
    _mainMenu.menuWholeAngle = M_PI_4 * 3;
    _mainMenu.rotateAngle = -M_PI_4 / 2 * 3;
    [self.view addSubview:_mainMenu];
}

- (void)initLabels
{
    _gongjijinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _gongjijinLabel.textAlignment = NSTextAlignmentCenter;
    _gongjijinLabel.text = @"公积金";
    
    _shebaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _shebaoLabel.textAlignment = NSTextAlignmentCenter;
    _shebaoLabel.text = @"社保";
    
    _yaohaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _yaohaoLabel.textAlignment = NSTextAlignmentCenter;
    _yaohaoLabel.text = @"汽车摇号";
    
    _settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _settingsLabel.textAlignment = NSTextAlignmentCenter;
    _settingsLabel.text = @"设置";
}

- (void)showLabels
{
    _gongjijinLabel.dt_centerX = _gongjijinItem.dt_centerX;
    _gongjijinLabel.dt_top = _gongjijinItem.dt_bottom;
    [self.view addSubview:_gongjijinLabel];
    
    _shebaoLabel.dt_centerX = _shebaoItem.dt_centerX;
    _shebaoLabel.dt_top = _shebaoItem.dt_bottom;
    [self.view addSubview:_shebaoLabel];
    
    _yaohaoLabel.dt_centerX = _yaohaoItem.dt_centerX;
    _yaohaoLabel.dt_top = _yaohaoItem.dt_bottom;
    [self.view addSubview:_yaohaoLabel];
    
    _settingsLabel.dt_centerX = _settingsItem.dt_centerX;
    _settingsLabel.dt_top = _settingsItem.dt_bottom;
//    [self.view addSubview:_settingsLabel];
}

- (void)hideLabels
{
    [_gongjijinLabel removeFromSuperview];
    [_shebaoLabel removeFromSuperview];
    [_yaohaoLabel removeFromSuperview];
    [_settingsLabel removeFromSuperview];
}

#pragma mark - AwesomeMenuDelegate

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx;
{
    [self hideLabels];
    
    AwesomeMenuItem *item = menu.menuItems[idx];
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
    
    RZTransitionsNavigationController *navigationController = [[RZTransitionsNavigationController alloc] initWithRootViewController:destVC];
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
    [navigationController setTransitioningDelegate:[RZTransitionsManager shared]];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{
    [self showLabels];
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    [self hideLabels];
}

@end
