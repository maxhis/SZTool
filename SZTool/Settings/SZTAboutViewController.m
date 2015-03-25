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
            
            break;
            
        case 1:
            
            break;
            
        case 2:
        {
            SZTFeedbackViewController *feedbackVC = [[SZTFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
            
        case 3:
            
            break;
            
        default:
            break;
    }
}

@end
