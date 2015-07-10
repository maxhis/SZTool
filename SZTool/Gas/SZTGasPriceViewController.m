//
//  SZTGasPriceViewController.m
//  SZTool
//
//  Created by Andy on 15/7/9.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTGasPriceViewController.h"
#import "BaiduAPIUtils.h"

static NSString *const kGas0     = @"p0";
static NSString *const kGas90    = @"p90";
static NSString *const kGas93    = @"p93";
static NSString *const kGas97    = @"p97";
static NSString *const kProvince = @"prov";

static NSString *const CellIndentifier = @"CellIndentifier";

@interface SZTGasPriceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *keys;

@end

@implementation SZTGasPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _titles = @[@"90号汽油", @"93号汽油", @"97号汽油", @"0号柴油"];
    _keys = @[kGas90, kGas93, kGas97, kGas0];

    [self setupViews];
    [self fetchData];
}

- (void)setupViews
{
    self.title = @"今日油价";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;

    [self.view addSubview:_tableView];
}

- (void)fetchData {
    [self.view dt_postLoading:nil];
    WEAK_SELF;
    [BaiduAPIUtils fetchGasPriceOfProvinc:@"广东" doneBlock:^(NSDictionary *result, NSError *error) {
        STRONG_SELF_AND_RETURN_IF_SELF_NULL;
        [self.view dt_cleanUp:YES];
        if (error == nil && result.allKeys.count > 1) {
            self.dataSource = result;
            [self.tableView reloadData];
        }
        else {
            [self.view dt_postError:error.localizedDescription];
        }
    }];
}

# pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.allKeys.count - 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        priceLabel.dt_right = cell.contentView.dt_right - 15;
        priceLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = kDigitalFont;
        priceLabel.textColor = kNavigationBarColor;
        priceLabel.tag = 1024;
        
        [cell.contentView addSubview:priceLabel];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    UILabel *price = (UILabel *)[cell.contentView viewWithTag:1024];
    NSString *key = self.keys[indexPath.row];
    price.text = [NSString stringWithFormat:@"￥%@", self.dataSource[key]];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"数据为发改委发布的最高零售价，实际价格请以当地加油站报价为准。";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
