//
//  SZTGongjijinViewController.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTGongjijinController.h"
#import "SZTGongjijinService.h"
#import "SZTResultModel.h"
#import "SZTResultListController.h"
#import "Gongjijin.h"
#import "JVFloatLabeledTextField.h"

@interface SZTGongjijinController () <UITextFieldDelegate,SZTDropdownMenuDelegate>

@property (strong, nonatomic) JVFloatLabeledTextField *idView;
@property (strong, nonatomic) JVFloatLabeledTextField *accountView;
@property (strong, nonatomic) JVFloatLabeledTextField *codeView;
@property (strong, nonatomic) UIImageView *codeImageView;
@property (strong, nonatomic) UIButton *queryBtn;

/**
 *    从结果页返回时是否弹出保存输入信息的提示框
 */
@property (assign, nonatomic) BOOL shouldShowSaveAlert;

@end

@implementation SZTGongjijinController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadUIComponent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadVerifyCode:nil];
    
    if (self.shouldShowSaveAlert) {
        // 保存输入的信息
        [self showSaveAlertIfNeededWithIdentity:_accountView.text
                                      saveBlock:^(NSString *title) {
                                          [self saveModelWithTitle:title];
                                      }];
    }
}

- (void)loadUIComponent
{
    self.modelType = ModelTypeGongjijin;
    
    self.title = @"公积金";
    
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

    kTextFieldWidthNormal = SCREEN_WIDTH - 2 * kDividerWidth;
    kTextFieldWidthShort = kTextFieldWidthNormal / 2;
    NSInteger tag = 0;
    
    // 公积金账号
    _accountView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(kDividerWidth, SCREEN_WIDTH/8, kTextFieldWidthNormal, kTextFieldHeight)];
    _accountView.borderStyle = UITextBorderStyleRoundedRect;
    _accountView.keyboardType = UIKeyboardTypeNumberPad;
    _accountView.placeholder = @"公积金账号，11位数字";
    _accountView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _accountView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_accountView setReturnKeyType:UIReturnKeyNext];
    _accountView.delegate = self;
    _accountView.tag = tag++;
    _accountView.font = kDigitalFont;
    [self.view addSubview:_accountView];
    
    // 身份证号
    _idView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_accountView.dt_left, _accountView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _idView.borderStyle = UITextBorderStyleRoundedRect;
    _idView.placeholder = @"身份证号";
    _idView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_idView setReturnKeyType:UIReturnKeyNext];
    _idView.delegate = self;
    _idView.tag = tag++;
    _idView.font = kDigitalFont;
    [self.view addSubview:_idView];
    
    // 验证码
    if (!self.saveOnly)
    {
        [self setupVerifyCode:tag];
        [self loadDefaultData];
    }
    
    self.dropdownDelegate = self;
}

- (void)setupVerifyCode:(NSInteger)tag
{
    _codeView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_accountView.dt_left, _idView.dt_bottom + kTopEdge, kTextFieldWidthShort, kTextFieldHeight)];
    _codeView.borderStyle = UITextBorderStyleRoundedRect;
    _codeView.keyboardType = UIKeyboardTypeNumberPad;
    _codeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_codeView setReturnKeyType:UIReturnKeyGo];
    _codeView.delegate = self;
    _codeView.tag = tag++;
    _codeView.placeholder = @"验证码";
    _codeView.font = kDigitalFont;
    [self.view addSubview:_codeView];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_codeView.dt_right + kDividerWidth, _codeView.dt_top, kTextFieldWidthShort - kDividerWidth, kTextFieldHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadVerifyCode:)];
    _codeImageView.userInteractionEnabled = YES;
    [_codeImageView addGestureRecognizer:tap];
    [self.view addSubview:_codeImageView];
}

- (void)loadDefaultData
{
    // 加载传入的数据
    if (self.model)
    {
        Gongjijin *gongjijin = (Gongjijin *)self.model;
        _accountView.text = gongjijin.accountNumber;
        _idView.text = gongjijin.identityNumber;
    }
    else // 加载缓存的数据
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _accountView.text = [defaults stringForKey:kUserDefaultKeyGongjijinAccount];
        _idView.text = [defaults stringForKey:kUserDefaultKeyGongjijinID];
    }
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountView.text forKey:kUserDefaultKeyGongjijinAccount];
    [defaults setObject:_idView.text forKey:kUserDefaultKeyGongjijinID];
}

