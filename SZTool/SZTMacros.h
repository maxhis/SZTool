//
//  SZTMacros.h
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#ifndef SZTool_SZTMacros_h
#define SZTool_SZTMacros_h

#define kUserDefaultKeyGongjijinAccount     @"GongjijinAccount"
#define kUserDefaultKeyGongjijinID          @"GongjijinID"
#define kUserDefaultKeyShebaoAccount        @"ShebaoAccount"
#define kUserDefaultKeyShebaoID             @"ShebaoID"
#define kUserDefaultKeyYaohaoApplyNumber    @"YaohaoApplyNumber"
#define kUserDefaultKeyYaohaoApplyType      @"YaohaoApplyType"

// 系统全局宏定义
#define DTScreenWidth [UIScreen mainScreen].bounds.size.width
#define DTScreenHeight [UIScreen mainScreen].bounds.size.height

// weak self strong self
#define WEAK_SELF __weak typeof(self) weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf) self = weakSelf

#define STRONG_SELF_AND_RETURN_IF_SELF_NULL     \
__strong typeof(weakSelf) self = weakSelf;      \
if (!self) { return; }                          \

#endif
