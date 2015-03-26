//
//  SZTFeedbackViewController.m
//  SZTool
//
//  Created by iStar on 15/3/25.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTFeedbackViewController.h"
#import "DTPlaceHolderTextView.h"

@interface SZTFeedbackViewController ()

@property (nonatomic, strong) DTPlaceHolderTextView *feedbackView;

@property (nonatomic, strong) UITextField *contactView;

@end

@implementation SZTFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUIComponents];
}

- (void)loadUIComponents
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendFeedBack:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _feedbackView = [[DTPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 35, DTScreenWidth - 20, 200)];
    _feedbackView.placeholder = @"您的意见和建议对我们很重要！";
    [self.view addSubview:_feedbackView];
    
    _contactView = [[UITextField alloc] initWithFrame:CGRectMake(_feedbackView.dt_left, _feedbackView.dt_bottom + 10, _feedbackView.dt_width, 44)];
    _contactView.borderStyle = UITextBorderStyleRoundedRect;
    _contactView.placeholder = @"留下邮箱或QQ以便我们进一步沟通";
    _contactView.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:_contactView];
}

- (void)sendFeedBack:(id) sender
{
    NSString *content = [_feedbackView.text dt_trim];
    if (content.length < 3)
    {
        [self.view dt_postError:@"既然来了，就说点什么吧！"];
        return;
    }
    
    [self.view dt_postLoading:@""];
    AVUserFeedbackAgent *feedbackAgent = [AVUserFeedbackAgent sharedInstance];
    [feedbackAgent postFeedbackThread:content block:^(id object, NSError *error) {
        if (error == nil) {
            [self.view dt_postSuccess:@"您的反馈我们已收到！"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
