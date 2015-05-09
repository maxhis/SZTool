//
//  SZTAccountListController.m
//  SZTool
//
//  Created by iStar on 15/5/4.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTAccountListController.h"
#import "Gongjijin.h"
#import "Shebao.h"
#import "Yaohao.h"
#import "Weizhang.h"
#import "SZTGongjijinController.h"
#import "SZTShebaoViewController.h"
#import "SZTYaohaoViewController.h"
#import "SZTWeizhangViewController.h"

@interface SZTAccountListController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) ModelType modelType;

@end

@implementation SZTAccountListController

- (instancetype)initWithModelType:(ModelType)modelType
{
    self = [super init];
    if (self) {
        _modelType = modelType;
    }
    return self;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        switch (_modelType) {
            case ModelTypeGongjijin:
                _fetchedResultsController = [Gongjijin MR_fetchAllSortedBy:@"title" ascending:YES withPredicate:nil groupBy:nil delegate:self];
                break;
                
            case ModelTypeShebao:
                _fetchedResultsController = [Shebao MR_fetchAllSortedBy:@"title" ascending:YES withPredicate:nil groupBy:nil delegate:self];
                break;
                
            case ModelTypeYaohao:
                _fetchedResultsController = [Yaohao MR_fetchAllSortedBy:@"title" ascending:YES withPredicate:nil groupBy:nil delegate:self];
                break;
                
            case ModelTypeWeizhang:
                _fetchedResultsController = [Weizhang MR_fetchAllSortedBy:@"title" ascending:YES withPredicate:nil groupBy:nil delegate:self];
                break;
                
            default:
                break;
        }
    }
    
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUICompoents];
}

- (void)loadUICompoents
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNew:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.allowsMultipleSelectionDuringEditing = NO;
    id desiredColor = [UIColor clearColor];
    _tableView.backgroundColor = desiredColor;
    _tableView.backgroundView.backgroundColor = desiredColor;
    [self.view addSubview:_tableView];
    
    [self.fetchedResultsController performFetch:nil];
    [self showEmptyViewIfNeeded];
}

- (void)showEmptyViewIfNeeded
{
    if (self.fetchedResultsController.fetchedObjects.count)
    {
        _tableView.backgroundView = nil;
    }
    else
    {
        _tableView.backgroundView = [self emptyView];
    }
}

- (UIView *)emptyView
{
    UILabel *emptyView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.dt_width, 50)];
    emptyView.textAlignment = NSTextAlignmentCenter;
    emptyView.textColor = [UIColor grayColor];
    emptyView.text = @"暂无数据，可点击右上角「+」添加";
    
    return emptyView;
}

- (void)addNew:(id)sender
{
    SZTInputViewController *addVC;
    switch (_modelType) {
        case ModelTypeGongjijin:
            addVC = [[SZTGongjijinController alloc] init];
            break;
            
        case ModelTypeShebao:
            addVC = [[SZTShebaoViewController alloc] init];
            break;
            
        case ModelTypeYaohao:
            addVC = [[SZTYaohaoViewController alloc] init];
            break;
            
        case ModelTypeWeizhang:
            addVC = [[SZTWeizhangViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    if (addVC)
    {
        addVC.saveOnly = YES;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (void)gotoQuery:(NSIndexPath *)indexPath
{
    SZTInputViewController *queryVC;
    switch (_modelType) {
        case ModelTypeGongjijin:
            queryVC = [[SZTGongjijinController alloc] init];
            break;
            
        case ModelTypeShebao:
            queryVC = [[SZTShebaoViewController alloc] init];
            break;
            
        case ModelTypeYaohao:
            queryVC = [[SZTYaohaoViewController alloc] init];
            break;
            
        case ModelTypeWeizhang:
            queryVC = [[SZTWeizhangViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    if (queryVC)
    {
        queryVC.saveOnly = NO;
        queryVC.model = self.fetchedResultsController.fetchedObjects[indexPath.row];
        [self.navigationController pushViewController:queryVC animated:YES];
    }
}

# pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AccountCellIdentifier = @"AccountCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AccountCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSManagedObject *model = self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = [model performSelector:@selector(title) withObject:nil];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    } else {
        return @"已保存的账户，可左滑删除";
    }
}

# pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self gotoQuery:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObject *model = self.fetchedResultsController.fetchedObjects[indexPath.row];
        [model MR_deleteEntity];
        // 提交所有的数据更改
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
    [self showEmptyViewIfNeeded];
}

@end
