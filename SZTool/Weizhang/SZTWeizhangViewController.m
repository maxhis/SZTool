//
//  SZTWeizhangViewController.m
//  SZTool
//
//  Created by iStar on 15/4/6.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTWeizhangViewController.h"
#import "SZTWeizhangService.h"
#import "SZTCarTypeManager.h"
#import "ActionSheetStringPicker.h"
#import "SZTWeizhangResultController.h"
#import "Weizhang.h"
#import "RNBlurModalView.h"
#import "JVFloatLabeledTextField.h"

@interface SZTWeizhangViewController () <UITextFieldDelegate,SZTDropdownMenuDelegate>

/**
 *    车牌号码
 */
@property (nonatomic, strong) JVFloatLabeledTextField *chepaiNumberView;
/**
 *    车牌类型
 */
@property (nonatomic, strong) JVFloatLabeledTextField *chepaiTypeView;
/**
 *    车辆识别代号
 */
@property (nonatomic, strong) JVFloatLabeledTextField *chejiaNumberView;
/**
 *    机动车登记证书编号
 */
@property (nonatomic, strong) JVFloatLabeledTextField *engineNumberView;
// 验证码
@property (nonatomic, strong) JVFloatLabeledTextField *codeView;
@property (nonatomic, strong) UIImageView *codeImageView;

// 弹出图片引导用户的button
@property (nonatomic, strong) UIButton *chejiaInfoBtn;
@property (nonatomic, strong) UIButton *engineInfoBtn;

/**
 *    从结果页返回时是否弹出保存输入信息的提示框
 */
@property (assign, nonatomic) BOOL shouldShowSaveAlert;

@end

@implementation SZTWeizhangViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUIComponets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadVerifyCode:nil];
    
    if (self.shouldShowSaveAlert) {
        // 保存输入的信息
        [self showSaveAlertIfNeededWithIdentity:_chepaiNumberView.text
                                      saveBlock:^(NSString *title) {
                                          [self saveModelWithTitle:title];
                                      }];
    }
}

- (void)loadUIComponets
{
    self.modelType = ModelTypeWeizhang;
    self.title = @"粤牌全国违章";
    
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
    
    // 车牌号
    _chepaiNumberView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(kDividerWidth, DTScreenHeight/8, kTextFieldWidthNormal, kTextFieldHeight)];
    _chepaiNumberView.borderStyle = UITextBorderStyleRoundedRect;
    _chepaiNumberView.placeholder = @"车牌号 粤";
    _chepaiNumberView.dt_right = DTScreenWidth - kDividerWidth;
    _chepaiNumberView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _chepaiNumberView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_chepaiNumberView setReturnKeyType:UIReturnKeyNext];
    _chepaiNumberView.delegate = self;
    _chepaiNumberView.tag = tag++;
    _chepaiNumberView.font = kDigitalFont;
    [self.view addSubview:_chepaiNumberView];
    
    // 车牌类型
    _chepaiTypeView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_chepaiNumberView.dt_left, _chepaiNumberView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _chepaiTypeView.borderStyle = UITextBorderStyleRoundedRect;
    _chepaiTypeView.enabled = NO;
    _chepaiTypeView.text = [SZTCarTypeManager sharedManager].displayNames[1]; // 默认选中小汽车
    _chepaiTypeView.font = kDigitalFont;
    _chepaiTypeView.placeholder = @"车牌类型";
    [self.view addSubview:_chepaiTypeView];
    
    UIButton *maskButton = [[UIButton alloc] initWithFrame:_chepaiTypeView.frame];
    [maskButton addTarget:self action:@selector(showCarTypePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maskButton];
    
    // 车辆识别代号（后6位）
    _chejiaNumberView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_chepaiNumberView.dt_left, _chepaiTypeView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _chejiaNumberView.borderStyle = UITextBorderStyleRoundedRect;
    _chejiaNumberView.keyboardType = UIKeyboardTypeNumberPad;
    _chejiaNumberView.placeholder = @"车辆识别代号后6位";
    _chejiaNumberView.dt_right = DTScreenWidth - kDividerWidth;
    _chejiaNumberView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _chejiaNumberView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_chejiaNumberView setReturnKeyType:UIReturnKeyNext];
    _chejiaNumberView.delegate = self;
    _chejiaNumberView.tag = tag++;
    _chejiaNumberView.font = kDigitalFont;
    [self.view addSubview:_chejiaNumberView];
    
    _chejiaInfoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [_chejiaInfoBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _chejiaInfoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    _chejiaNumberView.rightView = _chejiaInfoBtn;
    _chejiaNumberView.rightViewMode = UITextFieldViewModeAlways;
    
    // 机动车登记证书编号(后7位)
    _engineNumberView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_chepaiNumberView.dt_left, _chejiaNumberView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _engineNumberView.borderStyle = UITextBorderStyleRoundedRect;
    _engineNumberView.keyboardType = UIKeyboardTypeNumberPad;
    _engineNumberView.placeholder = @"机动车登记证书编号后7位";
    _engineNumberView.dt_right = DTScreenWidth - kDividerWidth;
    _engineNumberView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _engineNumberView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_engineNumberView setReturnKeyType:UIReturnKeyNext];
    _engineNumberView.delegate = self;
    _engineNumberView.tag = tag++;
    _engineNumberView.font = kDigitalFont;
    [self.view addSubview:_engineNumberView];
    
    _engineInfoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [_engineInfoBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _engineInfoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    _engineNumberView.rightView = _engineInfoBtn;
    _engineNumberView.rightViewMode = UITextFieldViewModeAlways;
    
    // 验证码
    if (!self.saveOnly)
    {
        [self setupVerifyCode:tag];
        [self loadUserDefaults];
    }
    
    self.dropdownDelegate = self;
}

