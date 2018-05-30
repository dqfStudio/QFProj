//
//  HTableModel.m
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableModel.h"

@interface HTableModel ()
@property (nonatomic) NSMutableArray<HSectionModel *> *sectionModelArray;
@end

@implementation HTableModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sectionModelArray = [NSMutableArray array];
    }
    return self;
}

- (void)addModel:(HSectionModel *)anObject {
    if ([anObject isKindOfClass:[HSectionModel class]]) {
        if (![self.sectionModelArray containsObject:anObject]) {
            [self.sectionModelArray addObject:anObject];
        }
    }
}

- (HSectionModel *)sectionAtIndex:(NSUInteger)index {
    if (index < self.sectionModelArray.count) {
        return self.sectionModelArray[index];
    }
    return nil;
}

- (NSUInteger)indexOfSection:(HSectionModel *)anObject {
    if ([anObject isKindOfClass:[HSectionModel class]]) {
        return [self.sectionModelArray indexOfObject:anObject];
    }
    return -1;
}

- (NSUInteger)sections {
    return self.sectionModelArray.count;
}

- (void)clearModel {
    if (self.sectionModelArray.count > 0) {
        [self.sectionModelArray removeAllObjects];
    }
}

- (HSectionModel*)sectionModelAtSection:(NSInteger)section {
    @try {
        HSectionModel *sectionModel = self.sectionModelArray[section];
        return sectionModel;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (HCellModel*)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        HSectionModel *sectionModel = self.sectionModelArray[indexPath.section];
        HCellModel *cellModel = [sectionModel cellAtIndex:indexPath.row];
        return cellModel;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    HCellHeightBlock heightBlock = cellModel.heightBlock;
    if (heightBlock) {
        return heightBlock(indexPath, (HTableView *)tableView);
    } else {
        return cellModel.height;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HSectionModel *sectionModel = [self sectionModelAtSection:section];
    HSectionHeightBlock headerHeightBlock = sectionModel.headerHeightBlock;
    if (headerHeightBlock) {
        return headerHeightBlock(section, (HTableView *)tableView);
    } else {
        return sectionModel.headerHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    HSectionModel *sectionModel = [self sectionModelAtSection:section];
    HSectionHeightBlock footerHeightBlock = sectionModel.footerHeightBlock;
    if (footerHeightBlock) {
        return footerHeightBlock(section, (HTableView *)tableView);
    } else {
        return sectionModel.footerHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HSectionModel *sectionModel = [self sectionModelAtSection:section];
    HViewRenderBlock headerViewRenderBlock = sectionModel.headerViewRenderBlock;
    if (headerViewRenderBlock) {
        return headerViewRenderBlock(section, (HTableView *)tableView);
    } else {
        return sectionModel.headerView;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HSectionModel *sectionModel = [self sectionModelAtSection:section];
    HViewRenderBlock footerViewRenderBlock = sectionModel.footerViewRenderBlock;
    if (footerViewRenderBlock) {
        return footerViewRenderBlock(section, (HTableView *)tableView);
    } else {
        return sectionModel.footerView;
    }
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView
           willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    HCellWillSelectBlock willSelectBlock = cellModel.willSelectBlock;
    if (willSelectBlock) {
        return willSelectBlock(indexPath, (HTableView *)tableView);
    }
    return indexPath;
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView
         willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    HCellWillSelectBlock willDeselectBlock = cellModel.willDeselectBlock;
    if (willDeselectBlock) {
        return willDeselectBlock(indexPath, (HTableView *)tableView);
    }
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    HCellSelectionBlock selectionBlock = cellModel.selectionBlock;
    if (selectionBlock) {
        selectionBlock(indexPath, (HTableView *)tableView);
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    HCellSelectionBlock deselectionBlock = cellModel.deselectionBlock;
    if (deselectionBlock) {
        deselectionBlock(indexPath, (HTableView *)tableView);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
     HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.deleteConfirmationButtonTitle;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self sections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HSectionModel *sectionModel = [self sectionModelAtSection:section];
    return [sectionModel cells];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    UITableViewCell *cell = nil;
    HCellRenderBlock renderBlock = cellModel.renderBlock;
    if (renderBlock) {
        cell = renderBlock(indexPath, (HTableView *)tableView);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    HCellWillDisplayBlock willDisplayBlock = cellModel.willDisplayBlock;
    if (willDisplayBlock) {
        willDisplayBlock(cell, indexPath, (HTableView *)tableView);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    HSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    HSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.footerTitle;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.canEdit;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    HCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    HCellCommitEditBlock commitEditBlock = cellModel.commitEditBlock;
    if (commitEditBlock) {
        commitEditBlock(indexPath, (HTableView *)tableView, editingStyle);
    }
}

@end
