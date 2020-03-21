//
//  HTableView.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableView.h"
#import <objc/runtime.h>

typedef NS_OPTIONS(NSUInteger, HTableStyle) {
    HTableStyleDefault = 0, //单体式设计
    HTableStyleSplit //分体式设计
};

#define KTableDefaultTag    1615141312

#define KDefaultPageSize    20
#define KTableDesignKey     @"table"
#define KTableExaDesignKey  @"tableExa"

@interface HTableAppearance ()
@property (nonatomic) NSHashTable *hashTables;
@end

@implementation HTableAppearance
+ (instancetype)appearance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)addTable:(id)anTable {
    if (!self.hashTables) {
        self.hashTables = [NSHashTable weakObjectsHashTable];
    }
    [self.hashTables addObject:anTable];
}
- (void)enumerateTables:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *allObjects = [[self.hashTables objectEnumerator] allObjects];
        //倒序执行
        for (NSUInteger i=allObjects.count-1; i>=0; i--) {
            HTableView *table = allObjects[i];
            [table reloadData];
        }
        if (completion) {
            completion();
        }
    });
}
@end

@interface HTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) HTableStyle tableStyle;

@property (nonatomic) NSMutableSet *allReuseIdentifiers;
@property (nonatomic) NSMapTable *allReuseCells;
@property (nonatomic) NSMutableDictionary *allReuseHeaders;
@property (nonatomic) NSMutableDictionary *allReuseFooters;

@property (nonatomic, copy) NSArray <NSNumber *> *sectionPaths;

@end

@implementation HTableView

