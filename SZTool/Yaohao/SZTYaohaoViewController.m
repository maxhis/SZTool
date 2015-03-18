//
//  SZTYaohaoViewController.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTYaohaoViewController.h"
#import "ActionSheetCustomPicker.h"
#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetStringPicker.h"
#import "SZTYaohaoService.h"

static CGFloat const kTextFieldHeight       = 35;
static CGFloat const kTextFieldWidthNormal  = 200;
static CGFloat const kTextFieldWidthShort   = 100;
static CGFloat const kDividerWidth          = 10;
static CGFloat const kTopEdge               = 10;

@interface SZTYaohaoViewController ()

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
    UIBarButtonItem *queryButton = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(doQuery)];
    self.navigationItem.rightBarButtonItem = queryButton;
    
    // 个人或单位
    _typeView = [[UISegmentedControl alloc] initWithItems:@[@"个人" , @"单位" ]];
    _typeView.frame = CGRectMake(kDividerWidth, kTopEdge, DTScreenWidth - kDividerWidth * 2, kTextFieldHeight);
    _typeView.selectedSegmentIndex = 0;
    [self.view addSubview:_typeView];
    
    // 申请编码
    _applyCodeView = [[UITextField alloc] initWithFrame:CGRectMake(DTScreenWidth / 2 - 50, _typeView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _applyCodeView.borderStyle = UITextBorderStyleRoundedRect;
    _applyCodeView.keyboardType = UIKeyboardTypeNumberPad;
    _applyCodeView.placeholder = @"13位数字";
    _applyCodeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_applyCodeView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _applyCodeView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    accountLabel.textAlignment = NSTextAlignmentRight;
    accountLabel.dt_right = _applyCodeView.dt_left - 5;
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
    idLabel.dt_right = _issueNumberView.dt_left - 5;
    idLabel.text = @"期号";
    [self.view addSubview:idLabel];
    
    // 点击空白区域关闭键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
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
        _selections = @[ @"最近六期", @"201502" ];
    }
    return _selections;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
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
                                                        
                                                        if (hit)
                                                        {
                                                            [self.view dt_postSuccess:@"恭喜你中签！"];
                                                        }
                                                        else
                                                        {
                                                            [self.view dt_postError:@"这次没中，还有下次哦~"];
                                                        }
                                                    }];
}

@end
