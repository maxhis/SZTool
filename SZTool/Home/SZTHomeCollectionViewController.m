//
//  SZTHomeCollectionViewController.m
//  SZTool
//
//  Created by Andy on 15/6/26.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTHomeCollectionViewController.h"
#import "SZTHomeCell.h"
#import "SZTHomeModel.h"
#import "SZTShebaoViewController.h"
#import "SZTGongjijinController.h"
#import "SZTYaohaoViewController.h"
#import "SZTWeizhangViewController.h"
#import "SZTAboutViewController.h"
#import "CategoriesLayout.h"
#import "OrangeView.h"
#import "SZTHomeHeaderView.h"
#import "SZTAccountManagerController.h"

static NSString *CellIdentifier = @"CellIdentifier";
static NSString *HeaderIdentifier = @"HeaderIdentifier";

@interface SZTHomeCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataSource;

/**
 *    是否查询成功
 */
@property (nonatomic, assign) BOOL querySuccess;

@end

@implementation SZTHomeCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = APP_NAME;

    CategoriesLayout *flowLayout = [[CategoriesLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[SZTHomeCell class] forCellWithReuseIdentifier:CellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"SZTHomeCell" bundle: nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    [_collectionView registerClass:[SZTHomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"home_bg"];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_querySuccess)
    {
        [self showPromotingAlertIfNeed];
    }
}

/**
 *    在用户成功完成一次查询后给出对话框，反馈或评分，最多展示3次，用户点击后不再出现
 */
- (void)showPromotingAlertIfNeed
{
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block NSInteger remainTimes = [[defaults objectForKey:kUserDefaultKeyRemainPromotingTime] integerValue];
    if (remainTimes > 0)
    {
        [UIAlertView showWithTitle:@"期待您的声音"
                           message:@"对深圳通还满意吗？觉得不错可以去评个分支持一下，有任何建议或意见都可以反馈给我们哦！"
                 cancelButtonTitle:@"下次吧"
                 otherButtonTitles:@[@"去评分", @"反馈意见"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              _querySuccess = false;
                              if (buttonIndex == alertView.cancelButtonIndex)
                              {
                                  [defaults setObject:@(--remainTimes) forKey:kUserDefaultKeyRemainPromotingTime];
                              }
                              else if(buttonIndex == alertView.firstOtherButtonIndex)
                              {
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
                                  [defaults setObject:@(0) forKey:kUserDefaultKeyRemainPromotingTime];
                                  [AVAnalytics event:@"用户选择去评分"];
                              }
                              else if(buttonIndex == alertView.firstOtherButtonIndex + 1)
                              {
                                  AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
                                  [agent showConversations:self title:@"用户反馈" contact:nil];
                                  [defaults setObject:@(0) forKey:kUserDefaultKeyRemainPromotingTime];
                                  [AVAnalytics event:@"用户选择去反馈"];
                              }
                          }];
    }
}

- (NSArray *)dataSource
{
    if (_dataSource == nil) {
        SZTHomeModel *gongjijin = [[SZTHomeModel alloc] initWithIcon:[UIImage imageNamed:@"gongjijin"] title:@"公积金"];
        SZTHomeModel *shebao = [[SZTHomeModel alloc] initWithIcon:[UIImage imageNamed:@"shebao"] title:@"社保"];
        SZTHomeModel *yaohao = [[SZTHomeModel alloc] initWithIcon:[UIImage imageNamed:@"yaohao"] title:@"汽车摇号"];
        SZTHomeModel *weizhang = [[SZTHomeModel alloc] initWithIcon:[UIImage imageNamed:@"weizhang"] title:@"粤牌违章"];
        SZTHomeModel *settings = [[SZTHomeModel alloc] initWithIcon:[UIImage imageNamed:@"settings"] title:@"账户管理"];
        SZTHomeModel *about = [[SZTHomeModel alloc] initWithIcon:[UIImage imageNamed:@"about"] title:@"关于"];
        _dataSource = @[gongjijin, shebao, yaohao, weizhang, settings, about];
    }
    
    return _dataSource;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SZTHomeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell configWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    SZTHomeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(_collectionView.dt_width, 90);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    QueryStatusCallback callback = ^void(BOOL success) {
        _querySuccess = success;
    };
    SZTViewController *destVC;
    switch (indexPath.row) {
        case 0: {
            destVC = [[SZTGongjijinController alloc] init];
            destVC.queryStatusCallback = callback;
        }
            break;
        case 1: {
            destVC = [[SZTShebaoViewController alloc] init];
            destVC.queryStatusCallback = callback;
        }
            break;
        case 2: {
            destVC = [[SZTYaohaoViewController alloc] init];
            destVC.queryStatusCallback = callback;
        }
            break;
        case 3: {
            destVC = [[SZTWeizhangViewController alloc] init];
            destVC.queryStatusCallback = callback;
        }
            break;
            
        case 4: {
            destVC = [[SZTAccountManagerController alloc] init];
        }
            break;
            
        default:
            destVC = [[SZTAboutViewController alloc] init];
            break;
    }
    [self.navigationController pushViewController:destVC animated:YES];
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120, 120);
}

// the spacing between the cells, headers, and footers.
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat xMargin = 35;
    if (IS_IPHONE_6) {
        xMargin = 50;
    }
    else if (IS_IPHONE_6P) {
        xMargin = 65;
    }
    return UIEdgeInsetsMake(10, xMargin, 10, xMargin);
}

@end
