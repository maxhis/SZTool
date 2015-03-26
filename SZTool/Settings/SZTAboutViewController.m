//
//  SZTAboutViewController.m
//  SZTool
//
//  Created by iStar on 15/3/25.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTAboutViewController.h"
#import "SZTFeedbackViewController.h"

@interface SZTAboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *items;
@end

@implementation SZTAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUIComponent];
}

- (void)loadUIComponent
{
    self.title = @"关于";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.tableHeaderView = [self headerView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (UIView *)headerView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.dt_width, 154)];
    UIImage *icon = [UIImage imageNamed:@"common_app_icon"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    iconView.dt_centerX = headerView.dt_centerX;
    iconView.dt_top = 25;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"%@ v%@", infoDic[@"CFBundleDisplayName"], infoDic[@"CFBundleShortVersionString"]];
    UILabel *versionLable = [[UILabel alloc] init];
    versionLable.text = version;
    [versionLable sizeToFit];
    versionLable.dt_centerX = headerView.dt_centerX;
    versionLable.dt_top = iconView.dt_bottom + 17;
    
    [headerView addSubview:iconView];
    [headerView addSubview:versionLable];
    
    return headerView;
}

- (NSArray *)items
{
    if (_items == nil)
    {
        _items = @[@"去评分", @"向好友推荐本应用", @"意见反馈", @"隐私政策"];
    }
    return _items;
}

- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
        }
            break;
            
        case 1:
        {
            NSString *text = @"神器来了！一站式查询深圳公积金、社保、汽车摇号，亲测好用！";
            [self shareText:text andImage:[UIImage imageNamed:@"common_app_icon"] andUrl:[NSURL URLWithString:kAppStoreUrl]];
        }
            break;
            
        case 2:
        {
            SZTFeedbackViewController *feedbackVC = [[SZTFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
            
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
