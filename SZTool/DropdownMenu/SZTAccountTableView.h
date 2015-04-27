//
//  SZTAccountTableView.h
//  SZTool
//
//  Created by iStar on 15/4/18.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZTAccountTableView : UITableView <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
