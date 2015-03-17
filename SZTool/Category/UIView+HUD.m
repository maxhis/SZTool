//
//  UIView+HUD.m
//  Laiwang
//
//  Created by Lings on 14-3-10.
//  Copyright (c) 2014年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#define kDefaultMessageShowTime     (1.5)
#define kDefaultLoadingShowTime     (20)

static char kHUDKey;
static NSMutableDictionary * g_typeIconsDict = nil;
static DTHUDConfigBlock g_lazyConfigBlock = nil;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation UIView (DingTalkHUD)

+ (void)dt_setHUDIcon:(UIImage *)iconImg forType:(DTHUDIconType)type
{
    if (!g_typeIconsDict) {
        g_typeIconsDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    
    if (!iconImg) {
        [g_typeIconsDict removeObjectForKey:[NSNumber numberWithInt:type]];
    } else {
        [g_typeIconsDict setObject:iconImg forKey:[NSNumber numberWithInt:type]];
    }
}

+ (UIImage *)dt_HUDIconforType:(DTHUDIconType)type
{
    if (!g_typeIconsDict) {
        return nil;
    }
    
    return [g_typeIconsDict objectForKey:[NSNumber numberWithInt:type]];
}

+ (void)dt_setLazyConfigBlock:(DTHUDConfigBlock)block
{
    g_lazyConfigBlock = block;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (MBProgressHUD *)dt_HUD
{
    if (!g_typeIconsDict)
    {
        if (g_lazyConfigBlock)
        {
            g_lazyConfigBlock();
            g_lazyConfigBlock = nil;
        }
    }
    
    MBProgressHUD * hud = [self getExistHUD];
    if (!hud)
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.animationType = MBProgressHUDAnimationFade;
        hud.removeFromSuperViewOnHide = NO;
        hud.labelFont = [UIFont systemFontOfSize:16];
        hud.detailsLabelFont = [UIFont systemFontOfSize:16];
        
        objc_setAssociatedObject(self, &kHUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [self addSubview:hud];
    [self bringSubviewToFront:hud];
    
    return hud;
}

- (MBProgressHUD *)getExistHUD
{
    MBProgressHUD * hud = objc_getAssociatedObject(self, &kHUDKey);
    
    if (hud && ![hud isKindOfClass:[MBProgressHUD class]]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    
    return hud;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)dt_postMessage:(NSString *)message
{
    return [self dt_postMessage:message delay:kDefaultMessageShowTime];
}

- (void)dt_postMessage:(NSString *)message delay:(NSTimeInterval)delay
{
    if ([message length] == 0)
    {
        [self dt_cleanUp:YES];
        return;
    }
    
    NSString *title = message;
    return [self dt_postMessageWithTitle:title message:nil delay:delay];
}

- (void)dt_postMessageWithTitle:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay
{
    if ([title length] == 0 && [message length] == 0)
    {
        [self dt_cleanUp:YES];
        return;
    }
    
    MBProgressHUD * HUD = self.dt_HUD;
    UIImage * msgImg = [UIView dt_HUDIconforType:DTHUDIconMessage];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
    HUD.customView = msgImageview;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = title;
    HUD.detailsLabelText = message;
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)dt_postError:(NSString *)message
{
    return [self dt_postError:message delay:kDefaultMessageShowTime];
}

- (void)dt_postError:(NSString *)message delay:(NSTimeInterval)delay
{
    return [self dt_postErrorWithTitle:nil message:message delay:delay];
}

- (void)dt_postErrorWithTitle:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay
{
    MBProgressHUD * HUD = self.dt_HUD;
    
	UIImage * msgImg = [UIView dt_HUDIconforType:DTHUDIconError];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
	HUD.customView = msgImageview;
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = title;
    HUD.detailsLabelText = message;
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)dt_postSuccess:(NSString *)message
{
    return [self dt_postSuccess:message delay:kDefaultMessageShowTime];
}

- (void)dt_postSuccess:(NSString *)message delay:(NSTimeInterval)delay
{
    MBProgressHUD * HUD = self.dt_HUD;
    
	UIImage * msgImg = [UIView dt_HUDIconforType:DTHUDIconSuccess];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
	HUD.customView = msgImageview;
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = message;
    HUD.detailsLabelText = nil;
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)dt_postLoading:(NSString *)message
{
    return [self dt_postLoading:message delay:kDefaultLoadingShowTime];
}

- (void)dt_postLoading:(NSString *)message delay:(NSTimeInterval)delay
{
    MBProgressHUD * HUD = self.dt_HUD;
    
    HUD.customView = nil;
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = message;
    HUD.detailsLabelText = nil;
	[HUD show:YES];
    [HUD hide:YES afterDelay:delay];
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)dt_cleanUp:(BOOL)animated
{
    MBProgressHUD * HUD = [self getExistHUD];
    if (!HUD) {
        return;
    }
    
    HUD.labelText = nil;
    HUD.detailsLabelText = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:HUD];
    
    if ((fabs(HUD.alpha-0.0f) < FLT_EPSILON) || HUD.hidden) {
        return;
    }
    
    [HUD removeFromSuperview];
    [HUD sendSubviewToBack:self];
}


@end
