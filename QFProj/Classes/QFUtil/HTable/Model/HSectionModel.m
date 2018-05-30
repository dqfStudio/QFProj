//
//  HSectionModel.m
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HSectionModel.h"

@interface HSectionModel ()
@property (nonatomic) NSMutableArray<HCellModel *> *cellModelArray;
@end

@implementation HSectionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _headerHeight = UITableViewAutomaticDimension;
        _footerHeight = UITableViewAutomaticDimension;
        _cellModelArray = [NSMutableArray array];
    }
    return self;
}

- (void)addModel:(HCellModel *)anObject {
    if ([anObject isKindOfClass:[HCellModel class]]) {
        if (![self.cellModelArray containsObject:anObject]) {
            [self.cellModelArray addObject:anObject];
        }
    }
}

- (HCellModel *)cellAtIndex:(NSUInteger)index {
    if (index < self.cellModelArray.count) {
        return self.cellModelArray[index];
    }
    return nil;
}

- (NSUInteger)indexOfCell:(HCellModel *)anObject {
    if ([anObject isKindOfClass:[HCellModel class]]) {
        return [self.cellModelArray indexOfObject:anObject];
    }
    return -1;
}

- (NSUInteger)cells {
    return self.cellModelArray.count;
}

- (void)clearModel {
    if (self.cellModelArray.count > 0) {
        [self.cellModelArray removeAllObjects];
    }
}

@end
