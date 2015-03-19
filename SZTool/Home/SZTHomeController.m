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

@interface SZTHomeController () <AwesomeMenuDelegate>

@property (nonatomic, strong) AwesomeMenu *mainMenu;

@property (nonatomic, strong) AwesomeMenuItem *startItem;
@property (nonatomic, strong) AwesomeMenuItem *gongjijinItem;
@property (nonatomic, strong) AwesomeMenuItem *shebaoItem;
@property (nonatomic, strong) AwesomeMenuItem *yaohaoItem;
@property (nonatomic, strong) AwesomeMenuItem *settingsItem;

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
                                         menuItems:@[_gongjijinItem, _shebaoItem, _yaohaoItem, _settingsItem]];
    _mainMenu.delegate = self;
    _mainMenu.startPoint = CGPointMake(DTScreenWidth/2, DTScreenHeight - 30);
    _mainMenu.menuWholeAngle = M_PI;
    _mainMenu.rotateAngle = -M_PI_2;
    [self.view addSubview:_mainMenu];
}

#pragma mark - AwesomeMenuDelegate

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx;
{
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
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:destVC];
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
    [navigationController setTransitioningDelegate:[RZTransitionsManager shared]];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
