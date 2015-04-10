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

static CGFloat const kTextFieldHeight       = 35;
static CGFloat kTextFieldWidthNormal        = 220;
static CGFloat kTextFieldWidthShort         = 100;
static CGFloat const kDividerWidth          = 10;
static CGFloat const kTopEdge               = 10;

@interface SZTWeizhangViewController () <UITextFieldDelegate>

/**
 *    车牌号码
 */
@property (nonatomic, strong) UITextField *chepaiNumberView;
/**
 *    车牌类型
 */
@property (nonatomic, strong) UITextField *chepaiTypeView;
/**
 *    车辆识别代号
 */
@property (nonatomic, strong) UITextField *chejiaNumberView;
/**
 *    机动车登记证书编号
 */
@property (nonatomic, strong) UITextField *engineNumberView;
// 验证码
@property (nonatomic, strong) UITextField *codeView;
@property (nonatomic, strong) UIImageView *codeImageView;

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
}

- (void)loadUIComponets
{
    self.title = @"汽车违章查询";
    
    UIBarButtonItem *queryButton = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStyleDone target:self action:@selector(doQuery:)];
    self.navigationItem.rightBarButtonItem = queryButton;
    
    kTextFieldWidthNormal = DTScreenWidth * 2 / 3;
    kTextFieldWidthShort = kTextFieldWidthNormal / 2;
    NSInteger tag = 0;
    
    // 车牌号
    _chepaiNumberView = [[UITextField alloc] initWithFrame:CGRectMake(DTScreenWidth / 3, DTScreenHeight/8, kTextFieldWidthNormal, kTextFieldHeight)];
    _chepaiNumberView.borderStyle = UITextBorderStyleRoundedRect;
    _chepaiNumberView.placeholder = @"6位广东牌照";
    _chepaiNumberView.dt_right = DTScreenWidth - kDividerWidth;
    _chepaiNumberView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _chepaiNumberView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_chepaiNumberView setReturnKeyType:UIReturnKeyNext];
    _chepaiNumberView.delegate = self;
    _chepaiNumberView.tag = tag++;
