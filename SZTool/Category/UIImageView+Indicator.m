//
//  UIImageView+Indicator.m
//  SZTool
//
//  Created by iStar on 15/4/10.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "UIImageView+Indicator.h"

@implementation UIImageView (Indicator)

- (void)showIndicator
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
    indicator.center =  CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    indicator.tag = NSIntegerMax;
    [self addSubview:indicator];
    [indicator startAnimating];
}

- (void)hideIndicator
{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:NSIntegerMax];
    if (indicator)
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
}

@end
