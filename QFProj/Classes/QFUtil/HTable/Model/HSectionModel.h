//
//  HSectionModel.h
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HCellModel.h"

@class HTableView;

typedef UIView * (^HViewRenderBlock)(NSInteger section, HTableView *table);
typedef CGFloat (^HSectionHeightBlock)(NSInteger section, HTableView *table);

/** Table view's section model */
@interface HSectionModel : NSObject

@property (nonatomic, strong) NSString *headerTitle;  // optional
@property (nonatomic, strong) NSString *footerTitle;  // optional
// if not specified, will use UITableViewAutomaticDimension as default value
@property (nonatomic, assign) CGFloat headerHeight;  // optional
@property (nonatomic, assign) CGFloat footerHeight;  // optional

// view render blocks' priority is higher then view property.
// if headerViewRenderBlock and headerView are both provided, headerViewRenderBlock will be used
@property (nonatomic, copy) HSectionHeightBlock headerHeightBlock;  // block to header height
@property (nonatomic, copy) HSectionHeightBlock footerHeightBlock;  // block to footer height
@property (nonatomic, copy) HViewRenderBlock headerViewRenderBlock;  // block to render header view
@property (nonatomic, copy) HViewRenderBlock footerViewRenderBlock;  // block to render footer view
@property (nonatomic, strong) UIView *headerView;  // section header view
@property (nonatomic, strong) UIView *footerView;  // section footer view
@property (nonatomic, strong) NSString *selector;  //section对应的selector

//向model添加对象数据
- (void)addModel:(HCellModel *)anObject;

- (HCellModel *)cellAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfCell:(HCellModel *)anObject;

- (NSUInteger)cells;

//clear all model
- (void)clearModel;

@end
