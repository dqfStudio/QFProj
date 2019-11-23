//
//  HTupleView.m
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleView.h"
#import <objc/runtime.h>

typedef NS_OPTIONS(NSUInteger, HTupleStyle) {
    HTupleStyleDefault = 0, //单体式设计
    HTupleStyleSplit //分体式设计
};

#define KDefaultPageSize    20
#define KTupleDesignKey     @"tuple"
#define KTupleExaDesignKey  @"tupleExa"

@interface HTupleAppearance ()
@property (nonatomic) NSHashTable *hashTuples;
@end

@implementation HTupleAppearance
+ (instancetype)appearance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)addTuple:(id)anTuple {
    if (!self.hashTuples) {
        self.hashTuples = [NSHashTable weakObjectsHashTable];
    }
    [self.hashTuples addObject:anTuple];
}
- (void)enumerateTuples:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *allObjects = [[self.hashTuples objectEnumerator] allObjects];
        //倒序执行
        for (NSUInteger i=allObjects.count-1; i>=0; i--) {
            HTupleView *tuple = allObjects[i];
            [tuple reloadData];
        }
        if (completion) {
            completion();
        }
    });
}
@end

@interface HTupleView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) HTupleStyle tupleStyle;

@property (nonatomic) NSMutableSet *allReuseIdentifiers;
@property (nonatomic) NSMapTable   *allSectionInsets;
@property (nonatomic) NSMapTable   *allReuseCells;
@property (nonatomic) NSMapTable   *allReuseHeaders;
@property (nonatomic) NSMapTable   *allReuseFooters;

@property (nonatomic, copy) NSArray <NSNumber *> *sectionPaths;

@end

