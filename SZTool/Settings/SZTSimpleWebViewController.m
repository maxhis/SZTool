//
//  SZTPrivacyViewController.m
//  SZTool
//
//  Created by iStar on 15/3/26.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTSimpleWebViewController.h"

@interface SZTSimpleWebViewController ()

@end

@implementation SZTSimpleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIComponents];
}

- (void)loadUIComponents
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.path ofType:@"html"]];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

@end
