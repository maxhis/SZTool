//
//  UIView+HUD.h
//  SZTool
//
//  Created by iStar on 15/3/19.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


typedef enum {
    DTHUDIconMessage,
    DTHUDIconSuccess,
    DTHUDIconError,
} DTHUDIconType;


typedef void (^DTHUDConfigBlock)(void);

/**
 *  在UIView中展示HUD
 */
@interface UIView (DingTalkHUD)

@property (nonatomic, strong, readonly) MBProgressHUD * dt_HUD;


/**
 *  为不同的HUD类型配置不同的icon
 *
 *  @param iconImg 图片icon
 *  @param type    HUD类型
 */
+ (void)dt_setHUDIcon:(UIImage *)iconImg forType:(DTHUDIconType)type;

+ (UIImage *)dt_HUDIconforType:(DTHUDIconType)type;


/**
 *  可以采用Block的方式来延迟配置icons
 *
 *  @param block 普通的block，里面包含配置hud icons的代码
 */
+ (void)dt_setLazyConfigBlock:(DTHUDConfigBlock)block;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  展示一个普通的HUD提示
 *
 *  @param message 提示的内容
 */
- (void)dt_postMessage:(NSString *)message;
- (void)dt_postMessage:(NSString *)message delay:(NSTimeInterval)delay;
- (void)dt_postMessageWithTitle:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  展示一个错误icon的HUD提示
 *
 *  @param message 提示的内容
 */
- (void)dt_postError:(NSString *)message;
- (void)dt_postError:(NSString *)message delay:(NSTimeInterval)delay;
- (void)dt_postErrorWithTitle:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  展示一个对勾icon的HUD提示
 *
 *  @param message 提示的内容
 */
- (void)dt_postSuccess:(NSString *)message;
- (void)dt_postSuccess:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  展示一个HUD式的loading
 *
 *  @param message 提示的内容
 */
- (void)dt_postLoading:(NSString *)message;
- (void)dt_postLoading:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  清除HUD的展示
 *
 *  @param animated 是否带动画
 */
- (void)dt_cleanUp:(BOOL)animated;


@end
