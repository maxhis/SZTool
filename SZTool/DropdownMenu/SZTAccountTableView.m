//
//  SZTAccountTableView.m
//  SZTool
//
//  Created by iStar on 15/4/18.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTAccountTableView.h"
#import "Gongjijin.h"
#import "Shebao.h"
#import "Yaohao.h"
#import "Weizhang.h"

@interface SZTAccountTableView () <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@end

@implementation SZTAccountTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self)
    {
        self.dataSource = self;
        self.backgroundColor = kDropdownMenuColor;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        NSError *error = nil;
        if (![[self fetchedResultsController] performFetch:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self reloadData];
}

- (void)setModeType:(ModelType)modeType
{
    _modeType = modeType;
    if (!_fetchedResultsController)
    {
        switch (_modeType) {
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
    [self reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentity = @"CellIdentity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentity];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentity];
        cell.backgroundColor = kDropdownMenuColor;
        cell.textLabel.font = [UIFont systemFontOfSize:20];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *model = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    if ([model respondsToSelector:@selector(title)])
    {
        cell.textLabel.text = [model performSelector:@selector(title) withObject:nil];
    }
    
    if(indexPath.row == self.selectedIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
            [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self endUpdates];
}

@end
