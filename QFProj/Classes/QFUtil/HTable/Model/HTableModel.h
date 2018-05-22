//
//  HTableModel.h
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HSectionModel.h"

@class HTableView;

/**
 *  HTableModel implements some methods in UITableViewDelegate & UITableViewDataSource.
 *  it can be used as the delegate & dataSource of a tableView.
 *  For those methods it doesn't implement, you can implement them in its subclass.
 */
@interface HTableModel : NSObject <UITableViewDelegate, UITableViewDataSource>

//向model添加对象数据
- (void)addModel:(HSectionModel *)anObject;

- (HSectionModel *)sectionAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfSection:(HSectionModel *)anObject;

- (NSUInteger)sections;

//clear all model
- (void)clearModel;

@end
