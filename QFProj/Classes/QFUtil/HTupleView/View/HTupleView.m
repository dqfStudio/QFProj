//
//  HTupleView.m
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleView.h"
#import <objc/runtime.h>

typedef NS_OPTIONS(NSUInteger, HTupleDesignStyle) {
    HTupleDesignStyleSection = 0,
    HTupleDesignStyleTuple
};

#define KDefaultPageSize  20
#define KSectionDesignKey @"section"
#define KTupleDesignKey   @"tuple"

@interface HTupleView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) BOOL categoryDesign;
@property (nonatomic) NSInteger designSections;
@property (nonatomic) HTupleDesignStyle designStyle;

@property (nonatomic) NSMutableSet *allReuseIdentifiers;
@property (nonatomic) NSMapTable   *allReuseCells;
@property (nonatomic) NSMapTable   *allReuseHeaders;
@property (nonatomic) NSMapTable   *allReuseFooters;

@property (nonatomic, copy) NSArray <NSString *> *headerIndexPaths;
@property (nonatomic, copy) NSArray <NSString *> *footerIndexPaths;
@property (nonatomic, copy) NSArray <NSString *> *itemIndexPaths;

@property (nonatomic, copy) HUNumberOfSectionsBlock numberOfSectionsBlock;
@property (nonatomic, copy) HNumberOfItemsBlock numberOfItemsBlock;
@property (nonatomic, copy) HColorForSectionBlock colorForSectionBlock;

@property (nonatomic, copy) HSizeForHeaderBlock sizeForHeaderBlock;
@property (nonatomic, copy) HSizeForFooterBlock sizeForFooterBlock;
@property (nonatomic, copy) HSizeForItemBlock sizeForItemBlock;

@property (nonatomic, copy) HEdgeInsetsForHeaderBlock edgeInsetsForHeaderBlock;
@property (nonatomic, copy) HEdgeInsetsForFooterBlock edgeInsetsForFooterBlock;
@property (nonatomic, copy) HEdgeInsetsForItemBlock edgeInsetsForItemBlock;

@property (nonatomic, copy) HInsetForSectionBlock insetForSectionBlock;

@property (nonatomic, copy) HTupleHeaderBlock headerTupleBlock;
@property (nonatomic, copy) HTupleFooterBlock footerTupleBlock;
@property (nonatomic, copy) HTupleItemBlock itemTupleBlock;

@property (nonatomic, copy) HItemWillDisplayBlock itemWillDisplayBlock;
@property (nonatomic, copy) HDidSelectItemBlock didSelectItemBlock;
@end

