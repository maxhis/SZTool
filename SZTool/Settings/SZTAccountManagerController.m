//
//  SZTAccountManagerController.m
//  SZTool
//
//  Created by iStar on 15/5/4.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTAccountManagerController.h"
#import "SZTAccountListController.h"

#define kAccountTypes @[@"公积金",@"社保", @"公交卡", @"汽车违章", @"汽车摇号"]

@interface SZTAccountManagerController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SZTAccountManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUIComponets];
}

- (void)loadUIComponets
{
    self.title = @"账户管理";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    id desiredColor = [UIColor clearColor];
    _tableView.backgroundColor = desiredColor;
    _tableView.backgroundView.backgroundColor = desiredColor;
    
    [self.view addSubview:_tableView];
}

# pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kAccountTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AccountCellIdentifier = @"AccountCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AccountCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = kAccountTypes[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"可以在这里查看已保存的所有账号信息，并可一键查询；也可以增加或删除任意账号信息，所有改动都会自动iCloud同步。";
}

# pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ModelType modelType;
    NSString *title;
    switch (indexPath.row) {
        case 0:
            modelType = ModelTypeGongjijin;
            title = @"公积金";
            break;
            
        case 1:
            modelType = ModelTypeShebao;
            title = @"社保";
            break;
            
        case 2:
            modelType = ModelTypeBuscard;
            title = @"公交卡";
            break;
            
        case 3:
            modelType = ModelTypeWeizhang;
            title = @"汽车违章";
            break;
            
        case 4:
            modelType = ModelTypeYaohao;
            title = @"汽车摇号";
            break;
            
        default:
            break;
    }
    SZTAccountListController *accountListVC = [[SZTAccountListController alloc] initWithModelType:modelType];
    accountListVC.title = title;
    [self.navigationController pushViewController:accountListVC animated:YES];
}

@end
