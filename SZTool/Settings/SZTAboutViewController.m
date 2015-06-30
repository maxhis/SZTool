//
//  SZTAboutViewController.m
//  SZTool
//
//  Created by iStar on 15/3/25.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTAboutViewController.h"
#import "SZTPrivacyViewController.h"
#import "SZTAccountManagerController.h"

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
    _tableView.tableFooterView = [self footerView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    id desiredColor = [UIColor clearColor];
    self.tableView.backgroundColor = desiredColor;
    self.tableView.backgroundView.backgroundColor = desiredColor;
    
    [self.view addSubview:_tableView];
}

- (UIView *)headerView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.dt_width, 154)];
    UIImage *icon = [UIImage imageNamed:@"common_app_icon"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    iconView.dt_centerX = headerView.dt_centerX;
    iconView.dt_top = 25;
    
    NSString *version = [NSString stringWithFormat:@"%@ v%@", APP_NAME, APP_VERSION];
    UILabel *versionLable = [[UILabel alloc] init];
    versionLable.text = version;
    [versionLable sizeToFit];
    versionLable.dt_centerX = headerView.dt_centerX;
    versionLable.dt_top = iconView.dt_bottom + 17;
    
    [headerView addSubview:iconView];
    [headerView addSubview:versionLable];
    
    return headerView;
}

- (UIView *)footerView
{
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.dt_width, 50)];
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor grayColor];
    footer.font = [UIFont systemFontOfSize:14];
    footer.lineBreakMode = NSLineBreakByWordWrapping;
    footer.numberOfLines = 0;
    footer.text = @"©弼码翁工作室 版权所有";
    
    return footer;
}

- (NSArray *)items
{
    if (_items == nil)
    {
        _items = @[@"给个好评", [NSString stringWithFormat:@"推荐「%@」给好友", APP_NAME], @"意见反馈", @"隐私声明"];
    }
    return _items;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
            NSString *text =  [NSString stringWithFormat:@"「%@」神器来了！一站式查询粤牌汽车违章、深圳公积金、社保、汽车摇号，还支持iCloud同步哦！", APP_NAME];
            [self shareText:text andImage:[UIImage imageNamed:@"ShareImage"] andUrl:[NSURL URLWithString:kAppStoreUrl]];
            [AVAnalytics event:kShareApp];
        }
            break;
            
        case 2:
        {
            AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
            [agent showConversations:self title:@"用户反馈" contact:nil];
        }
            break;
            
        case 3:
        {
            SZTPrivacyViewController *privacyVC = [[SZTPrivacyViewController alloc] init];
            [self.navigationController pushViewController:privacyVC animated:YES];
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
