//
//  SZTViewController+Feedback.h
//  
//
//  Created by Andy on 15/7/3.
//
//

#import "SZTViewController.h"
#import <MessageUI/MessageUI.h>

@interface SZTViewController (Feedback) <MFMailComposeViewControllerDelegate>
- (void)feedback;
@end
