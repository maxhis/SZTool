//
//  SZTYaohaoResultController.m
//  SZTool
//
//  Created by Andy on 15/9/28.
//  Copyright © 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTYaohaoResultController.h"

static NSString *const CellIndentifier = @"CellIndentifier";

@interface SZTYaohaoResultController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary * dataSource;

@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation SZTYaohaoResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所有同名中签结果";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (void) setDisplayData:(NSArray *)displayData
{
    _displayData = displayData;
    [self setupDataSource];
}

- (void)setupDataSource
{
    _dataSource = [[NSMutableDictionary alloc] initWithCapacity:_displayData.count];
    _titles = [[NSMutableArray alloc] init];
    for (NSDictionary *data in _displayData) {
        NSString *issueNo = [self getDisplayNo:[data objectForKey:@"eid"]];
        NSMutableArray *persons = [_dataSource objectForKey:issueNo];
        if (persons == nil) {
            persons = [[NSMutableArray alloc] init];
            [_dataSource setObject:persons forKey:issueNo];
            [_titles insertObject:issueNo atIndex:0];
        }
        [persons addObject:data];
    }
}

- (NSString *)getDisplayNo:(NSString *)issueNo
{
    NSString *year = [issueNo substringToIndex:4];
    NSString *month = [issueNo substringFromIndex:4];
    return [NSString stringWithFormat:@"%@年%@月", year, month];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _titles[section];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSString *title = _titles[section];
    return [_dataSource[title] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        UILabel *applyNumLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        applyNumLabel.dt_right = cell.contentView.dt_right - 15;
        applyNumLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        applyNumLabel.textAlignment = NSTextAlignmentRight;
        applyNumLabel.font = kDigitalFont;
        applyNumLabel.textColor = kNavigationBarColor;
        applyNumLabel.tag = 1024;
        
        [cell.contentView addSubview:applyNumLabel];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = _titles[indexPath.section];
    NSArray *datas = _dataSource[sectionTitle];
    NSDictionary *record = datas[indexPath.row];
    cell.textLabel.text = record[@"name"];
    
    // 编号
    NSString *type = record[@"type"];
    NSString *tid = record[@"tid"];
    NSString *display = tid;
    if ([type isEqualToString:@"1"]) {
        display = [display stringByAppendingString:@"(新能源)"];
    }
    UILabel *applyNumLabel = (UILabel *)[cell.contentView viewWithTag:1024];
    applyNumLabel.text = display;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
