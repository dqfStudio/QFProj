//
//  HTableView.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableView.h"

#define KDefaultPageSize 20

@interface NSIndexPath (HTableView)
- (NSString *)string;
@end

@implementation NSIndexPath (HTableView)
- (NSString *)string {
    return [NSString stringWithFormat:@"%@%@",@(self.section),@(self.row)];
}
@end

@interface HTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSMutableSet *allReuseCells;

@property (nonatomic, copy) HANumberOfSectionsBlock numberOfSectionsBlock;
@property (nonatomic, copy) HNumberOfCellsBlock numberOfCellsBlock;

@property (nonatomic, copy) HeightForHeaderBlock heightForHeaderBlock;
@property (nonatomic, copy) HeightForFooterBlock heightForFooterBlock;
@property (nonatomic, copy) HeightForCellBlock heightForCellBlock;

@property (nonatomic, copy) HHeaderTableBlock headerTableBlock;
@property (nonatomic, copy) HFooterTableBlock footerTableBlock;
@property (nonatomic, copy) HCellTableBlock cellTableBlock;

@property (nonatomic, copy) HDidSelectCellBlock didSelectCellBlock;
@end

@implementation HTableView

#pragma --mark init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.alwaysBounceVertical = YES;
    self.backgroundColor = [UIColor clearColor];
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    _allReuseCells = [NSMutableSet new];
    self.tableFooterView = [UIView new];
    self.delegate = self;
    self.dataSource = self;
}
- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        [self reloadData];
    }
}
#pragma --mark other methods
- (NSUInteger)pageNo {
    NSNumber *page = objc_getAssociatedObject(self, _cmd);
    if (!page) {
        [self setPageNo:1];
    }
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}
- (void)setPageNo:(NSUInteger)pageNo {
    objc_setAssociatedObject(self, @selector(pageNo), @(pageNo), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSUInteger)pageSize {
    NSNumber *pageSize = objc_getAssociatedObject(self, _cmd);
    if (!pageSize) {
        return KDefaultPageSize;
    }
    return [pageSize unsignedIntegerValue];
}
- (void)setPageSize:(NSUInteger)pageSize {
    objc_setAssociatedObject(self, @selector(pageSize), @(pageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)beginRefresh {
    if (_refreshBlock) {
        [self setPageNo:1];
        [self.mj_header beginRefreshing];
    }
}
//stop refresh
-(void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
- (void)setRefreshBlock:(HRefreshTableBlock)refreshBlock {
    _refreshBlock = refreshBlock;
    if (_refreshBlock) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self setPageNo:1];
            _refreshBlock();
        }];
    }else {
        self.mj_header = nil;
    }
}
- (void)setLoadMoreBlock:(HLoadMoreTableBlock)loadMoreBlock {
    _loadMoreBlock = loadMoreBlock;
    if (_loadMoreBlock) {
        [self setPageNo:1];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.pageNo += 1;
           _loadMoreBlock();
        }];
    }else {
        self.mj_footer = nil;
    }
}
#pragma mark - signal
- (void)signalToTable:(HTableSignal *)signal {
    if (self.signalBlock) {
        self.signalBlock(signal);
    }
}
- (void)signalToAllCells:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSInteger cells = [self numberOfRowsInSection:i];
            for (int j=0; j<cells; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
                if (cell.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.signalBlock(signal);
                    });
                }
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal cellSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger cells = [self numberOfRowsInSection:section];
        for (int i=0; i<cells; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
            if (cell.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.signalBlock(signal);
                });
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal indexPath:(NSIndexPath *)indexPath  {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (cell.signalBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.signalBlock(signal);
            });
        }
    });
}
- (void)signalToAllHeader:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            UITableViewHeaderFooterView *header = [self headerViewForSection:i];
            if (header) {
                if (header.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        header.signalBlock(signal);
                    });
                }
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal headerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewHeaderFooterView *header = [self headerViewForSection:section];
        if (header) {
            if (header.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    header.signalBlock(signal);
                });
            }
        }
    });
}
- (void)signalToAllFooter:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            UITableViewHeaderFooterView *footer = [self footerViewForSection:i];
            if (footer) {
                if (footer.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        footer.signalBlock(signal);
                    });
                }
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal footerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewHeaderFooterView *footer = [self footerViewForSection:section];
        if (footer) {
            if (footer.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    footer.signalBlock(signal);
                });
            }
        }
    });
}
- (id (^)(NSInteger row, NSInteger section))cell {
    return ^id (NSInteger row, NSInteger section) {
        return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    };
}
- (id (^)(NSInteger row, NSInteger section))indexPath {
    return ^id (NSInteger row, NSInteger section) {
        return [NSIndexPath indexPathForRow:row inSection:section];
    };
}
- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}
- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}
- (NSString *)string {
    return [NSString stringWithFormat:@"%p", self];
}
#pragma mark - UITableViewDatasource  & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.tableDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.tableDelegate numberOfSectionsInTableView:self];
    }else if (self.numberOfSectionsBlock) {
        return self.numberOfSectionsBlock();
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tableDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.tableDelegate tableView:tableView numberOfRowsInSection:section];
    }else if (self.numberOfCellsBlock) {
        return self.numberOfCellsBlock(section);
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.tableDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.tableDelegate tableView:tableView heightForHeaderInSection:section];
    }else if (self.heightForHeaderBlock) {
        return self.heightForHeaderBlock(section);
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.tableDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.tableDelegate tableView:tableView heightForFooterInSection:section];
    }else if (self.heightForFooterBlock) {
        return self.heightForFooterBlock(section);
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.tableDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }else if (self.heightForCellBlock) {
        return self.heightForCellBlock(indexPath);
    }
    return 0.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __block UITableViewHeaderFooterView *cell = nil;
    id (^HCellForHeaderBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:[self string]];
        identifier = [identifier stringByAppendingString:@"HeaderCell"];
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:@(section).stringValue];
        if (![self.allReuseCells containsObject:identifier]) {
            [self.allReuseCells addObject:identifier];
            [self registerClass:cls forHeaderFooterViewReuseIdentifier:identifier];
            cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
            HBaseHeaderFooterView *tmpCell = (HBaseHeaderFooterView *)cell;
            tmpCell.table = self;
            tmpCell.section = section;
            //init method
            if (iblk) {
                HTableCellInitBlock initHeaderBlock = iblk;
                if (initHeaderBlock) {
                    initHeaderBlock(self);
                }
            }
        }else {
            cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HBaseHeaderFooterView *)cell layoutContentView];
        }
        return cell;
    };
    if ([self.tableDelegate respondsToSelector:@selector(tableView:headerTuple:inSection:)]) {
        [self.tableDelegate tableView:self headerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForHeaderBlock(iblk, cls, pre, idx);
        } inSection:section];
    }else if (self.headerTableBlock) {
        self.headerTableBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForHeaderBlock(iblk, cls, pre, idx);
        }, section);
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    __block UITableViewHeaderFooterView *cell = nil;
    id (^HCellForFooterBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:[self string]];
        identifier = [identifier stringByAppendingString:@"FooterCell"];
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:@(section).stringValue];
        if (![self.allReuseCells containsObject:identifier]) {
            [self.allReuseCells addObject:identifier];
            [self registerClass:cls forHeaderFooterViewReuseIdentifier:identifier];
            cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
            HBaseHeaderFooterView *tmpCell = (HBaseHeaderFooterView *)cell;
            tmpCell.table = self;
            tmpCell.section = section;
            //init method
            if (iblk) {
                HTableCellInitBlock initFooterBlock = iblk;
                if (initFooterBlock) {
                    initFooterBlock(self);
                }
            }
        }else {
            cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HBaseHeaderFooterView *)cell layoutContentView];
        }
        return cell;
    };
    if ([self.tableDelegate respondsToSelector:@selector(tableView:footerTuple:inSection:)]) {
        [self.tableDelegate tableView:self footerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForFooterBlock(iblk, cls, pre, idx);
        } inSection:section];
    }else if (self.footerTableBlock) {
        self.footerTableBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForFooterBlock(iblk, cls, pre, idx);
        }, section);
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UITableViewCell *cell = nil;
    id (^HCellForItemBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:[self string]];
        identifier = [identifier stringByAppendingString:@"ItemCell"];
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:[indexPath string]];
        if (![self.allReuseCells containsObject:identifier]) {
            [self.allReuseCells addObject:identifier];
            [self registerClass:cls forCellReuseIdentifier:identifier];
            cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            HBaseCell *tmpCell = (HBaseCell *)cell;
            tmpCell.table = self;
            tmpCell.indexPath = indexPath;
            //init method
            if (iblk) {
                HTableCellInitBlock initCellBlock = iblk;
                if (initCellBlock) {
                    initCellBlock(self);
                }
            }
        }else {
            cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HBaseCell *)cell layoutContentView];
        }
        return cell;
    };
    if ([self.tableDelegate respondsToSelector:@selector(tableView:cellTuple:atIndexPath:)]) {
        [self.tableDelegate tableView:self cellTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForItemBlock(iblk, cls, pre, idx);
        } atIndexPath:indexPath];
    }else if (self.cellTableBlock) {
        self.cellTableBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForItemBlock(iblk, cls, pre, idx);
        }, indexPath);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.tableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tableDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else if (self.didSelectCellBlock) {
        self.didSelectCellBlock(indexPath);
    }
}
#pragma mark - UITableView Block
- (void)tableWithSections:(HANumberOfSectionsBlock)sections cells:(HNumberOfCellsBlock)cells {
    self.numberOfSectionsBlock = sections;
    self.numberOfCellsBlock = cells;
}
- (void)headerWithHeight:(HeightForHeaderBlock)height tuple:(HHeaderTableBlock)block {
    self.heightForHeaderBlock = height;
    self.headerTableBlock = block;
}
- (void)footerWithHeight:(HeightForFooterBlock)height tuple:(HFooterTableBlock)block {
    self.heightForFooterBlock = height;
    self.footerTableBlock = block;
}
- (void)cellWithHeight:(HeightForCellBlock)height tuple:(HCellTableBlock)block {
    self.heightForCellBlock = height;
    self.cellTableBlock = block;
}
- (void)didSelectCell:(HDidSelectCellBlock)block {
    self.didSelectCellBlock = block;
}
- (void)deselectCell:(NSIndexPath *)indexPath {
    if (indexPath) {
        [self deselectRowAtIndexPath:indexPath animated:YES];
    }
}
@end
