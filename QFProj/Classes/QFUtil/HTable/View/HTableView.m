//
//  HTableView.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableView.h"
#import <objc/runtime.h>

typedef NS_OPTIONS(NSUInteger, HTableDesignStyle) {
    HTableDesignStyleSection = 0,
    HTableDesignStyleTable
};

#define KDefaultPageSize  20
#define KSectionDesignKey @"section"
#define KTableDesignKey   @"table"

@interface NSIndexPath (HTableView)
- (NSString *)string;
@end

@implementation NSIndexPath (HTableView)
- (NSString *)string {
    return [NSString stringWithFormat:@"%@%@",@(self.section),@(self.row)];
}
@end

@interface HTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) BOOL categoryDesign;
@property (nonatomic) NSInteger designSections;
@property (nonatomic) HTableDesignStyle designStyle;

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
+ (instancetype)sectionDesignWith:(CGRect)frame andSections:(NSInteger)sections {
    return [[HTableView alloc] initWithFrame:frame designStyle:HTableDesignStyleSection designSection:sections];
}
+ (instancetype)tupleDesignWith:(CGRect)frame {
    return [[HTableView alloc] initWithFrame:frame designStyle:HTableDesignStyleTable designSection:0];
}
- (instancetype)initWithFrame:(CGRect)frame designStyle:(HTableDesignStyle)style designSection:(NSInteger)sections {
    self = [super initWithFrame:frame];
    if (self) {
        _designStyle = style;
        _categoryDesign = YES;
        _designSections = sections;
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
- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    if ([super respondsToSelector:@selector(setSeparatorInset:)]) {
        [super setSeparatorInset:separatorInset];
    }
    if ([super respondsToSelector:@selector(setLayoutMargins:)]) {
        [super setLayoutMargins:separatorInset];
    }
}
- (NSUInteger)pageNo {
    if (_pageNo <= 0) {
        return 1;
    }
    return _pageNo;
}
- (NSUInteger)pageSize {
    if (_pageSize <= 0) {
        return KDefaultPageSize;
    }
    return _pageSize;
}
- (NSUInteger)totalNo {
    if (_totalNo <= 0) {
        return MAXFLOAT;
    }
    return _totalNo;
}
- (void)beginRefreshing:(void (^)(void))completion {
    if (_refreshBlock) {
        [self setPageNo:1];
        [self.mj_header beginRefreshingWithCompletionBlock:completion];
    }
}
//stop refresh
- (void)endRefreshing:(void (^)(void))completion {
    [self.mj_header endRefreshingWithCompletionBlock:completion];
}
- (void)endLoadMore:(void (^)(void))completion {
    [self.mj_footer endRefreshingWithCompletionBlock:completion];
}
- (void)setRefreshBlock:(HRefreshTableBlock)refreshBlock {
    _refreshBlock = refreshBlock;
    if (_refreshBlock) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self setPageNo:1];
            self->_refreshBlock();
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
            if (self.pageSize*self.pageNo < self.totalNo) {
                self->_loadMoreBlock();
            }else {
                [self.mj_footer endRefreshing];
            }
        }];
    }else {
        self.mj_footer = nil;
    }
}
#pragma mark - UITableViewDatasource & delegate
- (NSString *)tableWithPrefix:(NSInteger)section {
    NSString *prefix = nil;
    if (_categoryDesign) {
        if (self.designStyle == HTableDesignStyleSection) {
            prefix = [KSectionDesignKey stringByAppendingFormat:@"%@", @(section)];
        }else if (self.designStyle == HTableDesignStyleTable) {
            prefix = [KTableDesignKey stringByAppendingFormat:@"%@", @(self.tableState)];
        }
    }
    return prefix;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.tableDelegate numberOfSectionsInTableView:self];
    }else if (_categoryDesign) {
        if (self.designStyle == HTableDesignStyleSection) {
            return _designSections;
        }else if (self.designStyle == HTableDesignStyleTable) {
            NSString *prefix = [KTableDesignKey stringByAppendingFormat:@"%@", @(self.tableState)];
            if ([(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
                return [[(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView] integerValue];
            }
        }
    }else if (self.numberOfSectionsBlock) {
        return self.numberOfSectionsBlock();
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *prefix = [self tableWithPrefix:section];
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.tableDelegate tableView:self numberOfRowsInSection:section];
    }else if (_categoryDesign && [(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &section] integerValue];
    }else if (self.numberOfCellsBlock) {
        return self.numberOfCellsBlock(section);
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *prefix = [self tableWithPrefix:section];
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.tableDelegate tableView:self heightForHeaderInSection:section];
    }else if (_categoryDesign && [(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &section] integerValue];
    }else if (self.heightForHeaderBlock) {
        return self.heightForHeaderBlock(section);
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *prefix = [self tableWithPrefix:section];
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.tableDelegate tableView:self heightForFooterInSection:section];
    }else if (_categoryDesign && [(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &section] integerValue];
    }else if (self.heightForFooterBlock) {
        return self.heightForFooterBlock(section);
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tableWithPrefix:indexPath.section];
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.tableDelegate tableView:self heightForRowAtIndexPath:indexPath];
    }else if (_categoryDesign && [(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &indexPath] integerValue];
    }else if (self.heightForCellBlock) {
        return self.heightForCellBlock(indexPath);
    }
    return 0.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __block UITableViewHeaderFooterView *cell = nil;
    @weakify(self)
    id (^HCellForHeaderBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        @strongify(self)
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:[self string]];
        identifier = [identifier stringByAppendingString:@"HeaderCell"];
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:@(section).stringValue];
        if (![self.allReuseCells containsObject:identifier]) {
            [self.allReuseCells addObject:identifier];
            [self registerClass:cls forHeaderFooterViewReuseIdentifier:identifier];
            cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
            HBaseHeaderFooterView *tmpCell = (HBaseHeaderFooterView *)cell;
            tmpCell.table = self;
            tmpCell.section = section;
            tmpCell.isHeader = YES;
            //init method
            if (iblk) {
                HTableCellInitBlock initHeaderBlock = iblk;
                if (initHeaderBlock) {
                    initHeaderBlock(cell);
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
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:headerTuple:inSection:)]) {
        [self.tableDelegate tableView:self headerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForHeaderBlock(iblk, cls, pre, idx);
        } inSection:section];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tableView:headerTuple:inSection:)]) {
        [self tableView:self headerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
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
    @weakify(self)
    id (^HCellForFooterBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        @strongify(self)
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:[self string]];
        identifier = [identifier stringByAppendingString:@"FooterCell"];
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:@(section).stringValue];
        if (![self.allReuseCells containsObject:identifier]) {
            [self.allReuseCells addObject:identifier];
            [self registerClass:cls forHeaderFooterViewReuseIdentifier:identifier];
            cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
            HBaseHeaderFooterView *tmpCell = (HBaseHeaderFooterView *)cell;
            tmpCell.table = self;
            tmpCell.section = section;
            tmpCell.isHeader = NO;
            //init method
            if (iblk) {
                HTableCellInitBlock initFooterBlock = iblk;
                if (initFooterBlock) {
                    initFooterBlock(cell);
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
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:footerTuple:inSection:)]) {
        [self.tableDelegate tableView:self footerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForFooterBlock(iblk, cls, pre, idx);
        } inSection:section];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tableView:footerTuple:inSection:)]) {
        [self tableView:self footerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForFooterBlock(iblk, cls, pre, idx);
        } inSection:section];
    }else if (self.footerTableBlock) {
        self.footerTableBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForFooterBlock(iblk, cls, pre, idx);
        }, section);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:self.separatorInset];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:self.separatorInset];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UITableViewCell *cell = nil;
    @weakify(self)
    id (^HCellForItemBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        @strongify(self)
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:[self string]];
        identifier = [identifier stringByAppendingString:@"ItemCell"];
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:[indexPath string]];
        if (![self.allReuseCells containsObject:identifier]) {
            [self.allReuseCells addObject:identifier];
            [self registerClass:cls forCellReuseIdentifier:identifier];
            cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            HTableBaseCell *tmpCell = (HTableBaseCell *)cell;
            tmpCell.table = self;
            tmpCell.indexPath = indexPath;
            //init method
            if (iblk) {
                HTableCellInitBlock initCellBlock = iblk;
                if (initCellBlock) {
                    initCellBlock(cell);
                }
            }
        }else {
            cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HTableBaseCell *)cell layoutContentView];
        }
        return cell;
    };
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:cellTuple:atIndexPath:)]) {
        [self.tableDelegate tableView:self cellTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForItemBlock(iblk, cls, pre, idx);
        } atIndexPath:indexPath];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tableView:cellTuple:atIndexPath:)]) {
        [self tableView:self cellTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
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
    NSString *prefix = [self tableWithPrefix:indexPath.section];
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tableDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }else if (_categoryDesign && [(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &indexPath];
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
#pragma mark - Category & Design
- (void)tableView:(UITableView *)tableView headerTuple:(HHeaderTable)headerBlock inSection:(NSInteger)section {
    NSString *prefix = [self tableWithPrefix:section];
    if ([(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &headerBlock, &section];
    }
}
- (void)tableView:(UITableView *)tableView footerTuple:(HFooterTable)footerBlock inSection:(NSInteger)section {
    NSString *prefix = [self tableWithPrefix:section];
    if ([(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &footerBlock, &section];
    }
}
- (void)tableView:(UITableView *)tableView cellTuple:(HCellTable)cellBlock atIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tableWithPrefix:indexPath.section];
    if ([(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &cellBlock, &indexPath];
    }
}
@end

@implementation HTableView (HSignal)
- (HTableState)tableState {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setTableState:(HTableState)tableState {
    if (self.tableState != tableState) {
        objc_setAssociatedObject(self, @selector(tableState), @(tableState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self reloadData];
    }
}

- (HTableCellSignalBlock)signalBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSignalBlock:(HTableCellSignalBlock)signalBlock {
    objc_setAssociatedObject(self, @selector(signalBlock), signalBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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
                    cell.signalBlock(signal);
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
                cell.signalBlock(signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal indexPath:(NSIndexPath *)indexPath  {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (cell.signalBlock) {
            cell.signalBlock(signal);
        }
    });
}
- (void)signalToAllHeader:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            UITableViewHeaderFooterView *header = [self headerViewForSection:i];
            if (header && header.signalBlock) {
                header.signalBlock(signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal headerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewHeaderFooterView *header = [self headerViewForSection:section];
        if (header && header.signalBlock) {
            header.signalBlock(signal);
        }
    });
}
- (void)signalToAllFooter:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            UITableViewHeaderFooterView *footer = [self footerViewForSection:i];
            if (footer && footer.signalBlock) {
                footer.signalBlock(signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal footerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewHeaderFooterView *footer = [self footerViewForSection:section];
        if (footer && footer.signalBlock) {
            footer.signalBlock(signal);
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
@end
