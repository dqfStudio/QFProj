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

@interface HTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) BOOL categoryDesign;
@property (nonatomic) NSInteger designSections;
@property (nonatomic) HTableDesignStyle designStyle;

@property (nonatomic) NSMutableSet *allReuseIdentifiers;
@property (nonatomic) NSMapTable   *allReuseCells;
@property (nonatomic) NSMapTable   *allReuseHeaders;
@property (nonatomic) NSMapTable   *allReuseFooters;

@property (nonatomic, copy) NSArray <NSString *> *headerIndexPaths;
@property (nonatomic, copy) NSArray <NSString *> *footerIndexPaths;
@property (nonatomic, copy) NSArray <NSString *> *itemIndexPaths;

@property (nonatomic, copy) HANumberOfSectionsBlock numberOfSectionsBlock;
@property (nonatomic, copy) HNumberOfCellsBlock numberOfCellsBlock;

@property (nonatomic, copy) HeightForHeaderBlock heightForHeaderBlock;
@property (nonatomic, copy) HeightForFooterBlock heightForFooterBlock;
@property (nonatomic, copy) HeightForCellBlock heightForCellBlock;

@property (nonatomic, copy) HHeaderTableBlock headerTableBlock;
@property (nonatomic, copy) HFooterTableBlock footerTableBlock;
@property (nonatomic, copy) HCellTableBlock cellTableBlock;

