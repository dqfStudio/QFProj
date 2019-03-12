//
//  HCellModel.h
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KTableView;
@class HCellModel;

typedef CGFloat (^HCellHeightBlock)(NSIndexPath *indexPath, KTableView *table);
typedef UITableViewCell * (^HCellRenderBlock)(NSIndexPath *indexPath, KTableView *table);
typedef NSIndexPath * (^HCellWillSelectBlock)(NSIndexPath *indexPath, KTableView *table);
typedef void (^HCellSelectionBlock)(NSIndexPath *indexPath, KTableView *table);
typedef void (^HCellWillDisplayBlock)(UITableViewCell *cell, NSIndexPath *indexPath, KTableView *table);
typedef void (^HCellCommitEditBlock)(NSIndexPath *indexPath, KTableView *table,
UITableViewCellEditingStyle editingStyle);

typedef HCellModel* HCM;

/** Table view's row model */
@interface HCellModel : NSObject

@property (nonatomic, copy) HCellHeightBlock heightBlock;            // optional
@property (nonatomic, copy) HCellRenderBlock renderBlock;            // required
@property (nonatomic, copy) HCellWillDisplayBlock willDisplayBlock;  // optional
@property (nonatomic, copy) HCellWillSelectBlock willSelectBlock;    // optional
@property (nonatomic, copy) HCellWillSelectBlock willDeselectBlock;  // optional
@property (nonatomic, copy) HCellSelectionBlock selectionBlock;      // optional
@property (nonatomic, copy) HCellSelectionBlock deselectionBlock;    // optional
@property (nonatomic, copy) HCellCommitEditBlock commitEditBlock;    // optional
// if not specified, will use UITableViewAutomaticDimension as default value
@property (nonatomic, assign) CGFloat height;  // optional
@property (nonatomic, assign) BOOL canEdit;    // default NO
//@property (nonatomic, assign) BOOL canMove;   //default NO
@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;  // cell's editing style
@property (nonatomic, copy) NSString *deleteConfirmationButtonTitle;  // delete confirmation title
@property (nonatomic, strong) NSString *selector; //cell对应的selector

- (void)cellBlock:(HCellRenderBlock)cellBlock selectionBlock:(HCellSelectionBlock)selectionBlock;

@end
