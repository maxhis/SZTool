//
//  SZTPrivacyViewController.m
//  SZTool
//
//  Created by iStar on 15/3/26.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTPrivacyViewController.h"

@interface SZTPrivacyViewController ()

@end

@implementation SZTPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIComponents];
}

- (void)loadUIComponents
{
    self.title = @"隐私声明";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"]];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];
}

@end