@property (nonatomic, copy) HCellWillDisplayBlock cellWillDisplayBlock;
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
    return [[HTableView alloc] initWithFrame:frame designStyle:HTableDesignStyleSection designSection:sections headers:nil footers:nil items:nil];
}
+ (instancetype)tableDesignWith:(CGRect (^)(void))frame exclusiveHeaders:(HTableExclusiveForHeaderBlock)headers exclusiveFooters:(HTableExclusiveForFooterBlock)footers exclusiveItems:(HTableExclusiveForItemBlock)items {
    return [[HTableView alloc] initWithFrame:frame() designStyle:HTableDesignStyleTable designSection:0 headers:headers() footers:footers() items:items()];
}
- (instancetype)initWithFrame:(CGRect)frame designStyle:(HTableDesignStyle)style designSection:(NSInteger)sections headers:(NSArray <NSString *> *)headerIndexPaths footers:(NSArray <NSString *> *)footerIndexPaths items:(NSArray <NSString *> *)itemIndexPaths {
    self = [super initWithFrame:frame];
    if (self) {
        _designStyle = style;
        _categoryDesign = YES;
        _designSections = sections;
        self.headerIndexPaths = headerIndexPaths;
        self.footerIndexPaths = footerIndexPaths;
        self.itemIndexPaths = itemIndexPaths;
        [self setup];
    }
    return self;
}
- (void)setup {
    self.alwaysBounceVertical = YES;
    self.backgroundColor = UIColor.clearColor;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    _allReuseIdentifiers = [NSMutableSet new];
    _allReuseCells   = [NSMapTable strongToWeakObjectsMapTable];
    _allReuseHeaders = [NSMapTable strongToWeakObjectsMapTable];
    _allReuseFooters = [NSMapTable strongToWeakObjectsMapTable];
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
#pragma --mark bounce
- (void)horizontalBounceEnabled {
    self.bounces = YES;
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = NO;
}
- (void)verticalBounceEnabled {
    self.bounces = YES;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = YES;
}
- (void)bounceEnabled {
    self.bounces = YES;
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = YES;
}
- (void)bounceDisenable {
    self.bounces = NO;
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
        @www
        self.mj_header = [HTableRefresh refreshHeaderWithStyle:_refreshHeaderStyle andBlock:^{
            @sss
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
        @www
        self.mj_footer = [HTableRefresh refreshFooterWithStyle:_refreshFooterStyle andBlock:^{
            @sss
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
- (void)setReleaseTableKey:(NSString *)releaseTableKey {
    if (_releaseTableKey != releaseTableKey) {
        if (_releaseTableKey && releaseTableKey) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:_releaseTableKey object:nil];
        }
        _releaseTableKey = releaseTableKey;
        if (releaseTableKey) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseTableBlock) name:releaseTableKey object:nil];
        }
    }
}
- (NSString *)addressValue {
    return [NSString stringWithFormat:@"%p", self];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    id (^HCellForHeaderBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:self.addressValue];
        identifier = [identifier stringByAppendingString:@"HeaderCell"];
        if (![self.headerIndexPaths containsObject:@(section).stringValue]) {
            identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
        }
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:@(section).stringValue];
        if (![self.allReuseIdentifiers containsObject:identifier]) {
            [self.allReuseIdentifiers addObject:identifier];
            [self registerClass:cls forHeaderFooterViewReuseIdentifier:identifier];
            cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
            HTableBaseApex *tmpCell = (HTableBaseApex *)cell;
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
        [self.allReuseHeaders setObject:cell forKey:@(section).stringValue];
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HTableBaseApex *)cell layoutContentView];
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
    id (^HCellForFooterBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:self.addressValue];
        identifier = [identifier stringByAppendingString:@"FooterCell"];
        if (![self.footerIndexPaths containsObject:@(section).stringValue]) {
            identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
        }
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:@(section).stringValue];
        if (![self.allReuseIdentifiers containsObject:identifier]) {
            [self.allReuseIdentifiers addObject:identifier];
            [self registerClass:cls forHeaderFooterViewReuseIdentifier:identifier];
            cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
            HTableBaseApex *tmpCell = (HTableBaseApex *)cell;
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
        [self.allReuseFooters setObject:cell forKey:@(section).stringValue];
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HTableBaseApex *)cell layoutContentView];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UITableViewCell *cell = nil;
    id (^HCellForItemBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:self.addressValue];
        identifier = [identifier stringByAppendingString:@"ItemCell"];
        if (![self.itemIndexPaths containsObject:indexPath.stringValue]) {
            identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
        }
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:indexPath.stringValue];
        if (![self.allReuseIdentifiers containsObject:identifier]) {
            [self.allReuseIdentifiers addObject:identifier];
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
        [self.allReuseCells setObject:cell forKey:indexPath.stringValue];
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:self.separatorInset];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:self.separatorInset];
        }
    }
    NSString *prefix = [self tableWithPrefix:indexPath.section];
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        [self.tableDelegate tableView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
    }else if (_categoryDesign && [(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &cell, &indexPath];
    }else if (self.cellWillDisplayBlock) {
        self.cellWillDisplayBlock(cell, indexPath);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tableWithPrefix:indexPath.section];
    if (!_categoryDesign && [self.tableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tableDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }else if (_categoryDesign && [(NSObject *)self.tableDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tableView, &indexPath];
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
- (void)cellWillDisplayBlock:(HCellWillDisplayBlock)block {
    self.cellWillDisplayBlock = block;
}
- (void)didSelectCell:(HDidSelectCellBlock)block {
    self.didSelectCellBlock = block;
}
- (void)deselectCell:(NSIndexPath *)indexPath {
    if (indexPath) {
        [self deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)releaseTableBlock {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        
        [self releaseAllSignal];
        [self clearTableState];
        
        if (self.tableDelegate) self.tableDelegate = nil;
        if (self.refreshBlock) self.refreshBlock = nil;
        if (self.loadMoreBlock) self.loadMoreBlock = nil;
        
        if (self.numberOfSectionsBlock) self.numberOfSectionsBlock = nil;
        if (self.numberOfCellsBlock) self.numberOfCellsBlock = nil;
        
        if (self.heightForHeaderBlock) self.heightForHeaderBlock = nil;
        if (self.headerTableBlock) self.headerTableBlock = nil;
        
        if (self.heightForFooterBlock) self.heightForFooterBlock = nil;
        if (self.footerTableBlock) self.footerTableBlock = nil;
        
        if (self.heightForCellBlock) self.heightForCellBlock = nil;
        if (self.cellTableBlock) self.cellTableBlock = nil;
        
        if (self.cellWillDisplayBlock) self.cellWillDisplayBlock = nil;
        
        if (self.didSelectCellBlock) self.didSelectCellBlock = nil;
    });
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
- (HTableCellSignalBlock)signalBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSignalBlock:(HTableCellSignalBlock)signalBlock {
    objc_setAssociatedObject(self, @selector(signalBlock), signalBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)signalToTable:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        if (self.signalBlock) {
            self.signalBlock(self, signal);
        }
    });
}
- (void)signalToAllCells:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSInteger cells = [self numberOfRowsInSection:i];
            for (int j=0; j<cells; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UITableViewCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
                if (cell.signalBlock) {
                    cell.signalBlock(cell, signal);
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
            UITableViewCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
            if (cell.signalBlock) {
                cell.signalBlock(cell, signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal indexPath:(NSIndexPath *)indexPath  {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
        if (cell.signalBlock) {
            cell.signalBlock(cell, signal);
        }
    });
}
- (void)signalToAllHeader:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            UITableViewHeaderFooterView *header = [self.allReuseHeaders objectForKey:@(i).stringValue];
            if (header.signalBlock) {
                header.signalBlock(header, signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal headerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewHeaderFooterView *header = [self.allReuseHeaders objectForKey:@(section).stringValue];
        if (header.signalBlock) {
            header.signalBlock(header, signal);
        }
    });
}
- (void)signalToAllFooter:(HTableSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            UITableViewHeaderFooterView *footer = [self.allReuseFooters objectForKey:@(i).stringValue];
            if (footer.signalBlock) {
                footer.signalBlock(footer, signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal footerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UITableViewHeaderFooterView *footer = [self.allReuseFooters objectForKey:@(section).stringValue];
        if (footer.signalBlock) {
            footer.signalBlock(footer, signal);
        }
    });
}
- (void)releaseAllSignal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        if (self.signalBlock) self.signalBlock = nil;
        NSInteger sections = [self numberOfSections];
        //release all cell
        if (self.allReuseCells.count > 0) {
            for (int i=0; i<sections; i++) {
                NSInteger cells = [self numberOfRowsInSection:i];
                for (int j=0; j<cells; j++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    UITableViewCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
                    if (cell.signalBlock) {
                        cell.signalBlock = nil;
                    }
                }
            }
        }
        //release all header
        if (self.allReuseHeaders.count > 0) {
            for (int i=0; i<sections; i++) {
                UITableViewHeaderFooterView *header = [self.allReuseHeaders objectForKey:@(i).stringValue];
                if (header.signalBlock) {
                    header.signalBlock = nil;
                }
            }
        }
        //release all footer
        if (self.allReuseFooters.count > 0) {
            for (int i=0; i<sections; i++) {
                UITableViewHeaderFooterView *footer = [self.allReuseFooters objectForKey:@(i).stringValue];
                if (footer.signalBlock) {
                    footer.signalBlock = nil;
                }
            }
        }
    });
}
- (id (^)(NSInteger row, NSInteger section))cell {
    return ^id (NSInteger row, NSInteger section) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        return [self.allReuseCells objectForKey:indexPath.stringValue];
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
- (CGSize)size {
    return self.frame.size;
}
@end

#define KTableStateKey   @"_table_"

@interface HTableView (HStateSource)
@property (nonatomic) NSMutableDictionary *tableStateSource;
@end

@implementation HTableView (HState)
- (NSMutableDictionary *)tableStateSource {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = NSMutableDictionary.new;
        [self setTableStateSource:dict];
    }
    return dict;
}
- (void)setTableStateSource:(NSMutableDictionary *)tableStateSource {
    objc_setAssociatedObject(self, @selector(tableStateSource), tableStateSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HTableState)tableState {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setTableState:(HTableState)tableState {
    if (self.tableState != tableState) {
        objc_setAssociatedObject(self, @selector(tableState), @(tableState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self reloadData];
    }
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey {
    [self setObject:anObject forKey:aKey state:self.tableState];
}
- (void)setObject:(id)anObject forKey:(NSString *)aKey state:(HTableState)tableState {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", aKey, KTableStateKey, @(tableState)];
    [self.tableStateSource setObject:anObject forKey:key];
}

- (nullable id)objectForKey:(NSString *)aKey {
    return [self objectForKey:aKey state:self.tableState];
}
- (nullable id)objectForKey:(NSString *)aKey state:(HTableState)tableState {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", aKey, KTableStateKey, @(tableState)];
    return [self.tableStateSource objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)aKey {
    [self removeObjectForKey:aKey state:self.tableState];
}
- (void)removeObjectForKey:(NSString *)aKey state:(HTableState)tableState {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", aKey, KTableStateKey, @(tableState)];
    if ([self.tableStateSource.allKeys containsObject:key]) {
        [self.tableStateSource removeObjectForKey:key];
    }
}

- (void)removeStateObject {
    [self removeObjectForState:self.tableState];
}
- (void)removeObjectForState:(HTableState)tableState {
    NSString *key = [NSString stringWithFormat:@"%@%@", KTableStateKey, @(tableState)];
    for (NSUInteger i=self.tableStateSource.allKeys.count-1; i>=0; i--) {
        NSString *akey = self.tableStateSource.allKeys[i];
        if ([akey containsString:key]) {
            [self.tableStateSource removeObjectForKey:akey];
        }
    }
}

- (void)clearTableState {
    if (self.tableStateSource.count > 0) {
        [self.tableStateSource removeAllObjects];
    }
}
@end
