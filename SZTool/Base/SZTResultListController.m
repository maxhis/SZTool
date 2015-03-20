//
//  SZTResultListController.m
//  SZTool
//
//  Created by iStar on 15/3/20.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTResultListController.h"

@interface SZTResultListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *resultList;

@end

@implementation SZTResultListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUIComponents];
}

- (void)loadUIComponents
{
    self.title = @"查询结果";
    
    _resultList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DTScreenWidth, DTScreenHeight) style:UITableViewStyleGrouped];
    _resultList.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _resultList.tableFooterView = [[UIView alloc]init];
    _resultList.delegate = self;
    _resultList.dataSource = self;
    [self.view addSubview:_resultList];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [_resultList reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    RZTResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[RZTResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell configWithResultItemModel:_dataSource[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


@implementation RZTResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _nameView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.dt_width/2, self.contentView.dt_height)];
        _nameView.textAlignment = NSTextAlignmentRight;
        _nameView.textColor = [UIColor grayColor];
        [self.contentView addSubview:_nameView];
        
        _valueView = [[UILabel alloc] initWithFrame:CGRectMake(_nameView.dt_right + 10, 0, self.contentView.dt_width/2, self.contentView.dt_height)];
        _valueView.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_valueView];
    }
    
    return self;
}

- (void)configWithResultItemModel:(SZTResultItem *)model
{
    self.nameView.text = model.name;
    self.valueView.text = model.value;
}

@end
