//
//  SZTViewController+Feedback.m
//  
//
//  Created by Andy on 15/7/3.
//
//

#import "SZTViewController+Feedback.h"
#import "SZTDeviceUtil.h"

@implementation SZTViewController (Feedback)

- (void)feedback
{
    if ([MFMailComposeViewController canSendMail]) {
        [self emailFeedback];
    }
    else {
        AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
        [agent showConversations:self title:@"用户反馈" contact:nil];
    }
}

- (void)emailFeedback
{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    [mailer setSubject:@"用户反馈"];
    
    NSArray *toRecipients = @[@"me@15tar.com"];
    [mailer setToRecipients:toRecipients];
    
    NSString *emailBody = [NSString stringWithFormat:@"请在此输入您的反馈意见。\n\n-----------\n%@", [self userInfo]];
    [mailer setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:mailer animated:YES completion:nil];
}

- (NSString *)userInfo
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *systemVersion = [currentDevice systemVersion];
    
    return [NSString stringWithFormat:@"%@ %@ %@", APP_VERSION, [SZTDeviceUtil deviceModelName], systemVersion];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            [self.view dt_postSuccess:@"多谢反馈"];
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