- (void)setupVerifyCode:(NSInteger)tag
{
    _codeView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_chepaiNumberView.dt_left, _engineNumberView.dt_bottom + kTopEdge, kTextFieldWidthShort, kTextFieldHeight)];
    _codeView.borderStyle = UITextBorderStyleRoundedRect;
    _codeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeView.keyboardType = UIKeyboardTypeNumberPad;
    [_codeView setReturnKeyType:UIReturnKeyGo];
    _codeView.delegate = self;
    _codeView.tag = tag++;
    _codeView.font = kDigitalFont;
    _codeView.placeholder = @"验证码";
    [self.view addSubview:_codeView];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_codeView.dt_right + kDividerWidth, _codeView.dt_top, kTextFieldWidthShort - kDividerWidth, kTextFieldHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadVerifyCode:)];
    _codeImageView.userInteractionEnabled = YES;
    [_codeImageView addGestureRecognizer:tap];
    [self.view addSubview:_codeImageView];
}

- (void)loadUserDefaults
{
    if (self.model && [self.model isKindOfClass:[Weizhang class]])
    {
        Weizhang *weizhang = (Weizhang *)self.model;
        _chepaiNumberView.text = weizhang.chepaiNumber;
        _chejiaNumberView.text = weizhang.chejiaNumber;
        _chepaiTypeView.text = weizhang.chepaiType;
        _engineNumberView.text = weizhang.engineNumber;
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _chepaiNumberView.text = [defaults stringForKey:kUserDefaultKeyWeizhangChepaiNumber];
        NSString *type = [defaults stringForKey:kUserDefaultKeyWeizhangChepaiType];
        if (type)
        {
            _chepaiTypeView.text = type;
        }
        _chejiaNumberView.text = [defaults stringForKey:kUserDefaultKeyWeizhangChejiaNumber];
        _engineNumberView.text = [defaults stringForKey:kUserDefaultKeyWeizhangEngineNumber];
    }
}

- (void)saveUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_chepaiNumberView.text forKey:kUserDefaultKeyWeizhangChepaiNumber];
    [defaults setObject:_chepaiTypeView.text forKey:kUserDefaultKeyWeizhangChepaiType];
    [defaults setObject:_chejiaNumberView.text forKey:kUserDefaultKeyWeizhangChejiaNumber];
    [defaults setObject:_engineNumberView.text forKey:kUserDefaultKeyWeizhangEngineNumber];
}

- (void)clearSavedData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:kUserDefaultKeyWeizhangChepaiNumber];
    [defaults setObject:@"" forKey:kUserDefaultKeyWeizhangChepaiType];
    [defaults setObject:@"" forKey:kUserDefaultKeyWeizhangChejiaNumber];
    [defaults setObject:@"" forKey:kUserDefaultKeyWeizhangEngineNumber];
    
    _chejiaNumberView.text = nil;
    _chepaiNumberView.text = nil;
    _chepaiTypeView.text = nil;
    _engineNumberView.text = nil;
}

- (void)showCarTypePicker:(id)sender
{
    [self.view endEditing:YES];
    SZTCarTypeManager *typeManager = [SZTCarTypeManager sharedManager];
    [ActionSheetStringPicker showPickerWithTitle:@"车牌类型"
                                            rows:typeManager.displayNames
                                initialSelection:[typeManager.displayNames indexOfObject:_chepaiTypeView.text]
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           _chepaiTypeView.text = selectedValue;
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
        
                                     }
                                          origin:self.view];
}

- (void)buttonPressed:(UIButton *)sender
{
    UIImage *image = nil;
    if ([sender isEqual:_chejiaInfoBtn])
    {
        image = [UIImage imageNamed:@"chejiaNumber"];
    }
    else if ([sender isEqual:_engineInfoBtn])
    {
        image = [UIImage imageNamed:@"jdcdjzs.jpg" ];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self view:imageView];
    [modal show];
}

