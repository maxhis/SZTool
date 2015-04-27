//
//  SZTInputViewController.h
//  SZTool
//
//  Created by iStar on 15/4/19.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTViewController.h"
#import "SZTAccountTableView.h"

typedef NS_ENUM(NSInteger, ModelType) {
    ModelTypeGongjijin,
    ModelTypeShebao,
    ModelTypeYaohao,
    ModelTypeWeizhang
};

@protocol SZTDropdownMenuDelegate <NSObject>

@required
/**
 *    根据Model填充页面数据
 */
- (void)configWithModel:(NSManagedObject *)model;

@end

@interface SZTInputViewController : SZTViewController

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) id<SZTDropdownMenuDelegate> dropdownDelegate;

@property (nonatomic, assign) ModelType modelType;

@end
