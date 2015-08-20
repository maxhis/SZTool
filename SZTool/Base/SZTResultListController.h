//
//  SZTResultListController.h
//  SZTool
//
//  Created by iStar on 15/3/20.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTViewController.h"
#import "SZTResultItem.h"

typedef NS_ENUM(NSUInteger, ResultType) {
    ResultTypeGongjijin,
    ResultTypeShebao,
    ResultTypeBuscard,
};

@interface RZTResultCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) UILabel *valueView;

- (void)configWithResultItemModel:(SZTResultItem *)model;

@end

@interface SZTResultListController : SZTViewController

@property (nonatomic, copy) NSArray *dataSource;

- (instancetype)initWithResultType:(ResultType)type account:(NSString *)account;

@end