#pragma mark - init methods
#pragma mark -
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
+ (instancetype)tableFrame:(CGRect (^)(void))frame exclusiveSections:(HTableSectionExclusiveBlock)sections {
    return [[HTableView alloc] initWithFrame:frame() exclusiveSections:sections()];
}
- (instancetype)initWithFrame:(CGRect)frame exclusiveSections:(NSArray <NSNumber *> *)sectionPaths {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableStyle = HTableStyleSplit;
        self.sectionPaths = sectionPaths;
        [self setup];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        [self reloadData];
    }
}
- (void)setup {
    //保存tableView用于全局刷新
    [[HTableAppearance appearance] addTable:self];
    
    //设置默认tag
    self.tag = KTableDefaultTag;
    
    self.alwaysBounceVertical = YES;
    self.backgroundColor = UIColor.clearColor;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        if (@available(iOS 13.0, *)) {
            self.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    _allReuseIdentifiers = [NSMutableSet new];
    _allReuseCells   = [NSMapTable strongToWeakObjectsMapTable];
    _allReuseHeaders = [NSMutableDictionary new];
    _allReuseFooters = [NSMutableDictionary new];
    self.tableFooterView = [UIView new];
    super.delegate = self;
    super.dataSource = self;
}

#pragma mark - bounce
#pragma mark -
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

#pragma mark - 间隔线
#pragma mark -
//屏蔽系统UITableViewCell的间隔线style
- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle {
    super.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
//    if ([super respondsToSelector:@selector(setSeparatorInset:)]) {
//        [super setSeparatorInset:separatorInset];
//    }
//    if ([super respondsToSelector:@selector(setLayoutMargins:)]) {
//        [super setLayoutMargins:separatorInset];
//    }
//}
#pragma mark - refresh methods
#pragma mark -
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
- (void)setRefreshBlock:(HTableRefreshBlock)refreshBlock {
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
- (void)setLoadMoreBlock:(HTableLoadMoreBlock)loadMoreBlock {
    _loadMoreBlock = loadMoreBlock;
    if (_loadMoreBlock) {
        [self setPageNo:1];
        @www
        self.mj_footer = [HTableRefresh refreshFooterWithStyle:_refreshFooterStyle andBlock:^{
            @sss
            self.pageNo += 1;
            if (self.pageSize *self.pageNo < self.totalNo) {
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
- (void)setReloadTableKey:(NSString *)reloadTableKey {
    if (_reloadTableKey != reloadTableKey) {
        if (_reloadTableKey && reloadTableKey) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:_reloadTableKey object:nil];
        }
        _reloadTableKey = reloadTableKey;
        if (reloadTableKey) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:reloadTableKey object:nil];
        }
    }
}
- (void)reloadTableData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}
- (NSString *)addressValue {
    return [NSString stringWithFormat:@"%p", self];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - register class
#pragma mark -
- (id)dequeueReusableHeaderWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx section:(NSInteger)section {
    UITableViewHeaderFooterView *cell = nil;
    NSString *identifier = NSStringFromClass(cls);
    identifier = [identifier stringByAppendingString:self.addressValue];
    identifier = [identifier stringByAppendingString:@"HeaderCell"];
    if (self.tableStyle == HTableStyleSplit && ![self.sectionPaths containsObject:@(section)]) {
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
    }
    if (pre) identifier = [identifier stringByAppendingString:pre];
    if (idx) identifier = [identifier stringByAppendingString:@(section).stringValue];
    
    CGFloat height = [self tableView:self heightForHeaderInSection:section];
    
    if (![self.allReuseIdentifiers containsObject:identifier]) {
        [self.allReuseIdentifiers addObject:identifier];
        [self registerClass:cls forHeaderFooterViewReuseIdentifier:identifier];
        cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        [self.allReuseHeaders setObject:cell forKey:@(section).stringValue];
        HTableBaseApex *tmpCell = (HTableBaseApex *)cell;
        tmpCell.table = self;
        tmpCell.section = section;
        tmpCell.isHeader = YES;
        tmpCell.size = CGSizeMake(self.frame.size.width, height);
        //init method
        if (iblk) {
            HTableCellInitBlock initHeaderBlock = iblk;
            if (initHeaderBlock) {
                initHeaderBlock(cell);
            }
        }
    }else {
        cell = [self.allReuseHeaders objectForKey:@(section).stringValue];
    }
    //设置高度
    HTableBaseApex *tmpCell = (HTableBaseApex *)cell;
    tmpCell.size = CGSizeMake(self.frame.size.width, height);
    //调用代理方法
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(edgeInsetsForHeaderInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        edgeInsets = [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section] UIEdgeInsetsValue];
    }
    //设置属性
    if ([cell respondsToSelector:@selector(edgeInsets)]) {
        [(HTableBaseApex *)cell setEdgeInsets:edgeInsets];
    }
    return cell;
}
- (id)dequeueReusableFooterWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx section:(NSInteger)section {
    UITableViewHeaderFooterView *cell = nil;
    NSString *identifier = NSStringFromClass(cls);
    identifier = [identifier stringByAppendingString:self.addressValue];
    identifier = [identifier stringByAppendingString:@"FooterCell"];
    if (self.tableStyle == HTableStyleSplit && ![self.sectionPaths containsObject:@(section)]) {
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
    }
    if (pre) identifier = [identifier stringByAppendingString:pre];
    if (idx) identifier = [identifier stringByAppendingString:@(section).stringValue];
    
    CGFloat height = [self tableView:self heightForFooterInSection:section];
    
    if (![self.allReuseIdentifiers containsObject:identifier]) {
        [self.allReuseIdentifiers addObject:identifier];
        [self registerClass:cls forHeaderFooterViewReuseIdentifier:identifier];
        cell = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        [self.allReuseFooters setObject:cell forKey:@(section).stringValue];
        HTableBaseApex *tmpCell = (HTableBaseApex *)cell;
        tmpCell.table = self;
        tmpCell.section = section;
        tmpCell.isHeader = NO;
        tmpCell.size = CGSizeMake(self.frame.size.width, height);
        //init method
        if (iblk) {
            HTableCellInitBlock initFooterBlock = iblk;
            if (initFooterBlock) {
                initFooterBlock(cell);
            }
        }
    }else {
        cell = [self.allReuseFooters objectForKey:@(section).stringValue];
    }
    //设置高度
    HTableBaseApex *tmpCell = (HTableBaseApex *)cell;
    tmpCell.size = CGSizeMake(self.frame.size.width, height);
    //调用代理方法
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(edgeInsetsForFooterInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        edgeInsets = [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section] UIEdgeInsetsValue];
    }
    //设置属性
    if ([cell respondsToSelector:@selector(edgeInsets)]) {
        [(HTableBaseApex *)cell setEdgeInsets:edgeInsets];
    }
    return cell;
}
- (id)dequeueReusableCellWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath {
    UITableViewCell *cell = nil;
    NSString *identifier = NSStringFromClass(cls);
    identifier = [identifier stringByAppendingString:self.addressValue];
    identifier = [identifier stringByAppendingString:@"ItemCell"];
    if (self.tableStyle == HTableStyleSplit && ![self.sectionPaths containsObject:@(idxPath.section)]) {
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tableState)];
    }
    if (pre) identifier = [identifier stringByAppendingString:pre];
    if (idx) identifier = [identifier stringByAppendingString:idxPath.stringValue];
    if (![self.allReuseIdentifiers containsObject:identifier]) {
        [self.allReuseIdentifiers addObject:identifier];
        [self registerClass:cls forCellReuseIdentifier:identifier];
        cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:idxPath];
        HTableBaseCell *tmpCell = (HTableBaseCell *)cell;
        tmpCell.table = self;
        tmpCell.indexPath = idxPath;
        //init method
        if (iblk) {
            HTableCellInitBlock initCellBlock = iblk;
            if (initCellBlock) {
                initCellBlock(cell);
            }
        }
    }else {
        cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:idxPath];
    }
    //保存cell
    [self.allReuseCells setObject:cell forKey:idxPath.stringValue];
    //调用代理方法
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    NSString *prefix = [self tablePrefixWithSection:idxPath.section];
    SEL selector = @selector(edgeInsetsForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        edgeInsets = [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&idxPath] UIEdgeInsetsValue];
    }
    //设置属性
    if ([cell respondsToSelector:@selector(edgeInsets)]) {
        [(HTableBaseCell *)cell setEdgeInsets:edgeInsets];
    }
    return cell;
}

