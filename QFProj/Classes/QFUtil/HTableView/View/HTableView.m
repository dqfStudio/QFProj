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

@property (nonatomic, weak, nullable) id <HTableViewDelegate> tableDelegate;

@property (nonatomic) HTableStyle tableStyle;

@property (nonatomic) NSMutableSet *allReuseIdentifiers;
@property (nonatomic) NSMapTable   *allReuseCells;
@property (nonatomic) NSMapTable   *allReuseHeaders;
@property (nonatomic) NSMapTable   *allReuseFooters;

@property (nonatomic, copy) NSArray <NSNumber *> *sectionPaths;

@end

@implementation HTableView

@dynamic delegate;

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
- (void)setDelegate:(id<HTableViewDelegate>)delegate {
    self.tableDelegate = delegate;
}
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {}
- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        [self reloadData];
    }
}
- (void)setup {
    //保存tableView用于全局刷新
    [[HTableAppearance appearance] addTable:self];
    
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
    super.delegate = self;
    super.dataSource = self;
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
    //保存cell
    [self.allReuseHeaders setObject:cell forKey:@(section).stringValue];
    //调用代理方法
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tableView:edgeInsetsForHeaderInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        HTableView *copyTableView = self;
        edgeInsets = [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&copyTableView, &section] UIEdgeInsetsValue];
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
    //保存cell
    [self.allReuseFooters setObject:cell forKey:@(section).stringValue];
    //调用代理方法
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tableView:edgeInsetsForFooterInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        HTableView *copyTableView = self;
        edgeInsets = [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&copyTableView, &section] UIEdgeInsetsValue];
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
    NSString *prefix = [self prefixWithSection:idxPath.section];
    SEL selector = @selector(tableView:edgeInsetsForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        HTableView *copyTableView = self;
        edgeInsets = [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&copyTableView, &idxPath] UIEdgeInsetsValue];
    }
    //设置属性
    if ([cell respondsToSelector:@selector(edgeInsets)]) {
        [(HTableBaseCell *)cell setEdgeInsets:edgeInsets];
    }
    return cell;
}
#pragma mark - UITableViewDatasource & delegate
- (NSString *)prefixWithSection:(NSInteger)section {
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
- (NSInteger)numberOfSectionsInTableView:(HTableView *)tableView {
    switch (self.tableStyle) {
        case HTableStyleDefault: {
            NSString *prefix = @"";
            SEL selector = @selector(numberOfSectionsInTableView:);
            if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
                return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView] integerValue];
            }
        }
            break;
        case HTableStyleSplit: {
            NSString *prefix = [KTableDesignKey stringByAppendingFormat:@"%@_", @(self.tableState)];
            SEL selector = @selector(numberOfSectionsInTableView:);
            if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
                return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView] integerValue];
            }
        }
            break;
        default:
            break;
    }
    return 1;
}
- (NSInteger)tableView:(HTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tableView:numberOfRowsInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &section] integerValue];
    }
    return 0;
}
- (CGFloat)tableView:(HTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tableView:heightForHeaderInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &section] floatValue];
    }
    return 0.f;
}
- (CGFloat)tableView:(HTableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tableView:heightForFooterInSection:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &section] floatValue];
    }
    return 0.f;
}
- (CGFloat)tableView:(HTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self prefixWithSection:indexPath.section];
    SEL selector = @selector(tableView:heightForRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &indexPath] floatValue];
    }
    //不能为0.f，否则会崩溃
    return 1.f;
}
- (UIView *)tableView:(HTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //调用代理方法
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tableView:tableHeader:inSection:);
    HTableHeader headerBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
        return [self dequeueReusableHeaderWithClass:cls iblk:iblk pre:pre idx:idx section:section];
    };
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &headerBlock, &section];
    }
    //调用cell
    HTableBaseApex *cell = [self.allReuseHeaders objectForKey:@(section).stringValue];
    //更新布局
    if ([cell respondsToSelector:@selector(relayoutSubviews)]) {
        [cell relayoutSubviews];
    }
    return cell;
}
- (UIView *)tableView:(HTableView *)tableView viewForFooterInSection:(NSInteger)section {
    //调用代理方法
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tableView:tableFooter:inSection:);
    HTableFooter footerBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
        return [self dequeueReusableFooterWithClass:cls iblk:iblk pre:pre idx:idx section:section];
    };
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &footerBlock, &section];
    }
    //调用cell
    HTableBaseApex *cell = [self.allReuseFooters objectForKey:@(section).stringValue];
    //更新布局
    if ([cell respondsToSelector:@selector(relayoutSubviews)]) {
        [cell relayoutSubviews];
    }
    return cell;
}
- (UITableViewCell *)tableView:(HTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //调用代理方法
    NSString *prefix = [self prefixWithSection:indexPath.section];
    SEL selector = @selector(tableView:tableRow:atIndexPath:);
    HTableRow cellBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
        return [self dequeueReusableCellWithClass:cls iblk:iblk pre:pre idx:idx idxPath:indexPath];
    };
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &cellBlock, &indexPath];
    }
    //调用cell
    HTableBaseCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
    //更新布局
    if ([cell respondsToSelector:@selector(relayoutSubviews)]) {
        [cell relayoutSubviews];
    }
    return cell;
}
- (void)tableView:(HTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:self.separatorInset];
//        }
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:self.separatorInset];
//        }
//    }
    NSString *prefix = [self prefixWithSection:indexPath.section];
    SEL selector = @selector(tableView:willSelectRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &cell, &indexPath];
    }
}
- (void)tableView:(HTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self prefixWithSection:indexPath.section];
    SEL selector = @selector(tableView:didSelectRowAtIndexPath:);
    if ([(NSObject *)self.tableDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tableDelegate performSelector:selector withPre:prefix withMethodArgments:&tableView, &indexPath];
    }
}
#pragma mark - release method
- (void)releaseTableBlock {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        
        [self releaseAllSignal];
        [self clearTableState];
        
        if (self.tableDelegate) self.tableDelegate = nil;
        if (self.refreshBlock) self.refreshBlock = nil;
        if (self.loadMoreBlock) self.loadMoreBlock = nil;
        
    });
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
        for (HTableBaseApex *cell in self.allReuseCells) {
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