@implementation HTupleView
- (instancetype)initWithFrame:(CGRect)frame {
    _flowLayout = UICollectionViewLeftAlignedLayout.new;
    self = [super initWithFrame:frame collectionViewLayout:_flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(HTupleViewStyle)style {
    if (style == HTupleViewStyleLeftAlignedLayout) {
        _flowLayout = UICollectionViewLeftAlignedLayout.new;
    }else {
        _flowLayout = ULBCollectionViewFlowLayout.new;
    }
    self = [super initWithFrame:frame collectionViewLayout:_flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(HTupleViewScrollDirection)direction {
    if (direction == HTupleViewScrollDirectionHorizontal) {
        _flowLayout = UICollectionViewFlowLayout.new;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else {
        _flowLayout = UICollectionViewLeftAlignedLayout.new;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    self = [super initWithFrame:frame collectionViewLayout:_flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    _flowLayout = (UICollectionViewFlowLayout *)layout;
    self = [super initWithFrame:frame collectionViewLayout:_flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}
+ (instancetype)sectionDesignWith:(CGRect)frame andSections:(NSInteger)sections {
    return [[HTupleView alloc] initWithFrame:frame designStyle:HTupleDesignStyleSection designSection:sections headers:nil footers:nil items:nil];
}
+ (instancetype)tupleDesignWith:(CGRect (^)(void))frame exclusiveHeaders:(HTupleExclusiveForHeaderBlock)headers exclusiveFooters:(HTupleExclusiveForFooterBlock)footers exclusiveItems:(HTupleExclusiveForItemBlock)items {
    return [[HTupleView alloc] initWithFrame:frame() designStyle:HTupleDesignStyleTuple designSection:0 headers:headers() footers:footers() items:items()];
}
- (instancetype)initWithFrame:(CGRect)frame designStyle:(HTupleDesignStyle)style designSection:(NSInteger)sections headers:(NSArray <NSString *> *)headerIndexPaths footers:(NSArray <NSString *> *)footerIndexPaths items:(NSArray <NSString *> *)itemIndexPaths {
    _flowLayout = UICollectionViewLeftAlignedLayout.new;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:frame collectionViewLayout:_flowLayout];
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
- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        [self reloadData];
    }
}
- (void)setup {
    self.bounces = NO;
    self.backgroundColor = UIColor.clearColor;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _allReuseIdentifiers = [NSMutableSet new];
    _allReuseCells   = [NSMapTable strongToWeakObjectsMapTable];
    _allReuseHeaders = [NSMapTable strongToWeakObjectsMapTable];
    _allReuseFooters = [NSMapTable strongToWeakObjectsMapTable];
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
- (NSString *)addressValue {
    return [NSString stringWithFormat:@"%p", self];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - register class
- (id)dequeueReusableHeaderWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath {
    __block UICollectionReusableView *cell = nil;
    id (^HCellForHeaderBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:self.addressValue];
        identifier = [identifier stringByAppendingString:@"HeaderCell"];
        if (![self.headerIndexPaths containsObject:idxPath.stringValue]) {
            identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
        }
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:idxPath.stringValue];
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
        [self.allReuseHeaders setObject:cell forKey:idxPath.stringValue];
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        if (!self.categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForHeaderInSection:)]) {
            edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForHeaderInSection:idxPath.section];
        }else if (self.categoryDesign && [self respondsToSelector:@selector(tupleView:edgeInsetsForHeaderInSection:)]) {
            edgeInsets = [self tupleView:self edgeInsetsForHeaderInSection:idxPath.section];
        }else if (self.edgeInsetsForHeaderBlock) {
            edgeInsets = self.edgeInsetsForHeaderBlock(idxPath.section);
        }
        if ([cell respondsToSelector:@selector(edgeInsets)]) {
            [(HTupleBaseApex *)cell setEdgeInsets:edgeInsets];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HTupleBaseApex *)cell layoutContentView];
        }
        return cell;
    };
    return HCellForHeaderBlock(iblk, cls, pre, idx);
}
- (id)dequeueReusableFooterWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath {
    __block UICollectionReusableView *cell = nil;
    id (^HCellForFooterBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:self.addressValue];
        identifier = [identifier stringByAppendingString:@"FooterCell"];
        if (![self.footerIndexPaths containsObject:idxPath.stringValue]) {
            identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
        }
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:idxPath.stringValue];
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
        [self.allReuseFooters setObject:cell forKey:idxPath.stringValue];
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        if (!self.categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForFooterInSection:)]) {
            edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForFooterInSection:idxPath.section];
        }else if (self.categoryDesign && [self respondsToSelector:@selector(tupleView:edgeInsetsForFooterInSection:)]) {
            edgeInsets = [self tupleView:self edgeInsetsForFooterInSection:idxPath.section];
        }else if (self.edgeInsetsForFooterBlock) {
            edgeInsets = self.edgeInsetsForFooterBlock(idxPath.section);
        }
        if ([cell respondsToSelector:@selector(edgeInsets)]) {
            [(HTupleBaseApex *)cell setEdgeInsets:edgeInsets];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HTupleBaseApex *)cell layoutContentView];
        }
        return cell;
    };
    return HCellForFooterBlock(iblk, cls, pre, idx);
}
- (id)dequeueReusableCellWithClass:(Class)cls iblk:(id _Nullable)iblk pre:(id _Nullable)pre idx:(bool)idx idxPath:(NSIndexPath *)idxPath {
    __block UICollectionViewCell *cell = nil;
    id (^HCellForItemBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:self.addressValue];
        identifier = [identifier stringByAppendingString:@"ItemCell"];
        if (![self.itemIndexPaths containsObject:idxPath.stringValue]) {
            identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
        }
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:idxPath.stringValue];
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
        [self.allReuseCells setObject:cell forKey:idxPath.stringValue];
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        if (!self.categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForItemAtIndexPath:)]) {
            edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForItemAtIndexPath:idxPath];
        }else if (self.categoryDesign && [self respondsToSelector:@selector(tupleView:edgeInsetsForItemAtIndexPath:)]) {
            edgeInsets = [self tupleView:self edgeInsetsForItemAtIndexPath:idxPath];
        }else if (self.edgeInsetsForItemBlock) {
            edgeInsets = self.edgeInsetsForItemBlock(idxPath);
        }
        if ([cell respondsToSelector:@selector(edgeInsets)]) {
            [(HTupleBaseCell *)cell setEdgeInsets:edgeInsets];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HTupleBaseCell *)cell layoutContentView];
        }
        return cell;
    };
    return HCellForItemBlock(iblk, cls, pre, idx);
}
#pragma mark - UICollectionViewDatasource  & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(numberOfSectionsInTupleView:)]) {
        return [self.tupleDelegate numberOfSectionsInTupleView:self];
    }else if (_categoryDesign && [self respondsToSelector:@selector(numberOfSectionsInTupleView:)]) {
        return [self numberOfSectionsInTupleView:self];
    }else if (self.numberOfSectionsBlock) {
        return self.numberOfSectionsBlock();
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:numberOfItemsInSection:)]) {
        return [self.tupleDelegate tupleView:self numberOfItemsInSection:section];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:numberOfItemsInSection:)]) {
        return [self tupleView:self numberOfItemsInSection:section];
    }else if (self.numberOfItemsBlock) {
        return self.numberOfItemsBlock(section);
    }
    return 0;
}
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout colorForSectionAtIndex:(NSInteger)section {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:colorForSectionAtIndex:)]) {
        UIColor *color = [self.tupleDelegate tupleView:self colorForSectionAtIndex:section];
        if (color && [color isKindOfClass:UIColor.class]) return color;
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:colorForSectionAtIndex:)]) {
        UIColor *color = [self tupleView:self colorForSectionAtIndex:section];
        if (color && [color isKindOfClass:UIColor.class]) return color;
    }else if (self.colorForSectionBlock) {
        UIColor *color = self.colorForSectionBlock(section);
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
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:insetForSectionAtIndex:)]) {
        return [self.tupleDelegate tupleView:self insetForSectionAtIndex:section];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:insetForSectionAtIndex:)]) {
        return [self tupleView:self insetForSectionAtIndex:section];
    }else if (self.insetForSectionBlock) {
        return self.insetForSectionBlock(section);
    }
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:sizeForHeaderInSection:)]) {
        return [self.tupleDelegate tupleView:self sizeForHeaderInSection:section];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:sizeForHeaderInSection:)]) {
        return [self tupleView:self sizeForHeaderInSection:section];
    }else if (self.sizeForHeaderBlock) {
        return self.sizeForHeaderBlock(section);
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:sizeForFooterInSection:)]) {
        return [self.tupleDelegate tupleView:self sizeForFooterInSection:section];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:sizeForFooterInSection:)]) {
        return [self tupleView:self sizeForFooterInSection:section];
    }else if (self.sizeForFooterBlock) {
        return self.sizeForFooterBlock(section);
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:sizeForItemAtIndexPath:)]) {
        return [self.tupleDelegate tupleView:self sizeForItemAtIndexPath:indexPath];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:sizeForItemAtIndexPath:)]) {
        return [self tupleView:self sizeForItemAtIndexPath:indexPath];
    }else if (self.sizeForItemBlock) {
        return self.sizeForItemBlock(indexPath);
    }
    return CGSizeZero;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:tupleItem:atIndexPath:)]) {
        [self.tupleDelegate tupleView:self tupleItem:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return [self dequeueReusableCellWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
        } atIndexPath:indexPath];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:tupleItem:atIndexPath:)]) {
        [self tupleView:self tupleItem:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return [self dequeueReusableCellWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
        } atIndexPath:indexPath];
    }else if (self.itemTupleBlock) {
        self.itemTupleBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return [self dequeueReusableCellWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
        }, indexPath);
    }
    return UICollectionViewCell.new;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:tupleHeader:inSection:)]) {
            [self.tupleDelegate tupleView:self tupleHeader:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return [self dequeueReusableHeaderWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
            } inSection:indexPath.section];
        }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:tupleHeader:inSection:)]) {
            [self tupleView:self tupleHeader:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return [self dequeueReusableHeaderWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
            } inSection:indexPath.section];
        }else if (self.headerTupleBlock) {
            self.headerTupleBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return [self dequeueReusableHeaderWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
            }, indexPath.section);
        }
    }else if (kind == UICollectionElementKindSectionFooter) {
        if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:tupleFooter:inSection:)]) {
            [self.tupleDelegate tupleView:self tupleFooter:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return [self dequeueReusableFooterWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
            } inSection:indexPath.section];
        }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:tupleFooter:inSection:)]) {
            [self tupleView:self tupleFooter:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return [self dequeueReusableFooterWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
            } inSection:indexPath.section];
        }else if (self.footerTupleBlock) {
            self.footerTupleBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return [self dequeueReusableFooterWithClass:cls iblk:iblk pre:nil idx:idx idxPath:indexPath];
            }, indexPath.section);
        }
    }
    return UICollectionReusableView.new;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:willDisplayCell:forItemAtIndexPath:)]) {
        [self.tupleDelegate tupleView:self willDisplayCell:cell forItemAtIndexPath:indexPath];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:willDisplayCell:forItemAtIndexPath:)]) {
        [self tupleView:self willDisplayCell:cell forItemAtIndexPath:indexPath];
    }else if (self.itemWillDisplayBlock) {
        self.itemWillDisplayBlock(cell, indexPath);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:didSelectItemAtIndexPath:)]) {
        [self.tupleDelegate tupleView:self didSelectItemAtIndexPath:indexPath];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:didSelectItemAtIndexPath:)]) {
        [self tupleView:self didSelectItemAtIndexPath:indexPath];
    }else if (self.didSelectItemBlock) {
        self.didSelectItemBlock(indexPath);
    }
}
#pragma mark - UICollectionView Block
- (void)tupleWithSections:(HUNumberOfSectionsBlock)sections items:(HNumberOfItemsBlock)items color:(HColorForSectionBlock)color inset:(HInsetForSectionBlock)inset {
    self.numberOfSectionsBlock = sections;
    self.numberOfItemsBlock = items;
    self.colorForSectionBlock = color;
    self.insetForSectionBlock = inset;
}
- (void)headerWithSize:(HSizeForHeaderBlock)size edgeInsets:(HEdgeInsetsForHeaderBlock)edge tupleHeader:(HTupleHeaderBlock)block {
    self.sizeForHeaderBlock = size;
    self.edgeInsetsForHeaderBlock = edge;
    self.headerTupleBlock = block;
}
- (void)footerWithSize:(HSizeForFooterBlock)size edgeInsets:(HEdgeInsetsForFooterBlock)edge tupleFooter:(HTupleFooterBlock)block {
    self.sizeForFooterBlock = size;
    self.edgeInsetsForFooterBlock = edge;
    self.footerTupleBlock = block;
}
- (void)itemWithSize:(HSizeForItemBlock)size edgeInsets:(HEdgeInsetsForItemBlock)edge tupleItem:(HTupleItemBlock)block {
    self.sizeForItemBlock = size;
    self.edgeInsetsForItemBlock = edge;
    self.itemTupleBlock = block;
}
- (void)itemWillDisplayBlock:(HItemWillDisplayBlock)block {
    self.itemWillDisplayBlock = block;
}
- (void)didSelectItem:(HDidSelectItemBlock)block {
    self.didSelectItemBlock = block;
}
- (void)releaseTupleBlock {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        
        [self releaseAllSignal];
        [self clearTupleState];
        
        if (self.tupleDelegate) self.tupleDelegate = nil;
        if (self.refreshBlock) self.refreshBlock = nil;
        if (self.loadMoreBlock) self.loadMoreBlock = nil;
        
        if (self.numberOfSectionsBlock) self.numberOfSectionsBlock = nil;
        if (self.numberOfItemsBlock) self.numberOfItemsBlock = nil;
        if (self.colorForSectionBlock) self.colorForSectionBlock = nil;
        if (self.insetForSectionBlock) self.insetForSectionBlock = nil;
        
        if (self.sizeForHeaderBlock) self.sizeForHeaderBlock = nil;
        if (self.edgeInsetsForHeaderBlock) self.edgeInsetsForHeaderBlock = nil;
        if (self.headerTupleBlock) self.headerTupleBlock = nil;
        
        if (self.sizeForFooterBlock) self.sizeForFooterBlock = nil;
        if (self.edgeInsetsForFooterBlock) self.edgeInsetsForFooterBlock = nil;
        if (self.footerTupleBlock) self.footerTupleBlock = nil;
        
        if (self.sizeForItemBlock) self.sizeForItemBlock = nil;
        if (self.edgeInsetsForItemBlock) self.edgeInsetsForItemBlock = nil;
        if (self.itemTupleBlock) self.itemTupleBlock = nil;
        
        if (self.itemWillDisplayBlock) self.itemWillDisplayBlock = nil;
        
        if (self.didSelectItemBlock) self.didSelectItemBlock = nil;
    });
}
#pragma mark - Category & Design
- (NSString *)tupleWithPrefix:(NSInteger)section {
    NSString *prefix = nil;
    if (self.designStyle == HTupleDesignStyleSection) {
        prefix = [KSectionDesignKey stringByAppendingFormat:@"%@", @(section)];
    }else if (self.designStyle == HTupleDesignStyleTuple) {
        prefix = [KTupleDesignKey stringByAppendingFormat:@"%@", @(self.tupleState)];
    }
    return prefix;
}
- (NSInteger)numberOfSectionsInTupleView:(UICollectionView *)tupleView {
    if (self.designStyle == HTupleDesignStyleSection) {
        return _designSections;
    }else if (self.designStyle == HTupleDesignStyleTuple) {
        NSString *prefix = [KTupleDesignKey stringByAppendingFormat:@"%@", @(self.tupleState)];
        if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
            return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView] integerValue];
        }
    }
    return 0;
}
- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &section] integerValue];
    }
    return 0;
}
//style == HTupleViewStyleSectionColorLayout
- (UIColor *)tupleView:(UICollectionView *)tupleView colorForSectionAtIndex:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &section];
    }
    return UIColor.clearColor;
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &section] CGSizeValue];
    }
    return CGSizeZero;
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &section] CGSizeValue];
    }
    return CGSizeZero;
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tupleWithPrefix:indexPath.section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &indexPath] CGSizeValue];
    }
    return CGSizeZero;
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &section] UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &section] UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tupleWithPrefix:indexPath.section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &indexPath] UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView insetForSectionAtIndex:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &section] UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}
- (void)tupleView:(UICollectionView *)tupleView tupleHeader:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &headerBlock, &section];
    }
}
- (void)tupleView:(UICollectionView *)tupleView tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &footerBlock, &section];
    }
}
- (void)tupleView:(UICollectionView *)tupleView tupleCell:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tupleWithPrefix:indexPath.section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &itemBlock, &indexPath];
    }
}
- (void)tupleView:(UICollectionView *)tupleView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tupleWithPrefix:indexPath.section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &cell, &indexPath];
    }
}
- (void)tupleView:(UICollectionView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tupleWithPrefix:indexPath.section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &indexPath];
    }
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.signalBlock) {
            self.signalBlock(self, signal);
        }
    });
}
- (void)signalToAllItems:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        for (UICollectionViewCell *cell in self.allReuseCells) {
            if (cell.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.signalBlock(cell, signal);
                });
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal itemSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger items = [self numberOfItemsInSection:section];
        for (int i=0; i<items; i++) {
            UICollectionViewCell *cell = [self.allReuseCells objectForKey:NSIndexPath.stringValue(i, section)];
            if (cell.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.signalBlock(cell, signal);
                });
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal indexPath:(NSIndexPath *)indexPath  {
    UICollectionViewCell *cell = [self.allReuseCells objectForKey:indexPath.stringValue];
    if (cell.signalBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.signalBlock(cell, signal);
        });
    }
}
- (void)signalToAllHeader:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            HTupleBaseApex *header = [self.allReuseHeaders objectForKey:NSIndexPath.stringValue(0, i)];
            if (header.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    header.signalBlock(header, signal);
                });
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal headerSection:(NSInteger)section {
    HTupleBaseApex *header = [self.allReuseHeaders objectForKey:NSIndexPath.stringValue(0, section)];
    if (header.signalBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            header.signalBlock(header, signal);
        });
    }
}
- (void)signalToAllFooter:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            HTupleBaseApex *footer = [self.allReuseFooters objectForKey:NSIndexPath.stringValue(0, i)];
            if (footer.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    footer.signalBlock(footer, signal);
                });
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal footerSection:(NSInteger)section {
    HTupleBaseApex *footer = [self.allReuseFooters objectForKey:NSIndexPath.stringValue(0, section)];
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
        for (UICollectionViewCell *cell in self.allReuseCells) {
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

#define KTupleStateKey   @"_tuple_"

@interface HTupleView (HStateSource)
@property (nonatomic) NSMutableDictionary *tupleStateSource;
@end

@implementation HTupleView (HState)
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
