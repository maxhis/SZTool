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

@interface SZTYaohaoViewController () <UITextFieldDelegate, SZTDropdownMenuDelegate>

@property (nonatomic, strong) JVFloatLabeledTextField *applyCodeView;

@property (nonatomic, strong) JVFloatLabeledTextField *issueNumberView;

@property (nonatomic, strong) UISegmentedControl *typeView;

@property (nonatomic, strong) NSArray *selections;

@property (nonatomic, assign) NSInteger selectedIndex;

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
    self.title = @"汽车摇号中签";
    
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
    
    // 个人或单位
    _typeView = [[UISegmentedControl alloc] initWithItems:@[@"个人" , @"单位" ]];
    _typeView.frame = CGRectMake(kDividerWidth, DTScreenHeight/16, DTScreenWidth - kDividerWidth * 2, 35);
    [self.view addSubview:_typeView];
    
    kTextFieldWidthNormal = SCREEN_WIDTH - 2*kDividerWidth;
    kTextFieldWidthShort = kTextFieldWidthNormal / 2;
    
    // 申请编码
    _applyCodeView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(kDividerWidth, _typeView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _applyCodeView.borderStyle = UITextBorderStyleRoundedRect;
    _applyCodeView.keyboardType = UIKeyboardTypeNumberPad;
    _applyCodeView.placeholder = @"申请编码,13位数字";
    _applyCodeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _applyCodeView.dt_right = DTScreenWidth - kDividerWidth;
    _applyCodeView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_applyCodeView setReturnKeyType:UIReturnKeyGo];
    _applyCodeView.delegate = self;
    _applyCodeView.font = kDigitalFont;
    [self.view addSubview:_applyCodeView];
    
    // 期号
    _issueNumberView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(_applyCodeView.dt_left, _applyCodeView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _issueNumberView.borderStyle = UITextBorderStyleRoundedRect;
    _issueNumberView.enabled = NO;
    _issueNumberView.text = self.selections[0];
    _issueNumberView.placeholder = @"期号";
    _issueNumberView.font = kDigitalFont;
    [self.view addSubview:_issueNumberView];
    
    UIButton *maskBtn = [[UIButton alloc] initWithFrame:_issueNumberView.frame];
    [maskBtn addTarget:self action:@selector(showIssuePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maskBtn];
    
    if (!self.saveOnly)
    {
        [self loadDefaultData];
    }
    else
    {
        _typeView.selectedSegmentIndex = 0;
    }
    
    self.dropdownDelegate = self;
}

- (void)loadDefaultData
{
    if (self.model && [self.model isKindOfClass:[Yaohao class]])
    {
        Yaohao *yaohao = (Yaohao *)self.model;
        _applyCodeView.text = yaohao.applyNumber;
        _typeView.selectedSegmentIndex = [yaohao.type integerValue];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _applyCodeView.text = [defaults stringForKey:kUserDefaultKeyYaohaoApplyNumber];
        _typeView.selectedSegmentIndex = [defaults integerForKey:kUserDefaultKeyYaohaoApplyType];
    }
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_applyCodeView.text forKey:kUserDefaultKeyYaohaoApplyNumber];
    [defaults setInteger:_typeView.selectedSegmentIndex forKey:kUserDefaultKeyYaohaoApplyType];
}

- (void)showIssuePicker
{
    [self hideKeyboard];
    
    [ActionSheetStringPicker showPickerWithTitle:@"摇号期数"
                                            rows:self.selections
                                initialSelection:[self.selections indexOfObject:_issueNumberView.text]
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           _issueNumberView.text = selectedValue;
                                           _selectedIndex = selectedIndex;
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
        
                                       }
                                          origin:self.view];
}

- (NSArray *)selections
{
    if (!_selections)
    {
        static NSDateFormatter *formatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMM";
        });
        
        NSString *thisMonth = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        _selections = [self generateIssueNumberFromYearMonth:thisMonth];
        
    }
    return _selections;
}

- (NSArray *)generateIssueNumberFromYearMonth:(NSString *)yearMonth
{
    NSMutableArray *issues = [[NSMutableArray alloc] initWithCapacity:5];
    int topMonth = [yearMonth intValue];
    while (topMonth > 201502)
    {
        int tail = topMonth % 100;
        if (tail == 1) {
            topMonth = (topMonth / 100 - 1) * 100 + 13;
        }
        
        [issues addObject:[NSString stringWithFormat:@"%d", --topMonth]];
    }
    
    [issues insertObject:@"最近六期" atIndex:0];
    return issues;
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
    if (!applyNumber || applyNumber.length != 13)
    {
        [self.view dt_postError:@"请输入13位有效的申请编码"];
        return NO;
    }
    return YES;
}

- (void)doQuery
{
    if (![self validateInputs]) return;
    
    WEAK_SELF;
    [[SZTYaohaoService sharedService] queryStatusWithApplycode:_applyCodeView.text
                                                    issueNmber:[self issueNumber]
                                                          type:[self applyType]
                                                    completion:^(BOOL hit, NSError *error) {
                                                        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
                                                        if (error) {
                                                            [self.view dt_postError:error.localizedDescription];
                                                            return;
                                                        }
                                                        
                                                        [self saveUserData];
                                                        UIAlertViewCompletionBlock tapBlock = ^ void ((UIAlertView *alertView, NSInteger buttonIndex)){
                                                            // 保存输入的信息
                                                            [self showSaveAlertIfNeededWithIdentity:self.applyCodeView.text
                                                                                          saveBlock:^(NSString *title) {
                                                                                              [self saveModelWithTitle:title];
                                                                                          }];
                                                        };
                                                        if (hit)
                                                        {
                                                            NSString *message = @"您可登录系统自行打印指标证明文件、或者到服务窗口领取指标证明文件。";
                                                            [UIAlertView showWithTitle:@"恭喜中签" message:message cancelButtonTitle:@"好的" otherButtonTitles:nil tapBlock:tapBlock];
                                                            
                                                            // 通知首页查询成功
                                                            if (self.queryStatusCallback)
                                                            {
                                                                self.queryStatusCallback(YES);
                                                            }
                                                        }
                                                        else
                                                        {
                                                            [UIAlertView showWithTitle:nil message:@"中签指标中无此数据!" cancelButtonTitle:@"好的" otherButtonTitles:nil tapBlock:tapBlock];
                                                        }
                                                    }];
}

- (NSString *)issueNumber
{
    NSString *issueNumber;
    if (_selectedIndex == 0)
    {
        issueNumber = @"000000";
    }
    else
    {
        issueNumber = _selections[_selectedIndex];
    }
    return issueNumber;
}

- (ApplyType)applyType
{
    ApplyType type = ApplyTypePerson;
    if (_typeView.selectedSegmentIndex == 1)
    {
        type = ApplyTypeUnit;
    }
    return type;
}

- (void)saveModelWithTitle:(NSString *)title
{
    WEAK_SELF;
    Yaohao *yaohao = [Yaohao MR_createEntity];
    yaohao.applyNumber = _applyCodeView.text;
    yaohao.type = @([self applyType]);
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
    _typeView.selectedSegmentIndex = [model.type integerValue];
}

@end
