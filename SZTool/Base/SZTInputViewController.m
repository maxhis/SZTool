//
//  SZTInputViewController.m
//  SZTool
//
//  Created by iStar on 15/4/19.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTInputViewController.h"
#import "LMDropdownView.h"
#import "Gongjijin.h"
#import "Shebao.h"
#import "Yaohao.h"
#import "Weizhang.h"

#define kTitleButtonArrowTag 9999

@interface SZTInputViewController () <UITableViewDelegate, LMDropdownViewDelegate>

// 下拉选项
@property (strong, nonatomic) LMDropdownView *dropdownView;
@property (strong, nonatomic) SZTAccountTableView *accountTableView;
@property (strong, nonatomic) UIButton *titleButton;

@property (strong, nonatomic) UITapGestureRecognizer *gesture;

@end

@implementation SZTInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 点击空白区域关闭键盘
    [self toggelMainViewGesture:YES];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    if (self.saveOnly == NO
        && self.fetchedResultsController.fetchedObjects.count)
    {
        [self.titleButton setTitle:title forState:UIControlStateNormal];
        UIView *headArrowImg = [self.titleButton viewWithTag:kTitleButtonArrowTag];
        
        // 动态调整按钮位置
        CGRect labelRect = [title boundingRectWithSize:CGSizeMake(self.titleButton.dt_width, self.titleButton.dt_height)
                                               options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine
                                            attributes:@{NSFontAttributeName:self.titleButton.titleLabel.font}
                                               context:nil];
        CGFloat centerX = self.titleButton.center.x + (labelRect.size.width + headArrowImg.frame.size.width)/2 + 2.0;
        CGPoint arrowCenter = headArrowImg.center;
        arrowCenter.x = centerX;
        [headArrowImg setCenter:arrowCenter];
        
        self.navigationItem.titleView = _titleButton;
    }
}

- (void)toggelMainViewGesture:(BOOL)enable
{
    // 这是个大坑，给self.view addGestureRecognizer后，会屏蔽所有的touch时间，从而导致弹出的 tableView 不能点击
    if (enable)
    {
        [self.view addGestureRecognizer:self.gesture];
    }
    else
    {
        [self.view removeGestureRecognizer:self.gesture];
    }
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - getter & setter

- (UITapGestureRecognizer *)gesture
{
    if (!_gesture)
    {
        _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    }
    return _gesture;
}

- (UIButton *)titleButton
{
    if (!_titleButton)
    {
        _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        UIImageView *headArrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 16, 16)];
        [headArrowImg setImage:[UIImage imageNamed:@"navi_title_arrow"]];
        [headArrowImg setCenter:CGPointMake(115, 10)];
        headArrowImg.tag = kTitleButtonArrowTag;
        [_titleButton addSubview:headArrowImg];
        
        _titleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        [_titleButton addTarget:self action:@selector(titlePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

/**
 *    旋转箭头
 *
 *    @param direction 0(原方向)、1(旋转180°)
 *    @param animated  <#animated description#>
 */
- (void)rotateTitleArrow:(NSInteger)direction animated:(BOOL)animated
{
    WEAK_SELF;
    [UIView animateWithDuration:animated ? 0.3 : 0.01
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         STRONG_SELF;
                         UIView *headArrowImg = [self.titleButton viewWithTag:kTitleButtonArrowTag];
                         headArrowImg.transform = CGAffineTransformMakeRotation(direction * M_PI);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        switch (_modelType) {
            case ModelTypeGongjijin:
                _fetchedResultsController = [Gongjijin MR_fetchAllSortedBy:@"title" ascending:YES withPredicate:nil groupBy:nil delegate:self.accountTableView];
                break;
                
            case ModelTypeShebao:
                _fetchedResultsController = [Shebao MR_fetchAllSortedBy:@"title" ascending:YES withPredicate:nil groupBy:nil delegate:self.accountTableView];
                break;
                
            case ModelTypeYaohao:
                _fetchedResultsController = [Yaohao MR_fetchAllSortedBy:@"title" ascending:YES withPredicate:nil groupBy:nil delegate:self.accountTableView];
                break;
                
            case ModelTypeWeizhang:
                _fetchedResultsController = [Weizhang MR_fetchAllSortedBy:@"title" ascending:YES withPredicate:nil groupBy:nil delegate:self.accountTableView];
                break;
                
            default:
                break;
        }
        self.accountTableView.fetchedResultsController = _fetchedResultsController;
    }
    
    return _fetchedResultsController;
}

- (LMDropdownView *)dropdownView
{
    if (!_dropdownView)
    {
        _dropdownView = [[LMDropdownView alloc] init];
        _dropdownView.menuContentView = self.accountTableView;
        _dropdownView.menuBackgroundColor = kDropdownMenuColor;
        _dropdownView.delegate = self;
    }
    return _dropdownView;
}

- (SZTAccountTableView *)accountTableView
{
    if (!_accountTableView)
    {
        _accountTableView = [[SZTAccountTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.dt_width, self.view.dt_height/2)];
        _accountTableView.tableFooterView = UIView.new;
        _accountTableView.delegate = self;
        _accountTableView.userInteractionEnabled = YES;
    }
    return _accountTableView;
}

- (void)titlePressed:(id)sender
{
    self.accountTableView.dt_height = MIN(self.view.dt_height / 2, self.accountTableView.fetchedResultsController.fetchedObjects.count*44);
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen])
    {
        [self hideDropdownView];
    }
    else
    {
        [self showDropdownView];
    }
}

- (void)hideDropdownView
{
    [self.dropdownView hide];
    [self toggelMainViewGesture:YES];
    [self rotateTitleArrow:0 animated:YES];
}

- (void)showDropdownView
{
    [self toggelMainViewGesture:NO];
    [self.dropdownView showInView:self.view withFrame:self.view.bounds];
    [self rotateTitleArrow:1 animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideDropdownView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dropdownView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SZTAccountTableView *accountTable = (SZTAccountTableView *)tableView;
        accountTable.selectedIndex = indexPath.row;
        [self.dropdownDelegate configWithModel:accountTable.fetchedResultsController.fetchedObjects[indexPath.row]];
    });
}