#pragma mark - 获取prefix方法
#pragma mark -
- (NSString *)tablePrefix {
    NSString *prefix = @"";
    if (self.tableStyle == HTableStyleSplit) {
        prefix = [KTableDesignKey stringByAppendingFormat:@"%@_", @(self.tableState)];
    }
    return prefix;
}
- (NSString *)tableScrollSplitPrefix {
    NSString *prefix = @"";
    if (self.tableStyle == HTableStyleSplit) {
        if ([self.scrollSplitArray containsObject:@(self.tableState)]) {
            prefix = [KTableDesignKey stringByAppendingFormat:@"%@_", @(self.tableState)];
        }
    }
    return prefix;
}
- (NSString *)tablePrefixWithSection:(NSInteger)section {
    NSString *prefix = @"";
    if (self.tableStyle == HTableStyleSplit) {
        if ([self.sectionPaths containsObject:@(section)]) {
            NSInteger idx = [self.sectionPaths indexOfObject:@(section)];
            prefix = [KTableExaDesignKey stringByAppendingFormat:@"%@_", @(idx)];
        }else {
            prefix = [KTableDesignKey stringByAppendingFormat:@"%@_", @(self.tableState)];
        }
    }
    return prefix;
}

#pragma mark - 常用代理方法
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSString *prefix = [self tablePrefix];
    switch (self.tableStyle) {
        case HTableStyleDefault: {
            SEL selector = @selector(numberOfSectionsInTableView);
            if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
                return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix] integerValue];
            }
        }
            break;
        case HTableStyleSplit: {
            SEL selector = @selector(numberOfSectionsInTableView);
            if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
                return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix] integerValue];
            }
        }
            break;
        default:
            break;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(numberOfRowsInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section] integerValue];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(heightForHeaderInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section] floatValue];
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(heightForFooterInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section] floatValue];
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(heightForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] floatValue];
    }
    //不能为0.f，否则会崩溃
    return 1.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //调用代理方法
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(tableHeader:inSection:);
    HTableHeader headerBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
        return [self dequeueReusableHeaderWithClass:cls iblk:iblk pre:pre idx:idx section:section];
    };
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&headerBlock, &section];
    }
    //调用cell
    HTableBaseApex *cell = [self.allReuseHeaders objectForKey:@(section).stringValue];
    //更新布局
    if ([cell respondsToSelector:@selector(relayoutSubviews)]) {
        [cell relayoutSubviews];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //调用代理方法
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(tableFooter:inSection:);
    HTableFooter footerBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
        return [self dequeueReusableFooterWithClass:cls iblk:iblk pre:pre idx:idx section:section];
    };
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&footerBlock, &section];
    }
    //调用cell
    HTableBaseApex *cell = [self.allReuseFooters objectForKey:@(section).stringValue];
    //更新布局
    if ([cell respondsToSelector:@selector(relayoutSubviews)]) {
        [cell relayoutSubviews];
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //调用代理方法
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(tableRow:atIndexPath:);
    HTableRow cellBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
        return [self dequeueReusableCellWithClass:cls iblk:iblk pre:pre idx:idx idxPath:indexPath];
    };
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&cellBlock, &indexPath];
    }
    //调用cell
    HTableBaseCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
    //更新布局
    if ([cell respondsToSelector:@selector(relayoutSubviews)]) {
        [cell relayoutSubviews];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:self.separatorInset];
//        }
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:self.separatorInset];
//        }
//    }
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(willDisplayCell:atIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&cell, &indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTableBaseCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
    if (cell.didSelectCell) {
        cell.didSelectCell(cell, indexPath);
    }else {
        NSString *prefix = [self tablePrefixWithSection:indexPath.section];
        SEL selector = @selector(didSelectCell:atIndexPath:);
        if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
            [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&cell, &indexPath];
        }
    }
}

