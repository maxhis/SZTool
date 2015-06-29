//
//  AppDelegate.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import "RZTransitionsManager.h"
#import "RZTransitionsAnimationControllers.h"
#import "MAThemeKit.h"
#import "SZTHomeController.h"
#import "RZTransitionsNavigationController.h"
#import "AVOSCloudCrashReporting.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SZTHomeCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupTheme];
    [self setupRZTransitionsManager];
    [self setupAVOS:launchOptions];
    [self checkPromotingTime];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SZTHomeCollectionViewController *homeController = [[SZTHomeCollectionViewController alloc] init];
    RZTransitionsNavigationController *navigationController = [[RZTransitionsNavigationController alloc] initWithRootViewController:homeController];
    [navigationController setTransitioningDelegate:[RZTransitionsManager shared]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 配置HUD的Icons
    [self setupHUD];
    
    // 存储相关，同时启用iCloud
    [MagicalRecord setupCoreDataStackWithiCloudContainer:kPersistentiCloudContainer
                                          contentNameKey:kPersistentiCloudContentNameKey
                                         localStoreNamed:kPersistentLocalDatabaseName
                                 cloudStorePathComponent:nil];
    
    return YES;
}

- (void)setupTheme
{
    [MAThemeKit setupThemeWithPrimaryColor:kNavigationBarColor
                            secondaryColor:[UIColor whiteColor]
                                  fontName:@"HelveticaNeue-Light"
                            lightStatusBar:YES];
}

- (void)setupHUD
{
    [UIView dt_setLazyConfigBlock:^{
        [UIView dt_setHUDIcon:[UIImage imageNamed:@"common_hud_success"] forType:DTHUDIconSuccess];
        [UIView dt_setHUDIcon:[UIImage imageNamed:@"common_hud_error"] forType:DTHUDIconError];
    }];
}

- (void)setupRZTransitionsManager
{
    id<RZAnimationControllerProtocol> presentDismissAnimationController = [[RZZoomAlphaAnimationController alloc] init];
    id<RZAnimationControllerProtocol> pushPopAnimationController = [[RZZoomBlurAnimationController alloc] init];
    [[RZTransitionsManager shared] setDefaultPresentDismissAnimationController:presentDismissAnimationController];
    [[RZTransitionsManager shared] setDefaultPushPopAnimationController:pushPopAnimationController];
}

- (void)setupAVOS:(NSDictionary *)launchOptions
{
#ifdef PrereleaseEnviroment
    [AVAnalytics setAnalyticsEnabled:NO];
#else
    // Enable Crash Reporting
    [AVOSCloudCrashReporting enable];
#endif
    
    [AVOSCloud setApplicationId:kAVOSAppId clientKey:kAVOSAppKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

/**
 *    检查是不是新版本，如果是则重置可弹框的次数
 */
- (void)checkPromotingTime
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CGFloat currentVersion = [infoDic[@"CFBundleShortVersionString"] floatValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat lastVersion = [[defaults objectForKey:kUserDefaultKeyLastVersion] floatValue];
    if (currentVersion > lastVersion)
    {
        [defaults setObject:@(currentVersion) forKey:kUserDefaultKeyLastVersion];
        [defaults setObject:@(kMaxPromotingTime) forKey:kUserDefaultKeyRemainPromotingTime];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

@end