@implementation HTupleView
- (instancetype)initWithFrame:(CGRect)frame {
    _flowLayout = HCollectionViewFlowLayout.new;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return [self initWithFrame:UIRectIntegral(frame) collectionViewLayout:_flowLayout];
}
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(HTupleDirection)direction {
    _flowLayout = HCollectionViewFlowLayout.new;
    if (direction == HTupleDirectionHorizontal) {
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else {
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return [self initWithFrame:UIRectIntegral(frame) collectionViewLayout:_flowLayout];
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    _flowLayout = (UICollectionViewFlowLayout *)layout;
    self = [super initWithFrame:UIRectIntegral(frame) collectionViewLayout:_flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}
+ (instancetype)tupleFrame:(CGRect (^)(void))frame exclusiveSections:(HTupleSectionExclusiveBlock)sections {
    return [[HTupleView alloc] initWithFrame:frame() exclusiveSections:sections()];
}
- (instancetype)initWithFrame:(CGRect)frame exclusiveSections:(NSArray <NSNumber *> *)sectionPaths {
    _flowLayout = HCollectionViewFlowLayout.new;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:UIRectIntegral(frame) collectionViewLayout:_flowLayout];
    if (self) {
        self.tupleStyle = HTupleStyleSplit;
        self.sectionPaths = sectionPaths;
        [self setup];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    frame = UIRectIntegral(frame);
    if(!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        [self reloadData];
    }
}
- (void)setup {
    //保存tupleView用于全局刷新
    [[HTupleAppearance appearance] addTuple:self];
    
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        [self verticalBounceEnabled];
    }else {
        [self horizontalBounceEnabled];
    }
    self.backgroundColor = UIColor.clearColor;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _allReuseIdentifiers = [NSMutableSet new];
    _allSectionInsets = [NSMapTable strongToStrongObjectsMapTable];
    _allReuseCells    = [NSMapTable strongToWeakObjectsMapTable];
    _allReuseHeaders  = [NSMapTable strongToWeakObjectsMapTable];
    _allReuseFooters  = [NSMapTable strongToWeakObjectsMapTable];
    self.delegate = self;
    self.dataSource = self;
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
- (void)setRefreshBlock:(HTupleRefreshBlock)refreshBlock {
    _refreshBlock = refreshBlock;
    if (_refreshBlock) {
        @www
        self.mj_header = [HTupleRefresh refreshHeaderWithStyle:_refreshHeaderStyle andBlock:^{
            @sss
            [self setPageNo:1];
            self->_refreshBlock();
        }];
    }else {
        self.mj_header = nil;
    }
}
- (void)setLoadMoreBlock:(HTupleLoadMoreBlock)loadMoreBlock {
    _loadMoreBlock = loadMoreBlock;
    if (_loadMoreBlock) {
        [self setPageNo:1];
        @www
        self.mj_footer = [HTupleRefresh refreshFooterWithStyle:_refreshFooterStyle andBlock:^{
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
- (void)setReleaseTupleKey:(NSString *)releaseTupleKey {
    if (_releaseTupleKey != releaseTupleKey) {
        if (_releaseTupleKey && releaseTupleKey) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:_releaseTupleKey object:nil];
        }
        _releaseTupleKey = releaseTupleKey;
        if (releaseTupleKey) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseTupleBlock) name:releaseTupleKey object:nil];
        }
    }
}
- (void)setReloadTupleKey:(NSString *)reloadTupleKey {
    if (_reloadTupleKey != reloadTupleKey) {
        if (_reloadTupleKey && reloadTupleKey) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:_reloadTupleKey object:nil];
        }
        _reloadTupleKey = reloadTupleKey;
        if (reloadTupleKey) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTupleData) name:reloadTupleKey object:nil];
        }
    }
}
- (void)reloadTupleData {
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
- (id)dequeueReusableHeaderWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath {
    UICollectionReusableView *cell = nil;
    NSString *identifier = NSStringFromClass(cls);
    identifier = [identifier stringByAppendingString:self.addressValue];
    identifier = [identifier stringByAppendingString:@"HeaderCell"];
    if (self.tupleStyle == HTupleStyleSplit && ![self.sectionPaths containsObject:@(idxPath.section)]) {
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
    }
    if (pre) identifier = [identifier stringByAppendingString:pre];
    if (idx) identifier = [identifier stringByAppendingString:idxPath.getStringValue];
    if (![self.allReuseIdentifiers containsObject:identifier]) {
        [self.allReuseIdentifiers addObject:identifier];
        [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
        cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:idxPath];
        HTupleBaseApex *tmpCell = (HTupleBaseApex *)cell;
        tmpCell.tuple = self;
        tmpCell.indexPath = idxPath;
        tmpCell.isHeader = YES;
        //init method
        if (iblk) {
            HTupleCellInitBlock initHeaderBlock = iblk;
            if (initHeaderBlock) {
                initHeaderBlock(cell);
            }
        }
    }else {
        cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:idxPath];
    }
    //保存cell
    [self.allReuseHeaders setObject:cell forKey:idxPath.getStringValue];
    //调用代理方法
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    NSString *prefix = [self prefixWithSection:idxPath.section];
    SEL selector = @selector(tupleView:edgeInsetsForHeaderInSection:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        HTupleView *copyTupleView = self;
        NSUInteger section = idxPath.section;
        edgeInsets = [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&copyTupleView, &section] UIEdgeInsetsValue];
    }
    //设置属性
    if ([cell respondsToSelector:@selector(edgeInsets)]) {
        [(HTupleBaseApex *)cell setEdgeInsets:edgeInsets];
    }
    return cell;
}
- (id)dequeueReusableFooterWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath {
    UICollectionReusableView *cell = nil;
    NSString *identifier = NSStringFromClass(cls);
    identifier = [identifier stringByAppendingString:self.addressValue];
    identifier = [identifier stringByAppendingString:@"FooterCell"];
    if (self.tupleStyle == HTupleStyleSplit && ![self.sectionPaths containsObject:@(idxPath.section)]) {
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
    }
    if (pre) identifier = [identifier stringByAppendingString:pre];
    if (idx) identifier = [identifier stringByAppendingString:idxPath.getStringValue];
    if (![self.allReuseIdentifiers containsObject:identifier]) {
        [self.allReuseIdentifiers addObject:identifier];
        [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
        cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:idxPath];
        HTupleBaseApex *tmpCell = (HTupleBaseApex *)cell;
        tmpCell.tuple = self;
        tmpCell.indexPath = idxPath;
        tmpCell.isHeader = NO;
        //init method
        if (iblk) {
            HTupleCellInitBlock initFooterBlock = iblk;
            if (initFooterBlock) {
                initFooterBlock(cell);
            }
        }
    }else {
        cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:idxPath];
    }
    //保存cell
    [self.allReuseFooters setObject:cell forKey:idxPath.getStringValue];
    //调用代理方法
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    NSString *prefix = [self prefixWithSection:idxPath.section];
    SEL selector = @selector(tupleView:edgeInsetsForFooterInSection:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        HTupleView *copyTupleView = self;
        NSUInteger section = idxPath.section;
        edgeInsets = [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&copyTupleView, &section] UIEdgeInsetsValue];
    }
    //设置属性
    if ([cell respondsToSelector:@selector(edgeInsets)]) {
        [(HTupleBaseApex *)cell setEdgeInsets:edgeInsets];
    }
    return cell;
}
- (id)dequeueReusableCellWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath {
    UICollectionViewCell *cell = nil;
    NSString *identifier = NSStringFromClass(cls);
    identifier = [identifier stringByAppendingString:self.addressValue];
    identifier = [identifier stringByAppendingString:@"ItemCell"];
    if (self.tupleStyle == HTupleStyleSplit && ![self.sectionPaths containsObject:@(idxPath.section)]) {
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
    }
    if (pre) identifier = [identifier stringByAppendingString:pre];
    if (idx) identifier = [identifier stringByAppendingString:idxPath.getStringValue];
    if (![self.allReuseIdentifiers containsObject:identifier]) {
        [self.allReuseIdentifiers addObject:identifier];
        [self registerClass:cls forCellWithReuseIdentifier:identifier];
        cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:idxPath];
        HTupleBaseCell *tmpCell = (HTupleBaseCell *)cell;
        tmpCell.tuple = self;
        tmpCell.indexPath = idxPath;
        //init method
        if (iblk) {
            HTupleCellInitBlock initCellBlock = iblk;
            if (initCellBlock) {
                initCellBlock(cell);
            }
        }
    }else {
        cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:idxPath];
    }
    //保存cell
    [self.allReuseCells setObject:cell forKey:idxPath.getStringValue];
    //调用代理方法
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    NSString *prefix = [self prefixWithSection:idxPath.section];
    SEL selector = @selector(tupleView:edgeInsetsForItemAtIndexPath:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        HTupleView *copyTupleView = self;
        edgeInsets = [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&copyTupleView, &idxPath] UIEdgeInsetsValue];
    }
    //设置属性
    if ([cell respondsToSelector:@selector(edgeInsets)]) {
        [(HTupleBaseCell *)cell setEdgeInsets:edgeInsets];
    }
    return cell;
}
#pragma mark - UICollectionViewDatasource  & delegate
- (NSString *)prefixWithSection:(NSInteger)section {
    NSString *prefix = @"";
    if (self.tupleStyle == HTupleStyleSplit) {
        if ([self.sectionPaths containsObject:@(section)]) {
            NSInteger idx = [self.sectionPaths indexOfObject:@(section)];
            prefix = [KTupleExaDesignKey stringByAppendingFormat:@"%@_", @(idx)];
        }else {
            prefix = [KTupleDesignKey stringByAppendingFormat:@"%@_", @(self.tupleState)];
        }
    }
    return prefix;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.allSectionInsets.count > 0) {
        [self.allSectionInsets removeAllObjects];
    }
    switch (self.tupleStyle) {
        case HTupleStyleDefault: {
            NSString *prefix = @"";
            SEL selector = @selector(numberOfSectionsInTupleView:);
            if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
                return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView] integerValue];
            }
        }
            break;
        case HTupleStyleSplit: {
            NSString *prefix = [KTupleDesignKey stringByAppendingFormat:@"%@_", @(self.tupleState)];
            SEL selector = @selector(numberOfSectionsInTupleView:);
            if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
                return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView] integerValue];
            }
        }
            break;
        default:
            break;
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger items = 0;
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tupleView:numberOfItemsInSection:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        items = [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &section] integerValue];
    }

    UIEdgeInsets edgeInsets = [self collectionView:self layout:self.flowLayout insetForSectionAtIndex:section];
    [self.allSectionInsets setObject:NSStringFromUIEdgeInsets(edgeInsets) forKey:@(section).stringValue];
    return items;
}
//layout == HCollectionViewFlowLayout
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout colorForSectionAtIndex:(NSInteger)section {
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tupleView:colorForSectionAtIndex:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        UIColor *color = [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &section];
        if (color && [color isKindOfClass:UIColor.class]) return color;
    }
    return UIColor.clearColor;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tupleView:insetForSectionAtIndex:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &section] UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tupleView:sizeForHeaderInSection:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        size = [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &section] CGSizeValue];
    }
    return UISizeIntegral(size);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    NSString *prefix = [self prefixWithSection:section];
    SEL selector = @selector(tupleView:sizeForFooterInSection:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        size = [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &section] CGSizeValue];
    }
    return UISizeIntegral(size);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    NSString *prefix = [self prefixWithSection:indexPath.section];
    SEL selector = @selector(tupleView:sizeForItemAtIndexPath:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        size = [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &indexPath] CGSizeValue];
    }
    //不能为CGSizeZero，否则会崩溃
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        size = CGSizeMake(1.f, 1.f);
    }
    return UISizeIntegral(size);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //调用代理方法
    NSString *prefix = [self prefixWithSection:indexPath.section];
    SEL selector = @selector(tupleView:tupleItem:atIndexPath:);
    HTupleItem itemBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
        return [self dequeueReusableCellWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
    };
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &itemBlock, &indexPath];
    }
    //调用cell
    HTupleBaseCell *cell = [self.allReuseCells objectForKey:indexPath.getStringValue];
    //更新布局
    if ([cell respondsToSelector:@selector(relayoutSubviews)]) {
        [cell relayoutSubviews];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HTupleBaseApex *cell = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        //调用代理方法
        NSString *prefix = [self prefixWithSection:indexPath.section];
        SEL selector = @selector(tupleView:tupleHeader:inSection:);
        HTupleHeader headerBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return [self dequeueReusableHeaderWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
        };
        NSUInteger section = indexPath.section;
        if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
            [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &headerBlock, &section];
        }
        //调用cell
        cell = [self.allReuseHeaders objectForKey:indexPath.getStringValue];
    }else if (kind == UICollectionElementKindSectionFooter) {
        //调用代理方法
        NSString *prefix = [self prefixWithSection:indexPath.section];
        SEL selector = @selector(tupleView:tupleFooter:inSection:);
        HTupleFooter footerBlock = ^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return [self dequeueReusableFooterWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
        };
        NSUInteger section = indexPath.section;
        if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
            [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &footerBlock, &section];
        }
        //调用cell
        cell = [self.allReuseFooters objectForKey:indexPath.getStringValue];
    }
    //更新布局
    if ([cell respondsToSelector:@selector(relayoutSubviews)]) {
        [cell relayoutSubviews];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self prefixWithSection:indexPath.section];
    SEL selector = @selector(tupleView:willDisplayCell:forItemAtIndexPath:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &cell, &indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self prefixWithSection:indexPath.section];
    SEL selector = @selector(tupleView:didSelectItemAtIndexPath:);
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&collectionView, &indexPath];
    }
}
#pragma mark - release method
- (void)releaseTupleBlock {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        
        [self releaseAllSignal];
        [self clearTupleState];
        
        if (self.tupleDelegate) self.tupleDelegate = nil;
        if (self.refreshBlock) self.refreshBlock = nil;
        if (self.loadMoreBlock) self.loadMoreBlock = nil;
        
    });
}
@end

