//
//  SZTHomeListController.m
//  SZTool
//
//  Created by iStar on 15/3/16.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeListController.h"
#import "SZTHomeModel.h"
#import "SZTGongjijinController.h"
#import "SZTYaohaoViewController.h"
#import "SZTShebaoViewController.h"

@interface SZTHomeListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTable;

@property (nonatomic, strong) NSArray *dataSource; // of SZTHomeModel

@end

@implementation SZTHomeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"深圳通";
    
    _listTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    _listTable.tableFooterView = UIView.new;
    _listTable.dataSource = self;
    _listTable.delegate = self;
    
    [self.view addSubview:_listTable];
}

- (NSArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = @[[[SZTHomeModel alloc] initWithIcon:nil title:@"公积金" subTitle:@"公积金余额查询"],
                        [[SZTHomeModel alloc] initWithIcon:nil title:@"社保" subTitle:@"社保余额查询"],
                        [[SZTHomeModel alloc] initWithIcon:nil title:@"摇号" subTitle:@"摇号中签结果查询"],];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SZTHomeModel *model = self.dataSource[indexPath.row];
    cell.imageView.image = model.icon;
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *destVC;
    switch (indexPath.row) {
        case 0:
            destVC = [[SZTGongjijinController alloc] init];
            break;
            
        case 1:
            destVC = [[SZTShebaoViewController alloc] init];
            break;
            
        case 2:
            destVC = [[SZTYaohaoViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    SZTHomeModel *model = self.dataSource[indexPath.row];
    destVC.title = model.title;
    [self.navigationController pushViewController:destVC animated:YES];
}

@end
