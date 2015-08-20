//
//  SZTResultListController.m
//  SZTool
//
//  Created by iStar on 15/3/20.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTResultListController.h"
#import "GongjijinResult.h"
#import "DTDateUtil.h"
#import "ShebaoResult.h"
#import "BuscardResult.h"

@interface SZTResultListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *resultList;

@property (nonatomic, assign) ResultType type;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSMutableArray *historyData;// of ResultItem

@end

@implementation SZTResultListController

- (instancetype)initWithResultType:(ResultType)type account:(NSString *)account
{
    if (self = [super init]) {
        _type = type;
        _account = account;
        _historyData = [[NSMutableArray alloc] init];
    }
    
    return self;
}

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
    
    id desiredColor = [UIColor clearColor];
    _resultList.backgroundColor = desiredColor;
    _resultList.backgroundView.backgroundColor = desiredColor;
    
    [self.view addSubview:_resultList];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self setupHistoryData];
    [_resultList reloadData];
}

- (void)setupHistoryData
{
    if (_type == ResultTypeGongjijin) {
        [self setupGongjijinHistory];
    }
    else if (_type == ResultTypeShebao) {
        [self setupShebaoHistory];
    }
    else if (_type == ResultTypeBuscard) {
        [self setupBuscard];
    }
}

- (void)setupGongjijinHistory
{
    GongjijinResult *gongjijin = [GongjijinResult MR_findFirstByAttribute:@"account" withValue:_account];
    if (gongjijin) { // 先显示当前值
        SZTResultItem *tmp;
        
        // 余额
        tmp = [[SZTResultItem alloc] init];
        tmp.name = ((SZTResultItem *)_dataSource[2]).name;
        tmp.value = gongjijin.balance;
        [_historyData addObject:tmp];
        
        // 社保转移余额
        tmp = [[SZTResultItem alloc] init];
        tmp.name = ((SZTResultItem *)_dataSource[3]).name;
        tmp.value = gongjijin.transferBalance;
        [_historyData addObject:tmp];
        
        // 更新时间
        tmp = [[SZTResultItem alloc] init];
        tmp.name = @"查询时间:";
        tmp.value = [DTDateUtil simpleDateStringWithDate:gongjijin.updatedAt];
        [_historyData addObject:tmp];
        
    }
    else {
        gongjijin = [GongjijinResult MR_createEntity];
        gongjijin.account = _account;
    }
    
    // 再更新
    gongjijin.updatedAt = [NSDate date];
    gongjijin.balance = ((SZTResultItem *)_dataSource[2]).value;
    gongjijin.transferBalance = ((SZTResultItem *)_dataSource[3]).value;
    NSManagedObjectContext *context = gongjijin.managedObjectContext;
    [context MR_saveToPersistentStoreWithCompletion:nil];
}

- (void)setupShebaoHistory
{
    ShebaoResult *shebao = [ShebaoResult MR_findFirstByAttribute:@"account" withValue:_account];
    if (shebao) { // 先显示当前值
        SZTResultItem *tmp;
        
        // 养老余额
        tmp = [[SZTResultItem alloc] init];
        tmp.name = ((SZTResultItem *)_dataSource[4]).name;
        tmp.value = shebao.yanglaoBalance;
        [_historyData addObject:tmp];
        
        // 医疗余额
        tmp = [[SZTResultItem alloc] init];
        tmp.name = ((SZTResultItem *)_dataSource[5]).name;
        tmp.value = shebao.yiliaoBalance;
        [_historyData addObject:tmp];
        
        // 更新时间
        tmp = [[SZTResultItem alloc] init];
        tmp.name = @"查询时间:";
        tmp.value = [DTDateUtil simpleDateStringWithDate:shebao.updatedAt];
        [_historyData addObject:tmp];
        
    }
    else {
        shebao = [ShebaoResult MR_createEntity];
        shebao.account = _account;
    }
    
    // 再更新
    shebao.updatedAt = [NSDate date];
    shebao.yanglaoBalance = ((SZTResultItem *)_dataSource[4]).value;
    shebao.yiliaoBalance = ((SZTResultItem *)_dataSource[5]).value;
    NSManagedObjectContext *context = shebao.managedObjectContext;
    [context MR_saveToPersistentStoreWithCompletion:nil];
}

- (void)setupBuscard
{
    BuscardResult *card = [BuscardResult MR_findFirstByAttribute:@"account" withValue:_account];
    // 先显示
    if (card) {
        SZTResultItem *tmp;
        
        // 余额
        tmp = [[SZTResultItem alloc] init];
        tmp.name = ((SZTResultItem *)_dataSource[1]).name;
        tmp.value = card.balance;
        [_historyData addObject:tmp];
        
        // 更新时间
        tmp = [[SZTResultItem alloc] init];
        tmp.name = @"查询时间：";
        tmp.value = [DTDateUtil simpleDateStringWithDate:card.updatedAt];
        [_historyData addObject:tmp];
    }
    else {
        card = [BuscardResult MR_createEntity];
        card.account = _account;
    }
    
    // 再更新
    card.updatedAt = [NSDate date];
    card.balance = ((SZTResultItem *)_dataSource[1]).value;
    NSManagedObjectContext *context = card.managedObjectContext;
    [context MR_saveToPersistentStoreWithCompletion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_historyData.count) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _historyData.count;
    }
    return _dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1 && _historyData.count) {
        return @"上次查询记录";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    RZTResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[RZTResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SZTResultItem *item;
    if (indexPath.section == 0) {
        item = _dataSource[indexPath.row];
    } else {
        item = _historyData[indexPath.row];
    }
    [cell configWithResultItemModel:item];
    
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
        
        _valueView = [[UILabel alloc] initWithFrame:CGRectMake(_nameView.dt_right + 10, 0, self.contentView.dt_width, self.contentView.dt_height)];
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