- (void)clearSavedData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:kUserDefaultKeyGongjijinAccount];
    [defaults setObject:@"" forKey:kUserDefaultKeyGongjijinID];
    
    _accountView.text = nil;
    _idView.text = nil;
}

- (void)loadVerifyCode:(id) sender
{
    if (sender) {
        [AVAnalytics event:kRefreshVerifyCodeGongjijin]; // 通知服务器一个验证码点击事件。
    }
    
    [self.codeImageView showIndicator];
    self.codeImageView.image = nil;
    WEAK_SELF;
    [[SZTGongjijinService sharedService] fetchVerifyCodeImageWithCompletion:^(UIImage *verifyCodeImage, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        if (!error)
        {
            [self.codeImageView hideIndicator];
            self.codeImageView.image = verifyCodeImage;
        }
    }];
}

- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateInputs
{
    [self.view endEditing:YES];
    
    NSString *account = _accountView.text;
    if (!account || account.length != 11)
    {
        [self.view dt_postError:@"请输入正确的公积金账号"];
        return NO;
    }
    
    NSString *idNumber = _idView.text;
    if (!idNumber || (idNumber.length != 15 && idNumber.length != 18))
    {
        [self.view dt_postError:@"请输入正确的身份证号"];
        return NO;
    }
    
    if (!self.saveOnly)
    {
        NSString *code = _codeView.text;
        if (!code || code.length != 4)
        {
            [self.view dt_postError:@"请输入正确的验证码"];
            return NO;
        }
    }
    
    return YES;
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

- (void)doQuery
{
    if ([self validateInputs] == NO) return;
    
    [self.view dt_postLoading:nil];
    WEAK_SELF;
    [[SZTGongjijinService sharedService] queryBalanceWithAccount:_accountView.text
                                                        IDNumber:_idView.text
                                                      verifyCode:_codeView.text
                                                      completion:^(SZTResultModel *model, NSError *error) {
                                                          STRONG_SELF_AND_RETURN_IF_SELF_NULL;
                                                          if (error)
                                                          {
                                                              [self.view dt_postError:error.localizedDescription delay:3];
                                                          }
                                                          else
                                                          {
                                                              [self.view dt_cleanUp:YES];
                                                              if (model.success)
                                                              {
                                                                  [self saveUserData];
                                                                  SZTResultListController *resultVC = [[SZTResultListController alloc] initWithResultType:ResultTypeGongjijin account:_accountView.text];
                                                                  resultVC.dataSource = model.message;
                                                                  [self.navigationController pushViewController:resultVC animated:YES];
                                                                  self.shouldShowSaveAlert = YES;
                                                                  
                                                                  // 通知首页查询成功
                                                                  if (self.queryStatusCallback)
                                                                  {
                                                                      self.queryStatusCallback(YES);
                                                                  }
                                                              }
                                                              else
                                                              {
                                                                  [self.view dt_postError:model.message delay:3];
                                                                  [self loadVerifyCode:nil];
                                                              }
                                                          }
                                                          self.codeView.text = nil;
                                                      }];
}

- (void)saveModelWithTitle:(NSString *)title
{
    WEAK_SELF;
    Gongjijin *gongjijin = [Gongjijin MR_createEntity];
    gongjijin.accountNumber = _accountView.text;
    gongjijin.identityNumber = _idView.text;
    gongjijin.title = title;
    NSManagedObjectContext *context = gongjijin.managedObjectContext;
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
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
    {
        [self rightAction];
    }
    else
    {
        [view becomeFirstResponder];
    }
    
    return YES;
}

// 转换成全大写字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    // Check if the added string contains lowercase characters.
    // If so, those characters are replaced by uppercase characters.
    // But this has the effect of losing the editing point
    // (only when trying to edit with lowercase characters),
    // because the text of the UITextField is modified.
    // That is why we only replace the text when this is really needed.
    NSRange lowercaseCharRange;
    lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    
    return YES;
}

#pragma mark - SZTInputViewControllerProtocol
- (void)configWithModel:(Gongjijin *)gongjijin
{
    self.accountView.text = gongjijin.accountNumber;
    self.idView.text = gongjijin.identityNumber;
}

@end
