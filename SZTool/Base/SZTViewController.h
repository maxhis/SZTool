//
//  SZTViewController.h
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^QueryStatusCallback)(BOOL success);

@interface SZTViewController : UIViewController

/**
 *    查询状态回调，如果成功可以提示用户评分
 */
@property (nonatomic, strong)QueryStatusCallback queryStatusCallback;

@end
