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
/**
 *    根据传入的NSManagedObject对象初始化输入框
 */
@property (nonatomic, strong) NSManagedObject *model;

@property (nonatomic, assign) BOOL saveOnly;

/**
 *    先判断是否已经存在这条记录，没有则弹出提示框输入标题进行保存
 *
 *    @param identity  唯一标记，如公积金的账号、车牌号等
 *    @param saveBlock 保存操作
 */
- (void)showSaveAlertIfNeededWithIdentity:(NSString *)identity saveBlock:(void (^)(NSString *title))saveBlock;

@end
