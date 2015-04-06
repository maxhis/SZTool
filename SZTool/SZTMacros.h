//
//  SZTMacros.h
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#ifndef SZTool_SZTMacros_h
#define SZTool_SZTMacros_h

#define kAppStoreUrl                        @"https://itunes.apple.com/cn/app/id980164721?mt=8"

// AVOS
#define kAVOSAppId                          @"qhvjl1rn8hr86rhsi9c0fa2akox7pvvib9ijicxdajzdx41p"
#define kAVOSAppKey                         @"3jftm0l9bpgpsf9pewyp9arfs8t2vvcbn9601uyixtde91ki"

// 缓存用户输入的key
#define kUserDefaultKeyGongjijinAccount     @"GongjijinAccount"
#define kUserDefaultKeyGongjijinID          @"GongjijinID"
#define kUserDefaultKeyShebaoAccount        @"ShebaoAccount"
#define kUserDefaultKeyShebaoID             @"ShebaoID"
#define kUserDefaultKeyYaohaoApplyNumber    @"YaohaoApplyNumber"
#define kUserDefaultKeyYaohaoApplyType      @"YaohaoApplyType"
#define kUserDefaultKeyWeizhangChepaiNumber @"WeizhangChepaiNumber"
#define kUserDefaultKeyWeizhangChepaiType   @"WeizhangChepaiType"
#define kUserDefaultKeyWeizhangChejiaNumber @"WeizhangChejiaNumber"
#define kUserDefaultKeyWeizhangEngineNumber @"WeizhangEngineNumber"


// 用户行为统计的key
#define kRefreshVerifyCodeGongjijin         @"刷新公积金验证码"
#define kRefreshVerifyCodeShebao            @"刷新社保验证码"
#define kRefreshVerifyCodeWeizhang          @"刷新违章验证码"
#define kShareApp                           @"分享App给好友"

#define kNavigationBarColor  [UIColor dt_colorWithHexString:@"007cd8"]

// 系统全局宏定义
#define DTScreenWidth [UIScreen mainScreen].bounds.size.width
#define DTScreenHeight [UIScreen mainScreen].bounds.size.height

// weak self strong self
#define WEAK_SELF __weak typeof(self) weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf) self = weakSelf

#define STRONG_SELF_AND_RETURN_IF_SELF_NULL     \
__strong typeof(weakSelf) self = weakSelf;      \
if (!self) { return; }                          \


////////////////////////////////////////////////////////////////////
////// 设备相关
////////////////////////////////////////////////////////////////////
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#endif