#pragma mark - UITableViewDataSource
#pragma mark -
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(titleForHeaderInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section];
    }
    return nil;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(titleForFooterInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section];
    }
    return nil;
}

// Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(canEditRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return YES;
}

// Moving/reordering
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(canMoveRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}

// Index
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(sectionIndexTitlesForTableView);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix];
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(sectionForSectionIndexTitle:atIndex:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&title, &index] floatValue];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(commitEditingStyle:forRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&editingStyle, &indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(moveRowAtIndexPath:toIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&sourceIndexPath, &destinationIndexPath];
    }
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(willDisplayHeaderView:forSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&view, &section];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(willDisplayFooterView:forSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&view, &section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(didEndDisplayingCell:forRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&cell, &indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(didEndDisplayingHeaderView:forSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&view, &section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(didEndDisplayingFooterView:forSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&view, &section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(estimatedHeightForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] floatValue];
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(estimatedHeightForHeaderInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section] floatValue];
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    NSString *prefix = [self tablePrefixWithSection:section];
    SEL selector = @selector(estimatedHeightForFooterInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&section] floatValue];
    }
    return 44.f;
}

// Accessories (disclosures).
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(accessoryButtonTappedForRowWithIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

// Selection
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(shouldHighlightRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(didHighlightRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(didUnhighlightRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
//    SEL selector = @selector(willSelectRowAtIndexPath:);
//    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
//        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
//    }
//    return nil;
//}
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
//    SEL selector = @selector(willDeselectRowAtIndexPath:);
//    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
//        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
//    }
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(didDeselectRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

// Editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(editingStyleForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] intValue];
    }
    return UITableViewCellEditingStyleNone;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(titleForDeleteConfirmationButtonForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
    return nil;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(editActionsForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
    return nil;
}

// Swipe actions
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(leadingSwipeActionsConfigurationForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
    return nil;
}
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(trailingSwipeActionsConfigurationForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(shouldIndentWhileEditingRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(willBeginEditingRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(didEndEditingRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

// Moving/reordering
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&sourceIndexPath, &proposedDestinationIndexPath];
    }
    return nil;
}

// Indentation
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(indentationLevelForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] integerValue];
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(shouldShowMenuForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(canPerformAction:forRowAtIndexPath:withSender:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&action, &indexPath, &sender] boolValue];
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(performAction:forRowAtIndexPath:withSender:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&action, &indexPath, &sender];
    }
}

// Focus
- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(canFocusRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(shouldUpdateFocusInContext:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&context] boolValue];
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(didUpdateFocusInContext:withAnimationCoordinator:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&context];
    }
}
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(UITableView *)tableView {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(indexPathForPreferredFocusedViewInTableView);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix];
    }
    return nil;
}

// Spring Loading
- (BOOL)tableView:(UITableView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(shouldSpringLoadRowAtIndexPath:withContext:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath, &context] boolValue];
    }
    return NO;
}

// Multiple Selection
- (BOOL)tableView:(UITableView *)tableView shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(shouldBeginMultipleSelectionInteractionAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(didBeginMultipleSelectionInteractionAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

- (void)tableViewDidEndMultipleSelectionInteraction:(UITableView *)tableView {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(tableViewDidEndMultipleSelectionInteraction);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix];
    }
}

- (nullable UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point API_AVAILABLE(ios(13.0)) {
    NSString *prefix = [self tablePrefixWithSection:indexPath.section];
    SEL selector = @selector(contextMenuConfigurationForRowAtIndexPath:point:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath, &point];
    }
    return nil;
}

- (nullable UITargetedPreview *)tableView:(UITableView *)tableView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(previewForHighlightingContextMenuWithConfiguration:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&configuration];
    }
    return nil;
}

- (nullable UITargetedPreview *)tableView:(UITableView *)tableView previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(previewForDismissingContextMenuWithConfiguration:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&configuration];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)) {
    NSString *prefix = [self tablePrefix];
    SEL selector = @selector(willPerformPreviewActionForMenuWithConfiguration:animator:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&configuration, &animator];
    }
}