#pragma mark - LMDropdownViewDelegate
- (void)dropdownViewDidTapBackgroundButton:(LMDropdownView *)dropdownView
{
    [self toggelMainViewGesture:YES];
    [self rotateTitleArrow:0 animated:YES];
}

#pragma mark - 保存输入的数据
- (void)showSaveAlertIfNeededWithIdentity:(NSString *)identity
                                saveBlock:(void (^)(NSString *))saveBlock
{
    if ([self shouldSaveInputs:identity])
    {
        UIAlertView *alertView = [UIAlertView showWithTitle:@"是否保存输入的信息以便下次查询？"
                           message:nil
                             style:UIAlertViewStylePlainTextInput
                 cancelButtonTitle:@"保存"
                 otherButtonTitles:@[@"不了"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if(alertView.cancelButtonIndex == buttonIndex)
                              {
                                  UITextField *tf=[alertView textFieldAtIndex:0];
                                  saveBlock(tf.text);
                              }
        }];
        UITextField *tf=[alertView textFieldAtIndex:0];
        tf.placeholder = @"建议输入一个有意义的名称";
    }
}

/**
 *    检查是否需要保存到数据库，检查库里是否已存在这条数据
 *
 *    @param identity 唯一标记，如公积金的账号、车牌号等
 */
- (BOOL)shouldSaveInputs:(NSString *)identity
{
    switch (_modelType) {
        case ModelTypeGongjijin:
        {
            for (Gongjijin *gongjijin in self.fetchedResultsController.fetchedObjects)
            {
                if ([gongjijin.accountNumber isEqualToString:identity])
                {
                    return NO;
                }
            }
        }
            break;
        
        case ModelTypeShebao:
        {
            for (Shebao *shebao in self.fetchedResultsController.fetchedObjects)
            {
                if ([shebao.accountNumber isEqualToString:identity])
                {
                    return NO;
                }
            }
        }
            break;
        
        case ModelTypeYaohao:
        {
            for (Yaohao *yaohao in self.fetchedResultsController.fetchedObjects)
            {
                if ([yaohao.applyNumber isEqualToString:identity])
                {
                    return NO;
                }
            }
        }
            break;
        
        case ModelTypeWeizhang:
        {
            for (Weizhang *weizhang in self.fetchedResultsController.fetchedObjects)
            {
                if ([weizhang.chepaiNumber isEqualToString:identity])
                {
                    return NO;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

@end