@implementation HTupleView (HSignal)
- (HTupleCellSignalBlock)signalBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSignalBlock:(HTupleCellSignalBlock)signalBlock {
    objc_setAssociatedObject(self, @selector(signalBlock), signalBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)signalToTupleView:(HTupleSignal *)signal {
    if (self.signalBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.signalBlock(self, signal);
        });
    }
}
- (void)signalToAllItems:(HTupleSignal *)signal {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (HTupleBaseCell *cell in self.allReuseCells) {
            if (cell.signalBlock) {
                cell.signalBlock(cell, signal);
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal itemSection:(NSInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger items = [self numberOfItemsInSection:section];
        for (int i=0; i<items; i++) {
            HTupleBaseCell *cell = [self.allReuseCells objectForKey:NSIndexPath.getStringValue(i, section)];
            if (cell.signalBlock) {
                cell.signalBlock(cell, signal);
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal indexPath:(NSIndexPath *)indexPath  {
    HTupleBaseCell *cell = [self.allReuseCells objectForKey:indexPath.getStringValue];
    if (cell.signalBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.signalBlock(cell, signal);
        });
    }
}
- (void)signalToAllHeader:(HTupleSignal *)signal {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            HTupleBaseApex *header = [self.allReuseHeaders objectForKey:NSIndexPath.getStringValue(0, i)];
            if (header.signalBlock) {
                header.signalBlock(header, signal);
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal headerSection:(NSInteger)section {
    HTupleBaseApex *header = [self.allReuseHeaders objectForKey:NSIndexPath.getStringValue(0, section)];
    if (header.signalBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            header.signalBlock(header, signal);
        });
    }
}
- (void)signalToAllFooter:(HTupleSignal *)signal {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            HTupleBaseApex *footer = [self.allReuseFooters objectForKey:NSIndexPath.getStringValue(0, i)];
            if (footer.signalBlock) {
                footer.signalBlock(footer, signal);
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal footerSection:(NSInteger)section {
    HTupleBaseApex *footer = [self.allReuseFooters objectForKey:NSIndexPath.getStringValue(0, section)];
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
        for (HTupleBaseCell *cell in self.allReuseCells) {
            if (cell.signalBlock) {
                cell.signalBlock = nil;
            }
        }
        //release all header
        for (HTupleBaseApex *header in self.allReuseHeaders) {
            if (header.signalBlock) {
                header.signalBlock = nil;
            }
        }
        //release all footer
        for (HTupleBaseApex *footer in self.allReuseFooters) {
            if (footer.signalBlock) {
                footer.signalBlock = nil;
            }
        }
    });
}
- (id (^)(NSInteger row, NSInteger section))cell {
    return ^id (NSInteger row, NSInteger section) {
        return [self.allReuseCells objectForKey:NSIndexPath.getStringValue(row, section)];
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
- (CGFloat (^)(NSInteger section))widthWithSection {
    return ^CGFloat (NSInteger section) {
        CGFloat width = CGRectGetWidth(self.frame);
        NSString *edgeInsetsString = [self.allSectionInsets objectForKey:@(section).stringValue];
        if (edgeInsetsString.length > 0) {
            UIEdgeInsets edgeInsets = UIEdgeInsetsFromString(edgeInsetsString);
            width -= edgeInsets.left + edgeInsets.right;
        }
        return width;
    };
}
- (CGFloat (^)(NSInteger section))heightWithSection {
    return ^CGFloat (NSInteger section) {
        CGFloat height = CGRectGetHeight(self.frame);
        NSString *edgeInsetsString = [self.allSectionInsets objectForKey:@(section).stringValue];
        if (edgeInsetsString.length > 0) {
            UIEdgeInsets edgeInsets = UIEdgeInsetsFromString(edgeInsetsString);
            height -= edgeInsets.top + edgeInsets.bottom;
        }
        return height;
    };
}
- (CGSize (^)(NSInteger section))sizeWithSection {
    return ^CGSize (NSInteger section) {
        CGSize size = self.frame.size;
        NSString *edgeInsetsString = [self.allSectionInsets objectForKey:@(section).stringValue];
        if (edgeInsetsString.length > 0) {
            UIEdgeInsets edgeInsets = UIEdgeInsetsFromString(edgeInsetsString);
            size.width -= edgeInsets.left + edgeInsets.right;
            size.height -= edgeInsets.top + edgeInsets.bottom;
        }
        return size;
    };
}
- (CGFloat)fixSlitWith:(CGFloat)width colCount:(CGFloat)colCount index:(NSInteger)idx {
    CGFloat itemWidth = width/colCount;
    CGFloat realItemWidth = floor(itemWidth);
    CGFloat idxCount = colCount-1;
    if (idx == idxCount) {
        realItemWidth = width-realItemWidth*idxCount;
    }
    return realItemWidth;
}
@end

#define KTupleStateKey   @"_tuple_"

@interface HTupleView (HStateSource)
@property (nonatomic) NSMutableDictionary *tupleStateSource;
@end

@implementation HTupleView (HSplitState)
- (NSMutableDictionary *)tupleStateSource {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = NSMutableDictionary.new;
        [self setTupleStateSource:dict];
    }
    return dict;
}
- (void)setTupleStateSource:(NSMutableDictionary *)tupleStateSource {
    objc_setAssociatedObject(self, @selector(tupleStateSource), tupleStateSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HTupleState)tupleState {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setTupleState:(HTupleState)tupleState {
    if (self.tupleState != tupleState) {
        objc_setAssociatedObject(self, @selector(tupleState), @(tupleState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self reloadData];
    }
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey {
    [self setObject:anObject forKey:aKey state:self.tupleState];
}
- (void)setObject:(id)anObject forKey:(NSString *)aKey state:(HTupleState)tupleState {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", aKey, KTupleStateKey, @(tupleState)];
    [self.tupleStateSource setObject:anObject forKey:key];
}

- (nullable id)objectForKey:(NSString *)aKey {
    return [self objectForKey:aKey state:self.tupleState];
}
- (nullable id)objectForKey:(NSString *)aKey state:(HTupleState)tupleState {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", aKey, KTupleStateKey, @(tupleState)];
    return [self.tupleStateSource objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)aKey {
    [self removeObjectForKey:aKey state:self.tupleState];
}
- (void)removeObjectForKey:(NSString *)aKey state:(HTupleState)tupleState {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", aKey, KTupleStateKey, @(tupleState)];
    if ([self.tupleStateSource.allKeys containsObject:key]) {
        [self.tupleStateSource removeObjectForKey:key];
    }
}

- (void)removeStateObject {
    [self removeObjectForState:self.tupleState];
}
- (void)removeObjectForState:(HTupleState)tupleState {
    NSString *key = [NSString stringWithFormat:@"%@%@", KTupleStateKey, @(tupleState)];
    for (NSUInteger i=self.tupleStateSource.allKeys.count-1; i>=0; i--) {
        NSString *akey = self.tupleStateSource.allKeys[i];
        if ([akey containsString:key]) {
            [self.tupleStateSource removeObjectForKey:akey];
        }
    }
}

- (void)clearTupleState {
    if (self.tupleStateSource.count > 0) {
        [self.tupleStateSource removeAllObjects];
    }
}
@end