- (BOOL)validateInputs
{
    [self hideKeyboard];
    NSString *chepaiNumber = _chepaiNumberView.text;
    if (!chepaiNumber || chepaiNumber.length != 6)
    {
        [self.view dt_postError:@"请输入6位车牌号"];
        return NO;
    }
    
    NSString *chejiaNumber = _chejiaNumberView.text;
    if (!chejiaNumber || chejiaNumber.length != 6)
    {
        [self.view dt_postError:@"请输入车架号后6位"];
        return NO;
    }
    
    NSString *engineNumber = _engineNumberView.text;
    if (!engineNumber || engineNumber.length != 7)
    {
        [self.view dt_postError:@"请输入机动车登记证书编号(后7位)"];
        return NO;
    }
    
    if (self.saveOnly == NO) {
        NSString *verifyCode = _codeView.text;
        if (!verifyCode || verifyCode.length != 4)
        {
            [self.view dt_postError:@"请输入4位验证码"];
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
    if (![self validateInputs]) return;

    NSString *chepaiType = [[SZTCarTypeManager sharedManager] valueForName:_chepaiTypeView.text];
    
    [self.view dt_postLoading:@"努力查询中..." delay:60];
    WEAK_SELF;
    [[SZTWeizhangService sharedService] queryWeizhangWithChepaiNumber:_chepaiNumberView.text
                                                           chepaiType:chepaiType
                                                         chejiaNumber:_chejiaNumberView.text
                                                         engineNumber:_engineNumberView.text
                                                           verifyCode:_codeView.text
                                                           completion:^(SZTResultModel *model, NSError *error) {
                                                               STRONG_SELF_AND_RETURN_IF_SELF_NULL;
                                                               [self.view dt_cleanUp:YES];
                                                               if (!error)
                                                               {
                                                                   [self saveUserDefaults];
                                                                   if (model.success)
                                                                   {
                                                                       if ([model.message isKindOfClass:[NSArray class]])
                                                                       {
                                                                           SZTWeizhangResultController *resultVC = [[SZTWeizhangResultController alloc] init];
                                                                           resultVC.dataSource = model.message;
                                                                           [self.navigationController pushViewController:resultVC animated:YES];
                                                                           self.shouldShowSaveAlert = YES;
                                                                       }

                                                                       // 通知首页查询成功
                                                                       if (self.queryStatusCallback)
                                                                       {
                                                                           self.queryStatusCallback(YES);
                                                                       }
                                                                   }
                                                                   else
                                                                   {
                                                                       [UIAlertView showWithTitle:nil message:model.message cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
                                                                       self.codeView.text = nil;
                                                                       [self loadVerifyCode:nil];
                                                                   }
                                                               }
                                                               else
                                                               {
                                                                   [self.view dt_postError:error.localizedDescription];
                                                                   self.codeView.text = nil;
                                                                   [self loadVerifyCode:nil];
                                                               }
    }];
}

- (void)saveModelWithTitle:(NSString *)title
{
    WEAK_SELF;
    Weizhang *weizhang = [Weizhang MR_createEntity];
    weizhang.chepaiNumber = _chepaiNumberView.text;
    weizhang.chejiaNumber = _chejiaNumberView.text;
    weizhang.chepaiType = _chepaiTypeView.text;
    weizhang.engineNumber = _engineNumberView.text;
    weizhang.title = title;
    NSManagedObjectContext *context = weizhang.managedObjectContext;
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        if (success)
        {
            [self.view dt_postSuccess:@"保存成功"];
            [self performSelector:@selector(popSelf) withObject:nil afterDelay:2];
        }
    }];
}

- (void)loadVerifyCode:(id)sender
{
    if (sender) {
        [AVAnalytics event:kRefreshVerifyCodeWeizhang]; // 通知服务器一个验证码点击事件。
    }
    
    self.codeImageView.image = nil;
    [self.codeImageView showIndicator];
    self.codeView.text = nil;
    WEAK_SELF;
    [[SZTWeizhangService sharedService] fetchVerifyCodeImageWithCompletion:^(UIImage *verifyCodeImage, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        if (!error)
        {
            [self.codeImageView hideIndicator];
            self.codeImageView.image = verifyCodeImage;
        }
    }];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

// 自动滚动到键盘之上
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        animatedDistance = 216-(460-moveUpValue-5);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
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

#pragma mark - SZTDropdownMenuDelegate
- (void)configWithModel:(Weizhang *)model
{
    _chepaiNumberView.text = model.chepaiNumber;
    _chepaiTypeView.text = model.chepaiType;
    _chejiaNumberView.text = model.chejiaNumber;
    _engineNumberView.text = model.engineNumber;
}

@end
