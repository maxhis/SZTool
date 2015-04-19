//
//  SZTInputViewController.m
//  SZTool
//
//  Created by iStar on 15/4/19.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTInputViewController.h"
#import "LMDropdownView.h"

@interface SZTInputViewController () <UITableViewDelegate, LMDropdownViewDelegate>

// 下拉选项
@property (strong, nonatomic) LMDropdownView *dropdownView;
@property (strong, nonatomic) SZTAccountTableView *accountTableView;
@property (strong, nonatomic) UIButton *titleButton;

@property (strong, nonatomic) UITapGestureRecognizer *gesture;

@end

@implementation SZTInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 点击空白区域关闭键盘
    [self shouldHideKeyboardWhenTouchOutside:YES];
}

- (void)shouldHideKeyboardWhenTouchOutside:(BOOL)enable
{
    // 这是个大坑，给self.view addGestureRecognizer后，会屏蔽所有的touch时间，从而导致弹出的 tableView 不能点击
    if (enable)
    {
        [self.view addGestureRecognizer:self.gesture];
    }
    else
    {
        [self.view removeGestureRecognizer:self.gesture];
    }
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)setTitle:(NSString *)title
{
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - getter & setter

- (UITapGestureRecognizer *)gesture
{
    if (!_gesture)
    {
        _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    }
    return _gesture;
}

- (UIButton *)titleButton
{
    if (!_titleButton)
    {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setImage:[UIImage imageNamed:@"ico_white_arrow"] forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        [_titleButton addTarget:self action:@selector(titlePressed:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _titleButton;
    }
    return _titleButton;
}

- (void)setModelType:(ModelType)modelType
{
    _modelType = modelType;
    self.accountTableView.modeType = _modelType;
}

- (LMDropdownView *)dropdownView
{
    if (!_dropdownView)
    {
        _dropdownView = [[LMDropdownView alloc] init];
        _dropdownView.menuContentView = self.accountTableView;
        _dropdownView.menuBackgroundColor = kDropdownMenuColor;
    }
    return _dropdownView;
}

- (SZTAccountTableView *)accountTableView
{
    if (!_accountTableView)
    {
        _accountTableView = [[SZTAccountTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.dt_width, self.view.dt_height/2)];
        _accountTableView.tableFooterView = UIView.new;
        _accountTableView.delegate = self;
        _accountTableView.userInteractionEnabled = YES;
    }
    return _accountTableView;
}

- (void)titlePressed:(id)sender
{
    self.accountTableView.dt_height = MIN(self.view.dt_height / 2, self.accountTableView.fetchedResultsController.fetchedObjects.count*44);
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen])
    {
        [self.dropdownView hide];
        [self shouldHideKeyboardWhenTouchOutside:YES];
    }
    else
    {
        [self shouldHideKeyboardWhenTouchOutside:NO];
        [self.dropdownView showInView:self.view withFrame:self.view.bounds];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dropdownView hide];
    [self shouldHideKeyboardWhenTouchOutside:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dropdownView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SZTAccountTableView *accountTable = (SZTAccountTableView *)tableView;
        accountTable.selectedIndex = indexPath.row;
        [self.dropdownDelegate configWithModel:accountTable.fetchedResultsController.fetchedObjects[indexPath.row]];
    });
}

#pragma mark - LMDropdownViewDelegate
- (void)dropdownViewDidTapBackgroundButton:(LMDropdownView *)dropdownView
{
    [self shouldHideKeyboardWhenTouchOutside:YES];
}

@end