#pragma mark - UIScrollViewDelegate
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewDidScroll:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewDidZoom:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewWillBeginDragging:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewWillEndDragging:withVelocity:targetContentOffset:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withMethodArgments:&scrollView, &velocity, &targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewWillEndDragging:willDecelerate:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withMethodArgments:&scrollView, &decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewWillBeginDecelerating:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewDidEndDecelerating:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewDidEndScrollingAnimation:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableViewForZoomingInScrollView:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tableDelegate performSelector:selector withMethodArgments:&scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewDidScrollToTop:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView withObject:view];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewDidEndZooming:withView:atScale:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withMethodArgments:&scrollView, &view, &scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewShouldScrollToTop:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withMethodArgments:&scrollView] boolValue];
    }
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewDidScrollToTop:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    NSString *prefix = [self tableScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tableScrollViewDidChangeAdjustedContentInset:");
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tableDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

#pragma mark - release method
#pragma mark -
- (void)releaseTableBlock {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        
        [self releaseAllSignal];
        [self clearTableState];
        
        [self.allReuseHeaders removeAllObjects];
        [self.allReuseFooters removeAllObjects];
        
        if (self.tableDelegate) self.tableDelegate = nil;
        if (self.refreshBlock) self.refreshBlock = nil;
        if (self.loadMoreBlock) self.loadMoreBlock = nil;
        
    });
}

#pragma mark - other methods
#pragma mark -
// 开始闪烁动画
- (void)startOpacityForeverAnimation {
    [self.layer addAnimation:[self opacityForeverAnimationWithDuration:2.f] forKey:NSStringFromClass(self.class)];
}
// 停止闪烁动画
- (void)stopOpacityForeverAnimation {
    [self.layer removeAnimationForKey:NSStringFromClass(self.class)];
}
// 闪烁动画
- (CABasicAnimation *)opacityForeverAnimationWithDuration:(NSTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.6f];
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}
- (id (^)(NSInteger row, NSInteger section))cell {
    return ^id (NSInteger row, NSInteger section) {
        return [self.allReuseCells objectForKey:NSIndexPath.stringValue(row, section)];
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

@implementation HTableView (HSignal)
- (HTableCellSignalBlock)signalBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSignalBlock:(HTableCellSignalBlock)signalBlock {
    objc_setAssociatedObject(self, @selector(signalBlock), signalBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)signalToTable:(HTableSignal *)signal {
    if (self.signalBlock) {
        dispatch_async(dispatch_queue_create(0, 0), ^{
            self.signalBlock(self, signal);
        });
    }
}
- (void)signalToAllCells:(HTableSignal *)signal {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (HTableBaseCell *cell in self.allReuseCells) {
            if (cell.signalBlock) {
                cell.signalBlock(cell, signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal cellSection:(NSInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger cells = [self numberOfRowsInSection:section];
        for (int i=0; i<cells; i++) {
            HTableBaseCell *cell = [self.allReuseCells objectForKey:NSIndexPath.stringValue(i, section)];
            if (cell.signalBlock) {
                cell.signalBlock(cell, signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal toRow:(NSInteger)row inSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    HTableBaseCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
    if (cell.signalBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.signalBlock(cell, signal);
        });
    }
}
- (void)signalToAllHeader:(HTableSignal *)signal {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            HTableBaseApex *header = [self.allReuseHeaders objectForKey:@(i).stringValue];
            if (header.signalBlock) {
                header.signalBlock(header, signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal headerSection:(NSInteger)section {
    HTableBaseApex *header = [self.allReuseHeaders objectForKey:@(section).stringValue];
    if (header.signalBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            header.signalBlock(header, signal);
        });
    }
}
- (void)signalToAllFooter:(HTableSignal *)signal {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            HTableBaseApex *footer = [self.allReuseFooters objectForKey:@(i).stringValue];
            if (footer.signalBlock) {
                footer.signalBlock(footer, signal);
            }
        }
    });
}
- (void)signal:(HTableSignal *)signal footerSection:(NSInteger)section {
    HTableBaseApex *footer = [self.allReuseFooters objectForKey:@(section).stringValue];
    if (footer.signalBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            footer.signalBlock(footer, signal);
        });
    }
}
- (void)releaseAllSignal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        if (self.signalBlock) self.signalBlock = nil;
        //release all cell
        for (HTableBaseCell *cell in self.allReuseCells) {
            if (cell.didSelectCell) {
                cell.didSelectCell = nil;
            }
            if (cell.signalBlock) {
                cell.signalBlock = nil;
            }
        }
        //release all header
        for (HTableBaseApex *header in self.allReuseHeaders) {
            if (header.signalBlock) {
                header.signalBlock = nil;
            }
        }
        //release all footer
        for (HTableBaseApex *footer in self.allReuseFooters) {
            if (footer.signalBlock) {
                footer.signalBlock = nil;
            }
        }
    });
}
@end

#define KTableStateKey   @"_table_"

@interface HTableView (HStateSource)
@property (nonatomic) NSMutableDictionary *tableStateSource;
@end

@implementation HTableView (HSplitState)
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
