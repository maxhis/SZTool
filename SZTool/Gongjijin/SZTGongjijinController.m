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

static CGFloat const kTextFieldHeight       = 35;
static CGFloat kTextFieldWidthNormal  = 220;
static CGFloat kTextFieldWidthShort   = 100;
static CGFloat const kDividerWidth          = 10;
static CGFloat const kTopEdge               = 10;

@interface SZTGongjijinController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *idView;
@property (strong, nonatomic) UITextField *accountView;
@property (strong, nonatomic) UITextField *codeView;
@property (strong, nonatomic) UIImageView *codeImageView;
@property (strong, nonatomic) UIButton *queryBtn;

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
}

- (void)loadUIComponent
{
    self.title = @"公积金查询";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *queryButton = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(doQuery)];
    self.navigationItem.rightBarButtonItem = queryButton;
    
    kTextFieldWidthNormal = DTScreenWidth * 2 / 3;
    kTextFieldWidthShort = kTextFieldWidthNormal / 2;
    
    // 公积金账号
    _accountView = [[UITextField alloc] initWithFrame:CGRectMake(DTScreenWidth / 3, DTScreenHeight/8, kTextFieldWidthNormal, kTextFieldHeight)];
    _accountView.borderStyle = UITextBorderStyleRoundedRect;
    _accountView.keyboardType = UIKeyboardTypeNumberPad;
    _accountView.placeholder = @"11位数字，仅支持深圳地区";
    _accountView.dt_right = DTScreenWidth - kDividerWidth;
    _accountView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _accountView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_accountView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _accountView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    accountLabel.textAlignment = NSTextAlignmentRight;
    accountLabel.dt_right = _accountView.dt_left - kDividerWidth;
    accountLabel.text = @"公积金账号";
    [self.view addSubview:accountLabel];
    
    // 身份证号
    _idView = [[UITextField alloc] initWithFrame:CGRectMake(_accountView.dt_left, _accountView.dt_bottom + kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _idView.borderStyle = UITextBorderStyleRoundedRect;
    _idView.keyboardType = UIKeyboardTypeNumberPad;
    _idView.placeholder = @"15或18位有效身份证号";
    _idView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_idView];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _idView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    idLabel.textAlignment = NSTextAlignmentRight;
    idLabel.dt_right = _idView.dt_left - kDividerWidth;
    idLabel.text = @"身份证号";
    [self.view addSubview:idLabel];
    
    // 验证码
    _codeView = [[UITextField alloc] initWithFrame:CGRectMake(_accountView.dt_left, _idView.dt_bottom + kTopEdge, kTextFieldWidthShort, kTextFieldHeight)];
    _codeView.borderStyle = UITextBorderStyleRoundedRect;
    _codeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_codeView setReturnKeyType:UIReturnKeyGo];
    _codeView.delegate = self;
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
    
    [self loadDefaultData];
}

- (void)loadDefaultData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _accountView.text = [defaults stringForKey:kUserDefaultKeyGongjijinAccount];
    _idView.text = [defaults stringForKey:kUserDefaultKeyGongjijinID];
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountView.text forKey:kUserDefaultKeyGongjijinAccount];
    [defaults setObject:_idView.text forKey:kUserDefaultKeyGongjijinID];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)loadVerifyCode:(id) sender
{
    if (sender) {
        [AVAnalytics event:kRefreshVerifyCodeGongjijin]; // 通知服务器一个验证码点击事件。
    }
    
    WEAK_SELF;
    [[SZTGongjijinService sharedService] fetchVerifyCodeImageWithCompletion:^(UIImage *verifyCodeImage, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        if (!error)
        {
            self.codeImageView.image = verifyCodeImage;
        }
    }];
}

- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doQuery
{
    [self.view endEditing:YES];
    
    NSString *account = _accountView.text;
    if (!account || account.length != 11)
    {
        [self.view dt_postError:@"请输入正确的公积金账号"];
        return;
    }
    
    NSString *idNumber = _idView.text;
    if (!idNumber || (idNumber.length != 15 && idNumber.length != 18))
    {
        [self.view dt_postError:@"请输入正确的身份证号"];
        return;
    }
    
    NSString *code = _codeView.text;
    if (!code || code.length != 4)
    {
        [self.view dt_postError:@"请输入正确的验证码"];
        return;
    }
    [self.view dt_postLoading:nil];
    WEAK_SELF;
    [[SZTGongjijinService sharedService] queryBalanceWithAccount:account
                                                        IDNumber:idNumber
                                                      verifyCode:code
                                                      completion:^(SZTResultModel *model, NSError *error) {
                                                          STRONG_SELF_AND_RETURN_IF_SELF_NULL;
                                                          if (error)
                                                          {
                                                              [self.view dt_postError:error.description delay:3];
                                                          }
                                                          else
                                                          {
                                                              [self.view dt_cleanUp:YES];
                                                              if (model.success)
                                                              {
                                                                  [self saveUserData];
                                                                  SZTResultListController *resultVC = [[SZTResultListController alloc] init];
                                                                  resultVC.dataSource = model.message;
                                                                  [self.navigationController pushViewController:resultVC animated:YES];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doQuery];
    return YES;
}

@end
