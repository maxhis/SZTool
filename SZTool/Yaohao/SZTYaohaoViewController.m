//
//  SZTYaohaoViewController.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTYaohaoViewController.h"
#import "ActionSheetStringPicker.h"
#import "SZTYaohaoService.h"
#import "Yaohao.h"
#import "JVFloatLabeledTextField.h"
#import "BaiduAPIUtils.h"
#import "SZTYaohaoResultController.h"

static NSString *const kNoticeInfo = @"温馨提示：摇号申请编码有效期为3个月，请及时登录官网延长有效期";

@interface SZTYaohaoViewController () <UITextFieldDelegate, SZTDropdownMenuDelegate>

@property (nonatomic, strong) JVFloatLabeledTextField *applyCodeView;

@end

@implementation SZTYaohaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUIComponent];
}

- (void)loadUIComponent
{
    self.modelType = ModelTypeYaohao;
    self.title = @"汽车摇号";
    
    NSString *rightBarTitle;
    if (self.saveOnly)
    {
        rightBarTitle = @"保存";
    }
    else
    {
        rightBarTitle = @"查询";
    }
    UIBarButtonItem *queryButton = [[UIBarButtonItem alloc] initWithTitle:rightBarTitle style:UIBarButtonItemStyleDone target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = queryButton;
    
    kTextFieldWidthNormal = SCREEN_WIDTH - 2*kDividerWidth;
    
    // 申请编码
    _applyCodeView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(kDividerWidth, SCREEN_WIDTH/8, kTextFieldWidthNormal, kTextFieldHeight)];
    _applyCodeView.borderStyle = UITextBorderStyleRoundedRect;
    _applyCodeView.placeholder = @"请输入姓名或摇号申请编码";
    _applyCodeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _applyCodeView.dt_right = DTScreenWidth - kDividerWidth;
    _applyCodeView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_applyCodeView setReturnKeyType:UIReturnKeyGo];
    _applyCodeView.delegate = self;
    _applyCodeView.font = kDigitalFont;
    [self.view addSubview:_applyCodeView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_applyCodeView.dt_left, _applyCodeView.dt_bottom, kTextFieldWidthNormal, 50)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.numberOfLines = 0;
    infoLabel.text = kNoticeInfo;
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:infoLabel];
    
    if (!self.saveOnly)
    {
        [self loadDefaultData];
    }
    
    self.dropdownDelegate = self;
}

- (void)loadDefaultData
{
    if (self.model && [self.model isKindOfClass:[Yaohao class]])
    {
        Yaohao *yaohao = (Yaohao *)self.model;
        _applyCodeView.text = yaohao.applyNumber;
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _applyCodeView.text = [defaults stringForKey:kUserDefaultKeyYaohaoApplyNumber];
    }
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_applyCodeView.text forKey:kUserDefaultKeyYaohaoApplyNumber];
}

- (void)clearSavedData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:kUserDefaultKeyYaohaoApplyNumber];
    
    _applyCodeView.text = nil;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightAction
{
    if (self.saveOnly)
    {
        [self doSave];
    }
    else
    {
        [self doQuery];
    }
}

- (void)doSave
{
    if ([self validateInputs] == NO) return;
    
    UIAlertViewCompletionBlock block = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(alertView.cancelButtonIndex == buttonIndex)
        {
            UITextField *tf=[alertView textFieldAtIndex:0];
            [self saveModelWithTitle:tf.text];
        }
    };
    
    UIAlertView *alertView = [UIAlertView showWithTitle:@"保存输入的信息以便下次查询"
                                                message:nil
                                                  style:UIAlertViewStylePlainTextInput
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:@[@"取消"]
                                               tapBlock:block];
    UITextField *tf=[alertView textFieldAtIndex:0];
    tf.placeholder = @"建议输入一个有意义的名称";
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateInputs
{
    [self hideKeyboard];
    
    NSString *applyNumber = _applyCodeView.text;
    if (applyNumber.length < 2)
    {
        [self.view dt_postError:@"请输入姓名或摇号申请编码"];
        return NO;
    }
    return YES;
}

- (void)doQuery
{
    if (![self validateInputs]) return;
    
    WEAK_SELF;
    [self.view dt_postLoading:@""];
    NSString *input = _applyCodeView.text;
    [BaiduAPIUtils getYaohaoResultWithName:input doneBlock:^(NSDictionary *result, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        if (error) {
            [self.view dt_postError:error.localizedDescription];
        }
        else {
            NSInteger dispNum = [result[@"dispNum"] integerValue];
            if (dispNum == 0) {
                if ([input isDigits]) { // 输入的是申请码
                    [UIAlertView showWithTitle:@"抱歉，该编号本次未中签！" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tapBlock:nil];
                }
                else { // 输入的是姓名
                    [UIAlertView showWithTitle:@"抱歉，该申请人本次未中签！" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tapBlock:nil];
                }
            }
            else if (dispNum == 1) {
                NSArray *dispDatas = result[@"disp_data"];
                NSDictionary *data = dispDatas[0];
                NSString *issueNo  = data[@"eid"];
                NSString *year     = [issueNo substringToIndex:4];
                NSString *month    = [issueNo substringFromIndex:4];
                [UIAlertView showWithTitle:[NSString stringWithFormat:@"恭喜，您已于%@年%@月中签！", year, month] message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tapBlock:nil];
            }
            else {
                SZTYaohaoResultController *resultVC = [[SZTYaohaoResultController alloc] init];
                resultVC.displayData = result[@"disp_data"];
                [self.navigationController pushViewController:resultVC animated:YES];
            }
        }
        [self.view dt_cleanUp:YES];
    }];
}

- (void)saveModelWithTitle:(NSString *)title
{
    WEAK_SELF;
    Yaohao *yaohao = [Yaohao MR_createEntity];
    yaohao.applyNumber = _applyCodeView.text;
    yaohao.title = title;
    NSManagedObjectContext *context = yaohao.managedObjectContext;
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        if (success)
        {
            [self.view dt_postSuccess:@"保存成功"];
            [self performSelector:@selector(popSelf) withObject:nil afterDelay:2];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self rightAction];
    return YES;
}

#pragma mark - SZTDropdownMenuDelegate
- (void)configWithModel:(Yaohao *)model
{
    _applyCodeView.text = model.applyNumber;
}

@end
