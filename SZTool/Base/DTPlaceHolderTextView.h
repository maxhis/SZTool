//
//  DTPlaceHolderTextView.h
//  DingTalk
//
//  Created by iStar on 15/1/4.
//  Copyright (c) 2015年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
