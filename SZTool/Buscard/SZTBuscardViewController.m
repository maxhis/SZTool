//
//  SZTBuscardViewController.m
//  SZTool
//
//  Created by Andy on 15/8/19.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTBuscardViewController.h"
#import "JVFloatLabeledTextField.h"
#import "Buscard.h"
#import "SZTBuscardService.h"
#import "SZTResultListController.h"

static NSString *const kNoticeInfo = @"温馨提示：\n1.本服务查询结果仅供参考，如对查询结果有疑问请与深圳通公司客户服务部联系。\n2.本服务所提供数据的解释权归深圳通公司所有。";

@interface SZTBuscardViewController () <UITextFieldDelegate,SZTDropdownMenuDelegate>

@property (strong, nonatomic) JVFloatLabeledTextField *accountView;

/**
 *    从结果页返回时是否弹出保存输入信息的提示框
 */
@property (assign, nonatomic) BOOL shouldShowSaveAlert;

@end

@implementation SZTBuscardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUIComponets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.shouldShowSaveAlert) {
        // 保存输入的信息
        [self showSaveAlertIfNeededWithIdentity:_accountView.text
                                      saveBlock:^(NSString *title) {
                                          [self saveModelWithTitle:title];
                                      }];
    }
}

- (void)loadUIComponets
{
    self.modelType = ModelTypeBuscard;
    
    self.title = @"公交卡";
    
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
    _accountView = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(kDividerWidth, SCREEN_WIDTH/8, kTextFieldWidthNormal, kTextFieldHeight)];
    _accountView.borderStyle = UITextBorderStyleRoundedRect;
    _accountView.keyboardType = UIKeyboardTypeNumberPad;
    _accountView.placeholder = @"深圳通卡号，9或12位数字";
    _accountView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _accountView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_accountView setReturnKeyType:UIReturnKeyGo];
    _accountView.delegate = self;
    _accountView.font = kDigitalFont;
    [self.view addSubview:_accountView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_accountView.dt_left, _accountView.dt_bottom, kTextFieldWidthNormal, 100)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.numberOfLines = 0;
    infoLabel.text = kNoticeInfo;
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:infoLabel];
    
    if (!self.saveOnly)
    {
        [self loadDefaultData];
    }
    self.dropdownDelegate = self;
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

- (void)doQuery
{
    if ([self validateInputs] == NO) return;
    
    WEAK_SELF;
    [self.view dt_postLoading:nil];
    [[SZTBuscardService sharedService] queryBalanceWithAccount:_accountView.text completion:^(SZTResultModel *model, NSError *error) {
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
                SZTResultListController *resultVC = [[SZTResultListController alloc] initWithResultType:ResultTypeBuscard account:_accountView.text];
                resultVC.dataSource = model.message;
                resultVC.title = @"公交卡余额";
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
            }
        }
    }];
}

- (void)loadDefaultData
{
    if (self.model && [self.model isKindOfClass:[Buscard class]])
    {
        Buscard *card = (Buscard *)self.model;
        _accountView.text = card.account;
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _accountView.text = [defaults stringForKey:kUserDefaultKeyBuscardNumber];
    }
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountView.text forKey: kUserDefaultKeyBuscardNumber];
}

- (void)clearSavedData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey: kUserDefaultKeyBuscardNumber];
    
    _accountView.text = nil;
}

- (BOOL)validateInputs
{
    NSString *account = _accountView.text;
    if (account.length == 9 || account.length == 12) {
        return YES;
    }
    [self.view dt_postError:@"请输入有效的深圳通卡号"];
    return NO;
}

- (void)saveModelWithTitle:(NSString *)title
{
    WEAK_SELF;
    Buscard *buscard = [Buscard MR_createEntity];
    buscard.title = title;
    buscard.account = _accountView.text;
    NSManagedObjectContext *context = buscard.managedObjectContext;
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        if (contextDidSave)
        {
            [self.view dt_postSuccess:@"保存成功"];
            [self performSelector:@selector(popSelf) withObject:nil afterDelay:2];
        }
    }];
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self rightAction];
    return YES;
}

#pragma mark - SZTDropdownMenuDelegate
- (void)configWithModel:(Buscard *)model
{
    _accountView.text = model.account;
}

@end
