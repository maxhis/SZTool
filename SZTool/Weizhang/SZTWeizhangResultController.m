//
//  SZTWeizhangResultController.m
//  SZTool
//
//  Created by iStar on 15/4/9.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTWeizhangResultController.h"
#import "SZTWeizhangService.h"

@interface SZTWeizhangResultController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SZTWeizhangResultController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUICompoents];
}

- (void)loadUICompoents
{
    self.title = @"违章记录";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionData = self.dataSource[section];
    return sectionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *WeizhangCellIdentifier = @"WeizhangCellIdentifier";
    SZTWeizhangResultCell *cell = [tableView dequeueReusableCellWithIdentifier:WeizhangCellIdentifier];
    if (!cell)
    {
        cell = [[SZTWeizhangResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeizhangCellIdentifier];
    }
    
    NSDictionary *data = self.dataSource[indexPath.section];
    NSString *itemName = kWeizhangItemNames[indexPath.row];
    cell.nameLabel.text = itemName;
    cell.contentLabel.text = [data objectForKey:itemName];
    if (indexPath.row == 3)
    {
        cell.contentLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.contentLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        return 44 * 2;
    }
    return 44;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

@implementation SZTWeizhangResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.dt_width/3, self.contentView.dt_height)];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        _nameLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.dt_right + 10, 0, self.contentView.dt_width * 2/3 - 10, self.contentView.dt_height)];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

@end