//
//  AppDelegate.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "SZTHomeController.h"
#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import "RZTransitionsManager.h"
#import "RZTransitionsAnimationControllers.h"
#import "MAThemeKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupTheme];
    [self setupRZTransitionsManager];
    [self setupAVOS:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SZTHomeController *homeController = [[SZTHomeController alloc] init];
    self.window.rootViewController = homeController;
    [self.window makeKeyAndVisible];
    
    // 配置HUD的Icons
    [self setupHUD];
    
    return YES;
}

- (void)setupTheme
{
    [MAThemeKit setupThemeWithPrimaryColor:[MAThemeKit colorWithHexString:@"007cd8"]
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
    [AVOSCloud setApplicationId:kAVOSAppId clientKey:kAVOSAppKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
#ifdef PrereleaseEnviroment
    [AVAnalytics setAnalyticsEnabled:NO];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