//    _chepaiNumberView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [self.view addSubview:_chepaiNumberView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _chepaiNumberView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    accountLabel.textAlignment = NSTextAlignmentRight;
    accountLabel.dt_right = _chepaiNumberView.dt_left - kDividerWidth;
    accountLabel.text = @"车牌号 粤";
    [self.view addSubview:accountLabel];
    
    // 车牌类型
    _chepaiTypeView = [[UITextField alloc] initWithFrame:CGRectMake(_chepaiNumberView.dt_left, _chepaiNumberView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _chepaiTypeView.borderStyle = UITextBorderStyleRoundedRect;
    _chepaiTypeView.enabled = NO;
    _chepaiTypeView.text = [SZTCarTypeManager sharedManager].displayNames[1]; // 默认选中小汽车
    [self.view addSubview:_chepaiTypeView];
    
    UILabel *chepaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _chepaiTypeView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    chepaiLabel.textAlignment = NSTextAlignmentRight;
    chepaiLabel.dt_right = _chepaiTypeView.dt_left - kDividerWidth;
    chepaiLabel.text = @"车牌类型";
    [self.view addSubview:chepaiLabel];
    
    UIButton *maskButton = [[UIButton alloc] initWithFrame:_chepaiTypeView.frame];
    [maskButton addTarget:self action:@selector(showCarTypePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maskButton];
    
    // 车辆识别代号（后6位）
    _chejiaNumberView = [[UITextField alloc] initWithFrame:CGRectMake(_chepaiNumberView.dt_left, _chepaiTypeView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _chejiaNumberView.borderStyle = UITextBorderStyleRoundedRect;
    _chejiaNumberView.keyboardType = UIKeyboardTypeNumberPad;
    _chejiaNumberView.placeholder = @"即车辆识别代号，后6位";
    _chejiaNumberView.dt_right = DTScreenWidth - kDividerWidth;
    _chejiaNumberView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _chejiaNumberView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_chejiaNumberView setReturnKeyType:UIReturnKeyNext];
    _chejiaNumberView.delegate = self;
    _chejiaNumberView.tag = tag++;
    [self.view addSubview:_chejiaNumberView];
    
    UILabel *clsbdhLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _chejiaNumberView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    clsbdhLabel.textAlignment = NSTextAlignmentRight;
    clsbdhLabel.dt_right = _chejiaNumberView.dt_left - kDividerWidth;
    clsbdhLabel.text = @"车架号";
    [self.view addSubview:clsbdhLabel];
    
    // 机动车登记证书编号(后7位)
    _engineNumberView = [[UITextField alloc] initWithFrame:CGRectMake(_chepaiNumberView.dt_left, _chejiaNumberView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _engineNumberView.borderStyle = UITextBorderStyleRoundedRect;
    _engineNumberView.keyboardType = UIKeyboardTypeNumberPad;
    _engineNumberView.placeholder = @"即机动车登记证书编号，后7位";
    _engineNumberView.dt_right = DTScreenWidth - kDividerWidth;
    _engineNumberView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _engineNumberView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_engineNumberView setReturnKeyType:UIReturnKeyNext];
    _engineNumberView.delegate = self;
    _engineNumberView.tag = tag++;
    [self.view addSubview:_engineNumberView];
    
    UILabel *djzsbhLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _engineNumberView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    djzsbhLabel.textAlignment = NSTextAlignmentRight;
    djzsbhLabel.dt_right = _chejiaNumberView.dt_left - kDividerWidth;
    djzsbhLabel.text = @"发动机号";
    [self.view addSubview:djzsbhLabel];
    
    // 验证码
    _codeView = [[UITextField alloc] initWithFrame:CGRectMake(_chepaiNumberView.dt_left, _engineNumberView.dt_bottom + kTopEdge, kTextFieldWidthShort, kTextFieldHeight)];
    _codeView.borderStyle = UITextBorderStyleRoundedRect;
    _codeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeView.keyboardType = UIKeyboardTypeNumberPad;
    [_codeView setReturnKeyType:UIReturnKeyGo];
    _codeView.delegate = self;
    _codeView.tag = tag++;
    [self.view addSubview:_codeView];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _codeView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    codeLabel.textAlignment = NSTextAlignmentRight;
    codeLabel.dt_right = _codeView.dt_left - kDividerWidth;
    codeLabel.text = @"验证码";
    [self.view addSubview:codeLabel];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_codeView.dt_right + kDividerWidth, _codeView.dt_top, kTextFieldWidthShort - kDividerWidth, kTextFieldHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadVerifyCode:)];
    _codeImageView.userInteractionEnabled = YES;
    [_codeImageView addGestureRecognizer:tap];
    [self.view addSubview:_codeImageView];
    
    // 点击空白区域关闭键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    [self loadUserDefaults];
}

- (void)loadUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _chepaiNumberView.text = [defaults stringForKey:kUserDefaultKeyWeizhangChepaiNumber];
    NSString *type = [defaults stringForKey:kUserDefaultKeyWeizhangChepaiType];
    if (type) {
        _chepaiTypeView.text = type;
    }
    _chejiaNumberView.text = [defaults stringForKey:kUserDefaultKeyWeizhangChejiaNumber];
    _engineNumberView.text = [defaults stringForKey:kUserDefaultKeyWeizhangEngineNumber];
}

- (void)saveUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_chepaiNumberView.text forKey:kUserDefaultKeyWeizhangChepaiNumber];
    [defaults setObject:_chepaiTypeView.text forKey:kUserDefaultKeyWeizhangChepaiType];
    [defaults setObject:_chejiaNumberView.text forKey:kUserDefaultKeyWeizhangChejiaNumber];
    [defaults setObject:_engineNumberView.text forKey:kUserDefaultKeyWeizhangEngineNumber];
}

- (void)showCarTypePicker:(id)sender
{
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

- (void)doQuery:(id)sender
{
    [self hideKeyboard];
    NSString *chepaiNumber = _chepaiNumberView.text;
    if (!chepaiNumber || chepaiNumber.length != 6)
    {
        [self.view dt_postError:@"请输入6位车牌号"];
        return;
    }
    
    NSString *chejiaNumber = _chejiaNumberView.text;
    if (!chejiaNumber || chejiaNumber.length != 6)
    {
        [self.view dt_postError:@"请输入车架号后6位"];
        return;
    }
    
    NSString *engineNumber = _engineNumberView.text;
    if (!engineNumber || engineNumber.length != 7)
    {
        [self.view dt_postError:@"请输入发动机号后7位"];
        return;
    }
    
    NSString *verifyCode = _codeView.text;
    if (!verifyCode || verifyCode.length != 4)
    {
        [self.view dt_postError:@"请输入4位验证码"];
        return;
    }

    NSString *chepaiType = [[SZTCarTypeManager sharedManager] valueForName:_chepaiTypeView.text];
    
    [self.view dt_postLoading:@"耐心哦，省公安厅的系统有点慢..." delay:60];
    WEAK_SELF;
    [[SZTWeizhangService sharedService] queryWeizhangWithChepaiNumber:chepaiNumber
                                                           chepaiType:chepaiType
                                                         chejiaNumber:chejiaNumber
                                                         engineNumber:engineNumber
                                                           verifyCode:verifyCode
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

- (void)loadVerifyCode:(id)sender
{
    if (sender) {
        [AVAnalytics event:kRefreshVerifyCodeWeizhang]; // 通知服务器一个验证码点击事件。
    }
    
    self.codeImageView.image = nil;
    self.codeView.text = nil;
    WEAK_SELF;
    [[SZTWeizhangService sharedService] fetchVerifyCodeImageWithCompletion:^(UIImage *verifyCodeImage, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        if (!error)
        {
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
        [self doQuery:nil];
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

@end
