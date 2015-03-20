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

static CGFloat const kTextFieldHeight       = 35;
static CGFloat const kTextFieldWidthNormal  = 200;
static CGFloat const kTextFieldWidthShort   = 100;
static CGFloat const kDividerWidth          = 10;
static CGFloat const kTopEdge               = 10;

@interface SZTShebaoViewController ()
@property (strong, nonatomic) UITextField *idView;
@property (strong, nonatomic) UITextField *accountView;
@property (strong, nonatomic) UITextField *codeView;
@property (strong, nonatomic) UIImageView *codeImageView;
@property (strong, nonatomic) UIButton *queryBtn;

@end

@implementation SZTShebaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadUIComponent];
    [self loadVerifyCode];
}

- (void)loadUIComponent
{
    self.title = @"社保查询";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *queryButton = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(doQuery)];
    self.navigationItem.rightBarButtonItem = queryButton;
    
    // 电脑号
    _accountView = [[UITextField alloc] initWithFrame:CGRectMake(DTScreenWidth / 2 - 50, kTopEdge, kTextFieldWidthNormal, kTextFieldHeight)];
    _accountView.borderStyle = UITextBorderStyleRoundedRect;
    _accountView.keyboardType = UIKeyboardTypeNumberPad;
    _accountView.placeholder = @"9位数字";
    _accountView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_accountView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _accountView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    accountLabel.textAlignment = NSTextAlignmentRight;
    accountLabel.dt_right = _accountView.dt_left - 5;
    accountLabel.text = @"电脑号";
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
    idLabel.dt_right = _idView.dt_left - 5;
    idLabel.text = @"身份证号";
    [self.view addSubview:idLabel];
    
    // 验证码
    _codeView = [[UITextField alloc] initWithFrame:CGRectMake(_accountView.dt_left, _idView.dt_bottom + kTopEdge, kTextFieldWidthShort, kTextFieldHeight)];
    _codeView.borderStyle = UITextBorderStyleRoundedRect;
    _codeView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_codeView];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _codeView.dt_top, kTextFieldWidthShort, kTextFieldHeight)];
    codeLabel.textAlignment = NSTextAlignmentRight;
    codeLabel.dt_right = _codeView.dt_left - 5;
    codeLabel.text = @"验证码";
    [self.view addSubview:codeLabel];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_codeView.dt_right + kDividerWidth, _codeView.dt_top, kTextFieldWidthShort - kDividerWidth, kTextFieldHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadVerifyCode)];
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
    _accountView.text = [defaults stringForKey:kUserDefaultKeyShebaoAccount];
    _idView.text = [defaults stringForKey:kUserDefaultKeyShebaoID];
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountView.text forKey: kUserDefaultKeyShebaoAccount];
    [defaults setObject:_idView.text forKey: kUserDefaultKeyShebaoID];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)loadVerifyCode
{
    WEAK_SELF;
    [[SZTShebaoService sharedService] fetchVerifyCodeImageWithCompletion:^(UIImage *verifyCodeImage, NSError *error) {
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
    if (!account || account.length != 9)
    {
        [self.view dt_postError:@"请输入正确的电脑号"];
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
    WEAK_SELF;
    [self.view dt_postLoading:nil];
    [[SZTShebaoService sharedService] queryBalanceWithAccount:account
                                                        IDNumber:idNumber
                                                      verifyCode:code
                                                      completion:^(SZTResultModel *model, NSError *error) {
                                                          STRONG_SELF_AND_RETURN_IF_SELF_NULL;
                                                          if (error)
                                                          {
                                                              [self.view dt_postError:error.description];
                                                          }
                                                          else
                                                          {
                                                              if (model.success)
                                                              {
                                                                  [self.view dt_cleanUp:YES];
                                                                  [self saveUserData];
                                                                  SZTResultListController *resultVC = [[SZTResultListController alloc] init];
                                                                  resultVC.dataSource = model.message;
                                                                  resultVC.title = @"参保情况";
                                                                  [self.navigationController pushViewController:resultVC animated:YES];
                                                              }
                                                              else
                                                              {
                                                                  [self.view dt_postError:model.message];
                                                                  [self loadVerifyCode];
                                                              }
                                                          }
                                                          self.codeView.text = nil;
                                                      }];
}

@end
