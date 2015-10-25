//
//  SZTShebaoViewController.m
//  SZTool
//
//  Created by iStar on 15/3/17.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTShebaoViewController.h"
#import "SZTShebaoService.h"
#import "SZTResultListController.h"
#import "Shebao.h"
#import "JVFloatLabeledTextField.h"

@interface SZTShebaoViewController () <UITextFieldDelegate,SZTDropdownMenuDelegate>
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

@implementation SZTShebaoViewController

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
    self.modelType = ModelTypeShebao;
    self.title = @"社保";
    
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
    
    // 电脑号
    _accountView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(kDividerWidth, DTScreenHeight/8, kTextFieldWidthNormal, kTextFieldHeight)];
    _accountView.borderStyle = UITextBorderStyleRoundedRect;
    _accountView.keyboardType = UIKeyboardTypeNumberPad;
    _accountView.placeholder = @"电脑号，7位或9位数字";
    _accountView.dt_right = DTScreenWidth - kDividerWidth;
    _accountView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _accountView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountView.delegate = self;
    _accountView.tag = tag++;
    _accountView.returnKeyType = UIReturnKeyNext;
    _accountView.font = kDigitalFont;
    [self.view addSubview:_accountView];

    
    // 身份证号
    _idView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_accountView.dt_left, _accountView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _idView.borderStyle = UITextBorderStyleRoundedRect;
    _idView.placeholder = @"身份证号";
    _idView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _idView.delegate = self;
    _idView.tag = tag++;
    _idView.returnKeyType = UIReturnKeyNext;
    _idView.font = kDigitalFont;
    [self.view addSubview:_idView];
    
    // 验证码
    if (!self.saveOnly)
    {
        [self setupVerifyCode:tag];
    }
    
    self.dropdownDelegate = self;
}

- (void)setupVerifyCode:(NSInteger)viewTag
{
    _codeView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_accountView.dt_left, _idView.dt_bottom + kTopEdge, kTextFieldWidthShort, kTextFieldHeight)];
    _codeView.borderStyle = UITextBorderStyleRoundedRect;
    _codeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_codeView setReturnKeyType:UIReturnKeyGo];
    _codeView.delegate = self;
    _codeView.keyboardType = UIKeyboardTypeNumberPad;
    _codeView.tag = viewTag++;
    _codeView.font = kDigitalFont;
    _codeView.placeholder = @"验证码";
    [self.view addSubview:_codeView];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_codeView.dt_right + kDividerWidth, _codeView.dt_top, kTextFieldWidthShort - kDividerWidth, kTextFieldHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadVerifyCode:)];
    _codeImageView.userInteractionEnabled = YES;
    [_codeImageView addGestureRecognizer:tap];
    [self.view addSubview:_codeImageView];
    
    [self loadDefaultData];
}

- (void)loadDefaultData
{
    if (self.model && [self.model isKindOfClass:[Shebao class]])
    {
        Shebao *shebao = (Shebao *)self.model;
        _accountView.text = shebao.accountNumber;
        _idView.text = shebao.identityNumber;
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _accountView.text = [defaults stringForKey:kUserDefaultKeyShebaoAccount];
        _idView.text = [defaults stringForKey:kUserDefaultKeyShebaoID];
    }
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountView.text forKey: kUserDefaultKeyShebaoAccount];
    [defaults setObject:_idView.text forKey: kUserDefaultKeyShebaoID];
}

- (void)clearSavedData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey: kUserDefaultKeyShebaoAccount];
    [defaults setObject:@"" forKey: kUserDefaultKeyShebaoID];
    
    _accountView.text = nil;
    _idView.text = nil;
}

- (void)loadVerifyCode:(id) sender
{
    if (sender) {
        [AVAnalytics event:kRefreshVerifyCodeShebao]; // 通知服务器一个验证码点击事件。
    }
    
    self.codeImageView.image = nil;
    [self.codeImageView showIndicator];
    WEAK_SELF;
    [[SZTShebaoService sharedService] fetchVerifyCodeImageWithCompletion:^(UIImage *verifyCodeImage, NSError *error) {
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

- (BOOL)validateInputs
{
    [self.view endEditing:YES];
    
    NSString *account = _accountView.text;
    if (!account || (account.length != 9 && account.length != 7))
    {
        [self.view dt_postError:@"请输入正确的电脑号"];
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

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doQuery
{
    if ([self validateInputs] == NO) return;
    
    WEAK_SELF;
    [self.view dt_postLoading:nil];
    [[SZTShebaoService sharedService] queryBalanceWithAccount:_accountView.text
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
                                                              if (model.success)
                                                              {
                                                                  [self.view dt_cleanUp:YES];
                                                                  [self saveUserData];
                                                                  SZTResultListController *resultVC = [[SZTResultListController alloc] initWithResultType:ResultTypeShebao account:_accountView.text];
                                                                  resultVC.dataSource = model.message;
                                                                  resultVC.title = @"参保情况";
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
    Shebao *shebao = [Shebao MR_createEntity];
    shebao.accountNumber = _accountView.text;
    shebao.identityNumber = _idView.text;
    shebao.title = title;
    NSManagedObjectContext *context = shebao.managedObjectContext;
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

#pragma mark - DropdownDelegate
- (void)configWithModel:(Shebao *)model
{
    _accountView.text = model.accountNumber;
    _idView.text = model.identityNumber;
}

@end
