//
//  SZTAccountTableView.h
//  SZTool
//
//  Created by iStar on 15/4/18.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ModelType) {
    ModelTypeGongjijin,
    ModelTypeShebao,
    ModelTypeYaohao,
    ModelTypeWeizhang
};

@interface SZTAccountTableView : UITableView

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) ModelType modeType;

@end
