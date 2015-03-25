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

static CGFloat const kTextFieldHeight       = 35;
static CGFloat kTextFieldWidthNormal  = 200;
static CGFloat kTextFieldWidthShort   = 100;
static CGFloat const kDividerWidth          = 10;
static CGFloat const kTopEdge               = 10;

@interface SZTYaohaoViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *applyCodeView;

@property (nonatomic, strong) UITextField *issueNumberView;

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
    self.title = @"汽车摇号中签查询";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *queryButton = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(doQuery)];
    self.navigationItem.rightBarButtonItem = queryButton;
    
    // 个人或单位
    _typeView = [[UISegmentedControl alloc] initWithItems:@[@"个人" , @"单位" ]];
    _typeView.frame = CGRectMake(kDividerWidth, DTScreenHeight/16, DTScreenWidth - kDividerWidth * 2, kTextFieldHeight);
    [self.view addSubview:_typeView];
    
    kTextFieldWidthNormal = DTScreenWidth * 2 / 3;
    kTextFieldWidthShort = kTextFieldWidthNormal / 2;
    
    // 申请编码
    _applyCodeView = [[UITextField alloc] initWithFrame:CGRectMake(DTScreenWidth / 3, _typeView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _applyCodeView.borderStyle = UITextBorderStyleRoundedRect;
    _applyCodeView.keyboardType = UIKeyboardTypeNumberPad;
    _applyCodeView.placeholder = @"13位数字";
    _applyCodeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _applyCodeView.dt_right = DTScreenWidth - kDividerWidth;
    _applyCodeView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_applyCodeView setReturnKeyType:UIReturnKeyGo];
    _applyCodeView.delegate = self;
    [self.view addSubview:_applyCodeView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _applyCodeView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    accountLabel.textAlignment = NSTextAlignmentRight;
    accountLabel.dt_right = _applyCodeView.dt_left - kDividerWidth;
    accountLabel.text = @"申请编码";
    [self.view addSubview:accountLabel];
    
    // 期号
    _issueNumberView = [[UITextField alloc] initWithFrame:CGRectMake(_applyCodeView.dt_left, _applyCodeView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _issueNumberView.borderStyle = UITextBorderStyleRoundedRect;
    _issueNumberView.enabled = NO;
    _issueNumberView.text = self.selections[0];
    [self.view addSubview:_issueNumberView];
    
    UIButton *maskBtn = [[UIButton alloc] initWithFrame:_issueNumberView.frame];
    [maskBtn addTarget:self action:@selector(showIssuePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maskBtn];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _issueNumberView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    idLabel.textAlignment = NSTextAlignmentRight;
    idLabel.dt_right = _issueNumberView.dt_left - kDividerWidth;
    idLabel.text = @"期号";
    [self.view addSubview:idLabel];
    
    // 点击空白区域关闭键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    [self loadDefaultData];
}

- (void)loadDefaultData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _applyCodeView.text = [defaults stringForKey:kUserDefaultKeyYaohaoApplyNumber];
    _typeView.selectedSegmentIndex = [defaults integerForKey:kUserDefaultKeyYaohaoApplyType];
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
                                initialSelection:0
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

- (void)doQuery
{
    [self hideKeyboard];
    
    NSString *applyNumber = _applyCodeView.text;
    if (!applyNumber || applyNumber.length != 13)
    {
        [self.view dt_postError:@"请输入13位有效的申请编码"];
        return;
    }
    
    NSString *issueNumber;
    if (_selectedIndex == 0)
    {
        issueNumber = @"000000";
    }
    else
    {
        issueNumber = _selections[_selectedIndex];
    }
    
    ApplyType type = ApplyTypePerson;
    if (_typeView.selectedSegmentIndex == 1)
    {
        type = ApplyTypeUnit;
    }
    
    WEAK_SELF;
    [[SZTYaohaoService sharedService] queryStatusWithApplycode:applyNumber
                                                    issueNmber:issueNumber
                                                          type:type
                                                    completion:^(BOOL hit, NSError *error) {
                                                        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
                                                        if (error) {
                                                            [self.view dt_postError:error.description];
                                                            return;
                                                        }
                                                        
                                                        [self saveUserData];
                                                        if (hit)
                                                        {
                                                            NSString *message = @"您可登录系统自行打印指标证明文件、或者到服务窗口领取指标证明文件。";
                                                            [UIAlertView showWithTitle:@"恭喜中签" message:message cancelButtonTitle:@"好的" otherButtonTitles:nil tapBlock:nil];
                                                        }
                                                        else
                                                        {
                                                            [UIAlertView showWithTitle:nil message:@"中签指标中无此数据!" cancelButtonTitle:@"好的" otherButtonTitles:nil tapBlock:nil];
                                                        }
                                                    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doQuery];
    return YES;
}

@end
