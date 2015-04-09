//
//  SZTWeizhangResultController.h
//  SZTool
//
//  Created by iStar on 15/4/9.
//  Copyright (c) 2015年 Code Addict Studio. All rights reserved.
//

#import "SZTViewController.h"

@interface SZTWeizhangResultController : SZTViewController

@property (nonatomic, strong) NSArray *dataSource;// of SZTWeizhangModel

@end

/**
 *    违章列表Cell
 */
@interface SZTWeizhangResultCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end
