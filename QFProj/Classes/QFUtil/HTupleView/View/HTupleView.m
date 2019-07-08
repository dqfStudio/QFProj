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

@interface NSIndexPath (HTupleView)
- (NSString *)string;
@end

@implementation NSIndexPath (HTupleView)
- (NSString *)string {
    return [NSString stringWithFormat:@"%@%@",@(self.section),@(self.row)];
}
@end

@interface HTupleView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) BOOL categoryDesign;
@property (nonatomic) NSInteger designSections;
@property (nonatomic) HTupleDesignStyle designStyle;

@property (nonatomic) NSMutableSet *allReuseIdentifiers;
@property (nonatomic) NSMapTable   *allReuseCells;
@property (nonatomic) NSMapTable   *allReuseHeaders;
@property (nonatomic) NSMapTable   *allReuseFooters;

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

@property (nonatomic, copy) HHeaderTupleBlock headerTupleBlock;
@property (nonatomic, copy) HFooterTupleBlock footerTupleBlock;
@property (nonatomic, copy) HItemTupleBlock itemTupleBlock;

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
    return [[HTupleView alloc] initWithFrame:frame designStyle:HTupleDesignStyleSection designSection:sections];
}
+ (instancetype)tupleDesignWith:(CGRect)frame {
    return [[HTupleView alloc] initWithFrame:frame designStyle:HTupleDesignStyleTuple designSection:0];
}
- (instancetype)initWithFrame:(CGRect)frame designStyle:(HTupleDesignStyle)style designSection:(NSInteger)sections {
    _flowLayout = UICollectionViewLeftAlignedLayout.new;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:frame collectionViewLayout:_flowLayout];
    if (self) {
        _designStyle = style;
        _categoryDesign = YES;
        _designSections = sections;
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
- (void)setRefreshBlock:(HRefreshTupleBlock)refreshBlock {
    _refreshBlock = refreshBlock;
    if (_refreshBlock) {
        self.mj_header = [HTupleRefresh refreshHeaderWithStyle:_refreshHeaderStyle andBlock:^{
            [self setPageNo:1];
            self->_refreshBlock();
        }];
    }else {
        self.mj_header = nil;
    }
}
- (void)setLoadMoreBlock:(HLoadMoreTupleBlock)loadMoreBlock {
    _loadMoreBlock = loadMoreBlock;
    if (_loadMoreBlock) {
        [self setPageNo:1];
        self.mj_footer = [HTupleRefresh refreshFooterWithStyle:_refreshFooterStyle andBlock:^{
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
    return [UIColor clearColor];
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
    __block UICollectionViewCell *cell = nil;
    @weakify(self)
    id (^HCellForItemBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
        @strongify(self)
        NSString *identifier = NSStringFromClass(cls);
        identifier = [identifier stringByAppendingString:[self string]];
        identifier = [identifier stringByAppendingString:@"ItemCell"];
        identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
        if (pre) identifier = [identifier stringByAppendingString:pre];
        if (idx) identifier = [identifier stringByAppendingString:[indexPath string]];
        if (![self.allReuseIdentifiers containsObject:identifier]) {
            [self.allReuseIdentifiers addObject:identifier];
            [self registerClass:cls forCellWithReuseIdentifier:identifier];
            cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            HTupleBaseCell *tmpCell = (HTupleBaseCell *)cell;
            tmpCell.collection = self;
            tmpCell.indexPath = indexPath;
            //init method
            if (iblk) {
                HTupleCellInitBlock initCellBlock = iblk;
                if (initCellBlock) {
                    initCellBlock(cell);
                }
            }
        }else {
            cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        }
        [self.allReuseCells setObject:cell forKey:indexPath.string];
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        if (!self.categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForItemAtIndexPath:)]) {
            edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForItemAtIndexPath:indexPath];
        }else if (self.categoryDesign && [self respondsToSelector:@selector(tupleView:edgeInsetsForItemAtIndexPath:)]) {
            edgeInsets = [self tupleView:self edgeInsetsForItemAtIndexPath:indexPath];
        }else if (self.edgeInsetsForItemBlock) {
            edgeInsets = self.edgeInsetsForItemBlock(indexPath);
        }
        if ([cell respondsToSelector:@selector(edgeInsets)]) {
            [(HTupleBaseCell *)cell setEdgeInsets:edgeInsets];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HTupleBaseCell *)cell layoutContentView];
        }
        return cell;
    };
    if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:itemTuple:atIndexPath:)]) {
        [self.tupleDelegate tupleView:self itemTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForItemBlock(iblk, cls, pre, idx);
        } atIndexPath:indexPath];
    }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:itemTuple:atIndexPath:)]) {
        [self tupleView:self itemTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForItemBlock(iblk, cls, pre, idx);
        } atIndexPath:indexPath];
    }else if (self.itemTupleBlock) {
        self.itemTupleBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            return HCellForItemBlock(iblk, cls, pre, idx);
        }, indexPath);
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    __block UICollectionReusableView *cell = nil;
    @weakify(self)
    if (kind == UICollectionElementKindSectionHeader) {
        id (^HCellForHeaderBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
            @strongify(self)
            NSString *identifier = NSStringFromClass(cls);
            identifier = [identifier stringByAppendingString:[self string]];
            identifier = [identifier stringByAppendingString:@"HeaderCell"];
            identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
            if (pre) identifier = [identifier stringByAppendingString:pre];
            if (idx) identifier = [identifier stringByAppendingString:[indexPath string]];
            if (![self.allReuseIdentifiers containsObject:identifier]) {
                [self.allReuseIdentifiers addObject:identifier];
                [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
                cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
                HTupleBaseView *tmpCell = (HTupleBaseView *)cell;
                tmpCell.collection = self;
                tmpCell.indexPath = indexPath;
                tmpCell.isHeader = YES;
                //init method
                if (iblk) {
                    HTupleCellInitBlock initHeaderBlock = iblk;
                    if (initHeaderBlock) {
                        initHeaderBlock(cell);
                    }
                }
            }else {
                cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
            }
            [self.allReuseHeaders setObject:cell forKey:indexPath.string];
            UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
            if (!self.categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForHeaderInSection:)]) {
                edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForHeaderInSection:indexPath.section];
            }else if (self.categoryDesign && [self respondsToSelector:@selector(tupleView:edgeInsetsForHeaderInSection:)]) {
                edgeInsets = [self tupleView:self edgeInsetsForHeaderInSection:indexPath.section];
            }else if (self.edgeInsetsForHeaderBlock) {
                edgeInsets = self.edgeInsetsForHeaderBlock(indexPath.section);
            }
            if ([cell respondsToSelector:@selector(edgeInsets)]) {
                [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
            }
            if ([cell respondsToSelector:@selector(layoutContentView)]) {
                [(HTupleBaseView *)cell layoutContentView];
            }
            return cell;
        };
        if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:headerTuple:inSection:)]) {
            [self.tupleDelegate tupleView:self headerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return HCellForHeaderBlock(iblk, cls, pre, idx);
            } inSection:indexPath.section];
        }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:headerTuple:inSection:)]) {
            [self tupleView:self headerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return HCellForHeaderBlock(iblk, cls, pre, idx);
            } inSection:indexPath.section];
        }else if (self.headerTupleBlock) {
            self.headerTupleBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return HCellForHeaderBlock(iblk, cls, pre, idx);
            }, indexPath.section);
        }
    }else if (kind == UICollectionElementKindSectionFooter) {
        id (^HCellForFooterBlock)(id iblk, Class cls, id pre, bool idx) = ^(id iblk, Class cls, id pre, bool idx) {
            @strongify(self)
            NSString *identifier = NSStringFromClass(cls);
            identifier = [identifier stringByAppendingString:[self string]];
            identifier = [identifier stringByAppendingString:@"FooterCell"];
            identifier = [identifier stringByAppendingFormat:@"%@", @(self.tupleState)];
            if (pre) identifier = [identifier stringByAppendingString:pre];
            if (idx) identifier = [identifier stringByAppendingString:[indexPath string]];
            if (![self.allReuseIdentifiers containsObject:identifier]) {
                [self.allReuseIdentifiers addObject:identifier];
                [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
                cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
                HTupleBaseView *tmpCell = (HTupleBaseView *)cell;
                tmpCell.collection = self;
                tmpCell.indexPath = indexPath;
                tmpCell.isHeader = NO;
                //init method
                if (iblk) {
                    HTupleCellInitBlock initFooterBlock = iblk;
                    if (initFooterBlock) {
                        initFooterBlock(cell);
                    }
                }
            }else {
                cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
            }
            [self.allReuseFooters setObject:cell forKey:indexPath.string];
            UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
            if (!self.categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForFooterInSection:)]) {
                edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForFooterInSection:indexPath.section];
            }else if (self.categoryDesign && [self respondsToSelector:@selector(tupleView:edgeInsetsForFooterInSection:)]) {
                edgeInsets = [self tupleView:self edgeInsetsForFooterInSection:indexPath.section];
            }else if (self.edgeInsetsForFooterBlock) {
                edgeInsets = self.edgeInsetsForFooterBlock(indexPath.section);
            }
            if ([cell respondsToSelector:@selector(edgeInsets)]) {
                [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
            }
            if ([cell respondsToSelector:@selector(layoutContentView)]) {
                [(HTupleBaseView *)cell layoutContentView];
            }
            return cell;
        };
        if (!_categoryDesign && [self.tupleDelegate respondsToSelector:@selector(tupleView:footerTuple:inSection:)]) {
            [self.tupleDelegate tupleView:self footerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return HCellForFooterBlock(iblk, cls, pre, idx);
            } inSection:indexPath.section];
        }else if (_categoryDesign && [self respondsToSelector:@selector(tupleView:footerTuple:inSection:)]) {
            [self tupleView:self footerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return HCellForFooterBlock(iblk, cls, pre, idx);
            } inSection:indexPath.section];
        }else if (self.footerTupleBlock) {
            self.footerTupleBlock(^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                return HCellForFooterBlock(iblk, cls, pre, idx);
            }, indexPath.section);
        }
    }
    return cell;
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
#if DEBUG
    //打印方案一
//    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
//    if (cell) NSLog(@"cellName-->:%@", NSStringFromClass(cell.class));
//    UIViewController *vc = nil;
//    for (UIView *view = self; view; view = view.superview) {
//        UIResponder *nextResponder = [view nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            vc = (UIViewController *)nextResponder;
//            break;
//        }
//    }
//    if (vc) NSLog(@"vcName-->:%@", NSStringFromClass(vc.class));
    //打印方案二
//    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
//    if ([vc isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *navi = (UINavigationController *)vc;
//        if (navi) NSLog(@"vcName-->:%@", NSStringFromClass(navi.topViewController.class));
//    }else if ([vc isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabbarVC = (UITabBarController *)vc;
//        if ([tabbarVC.selectedViewController isKindOfClass:UINavigationController.class]) {
//            UINavigationController *navi = (UINavigationController *)tabbarVC.selectedViewController;
//            if (navi) NSLog(@"vcName-->:%@", NSStringFromClass(navi.topViewController.class));
//        }else {
//            if (vc) NSLog(@"vcName-->:%@", NSStringFromClass(tabbarVC.selectedViewController.class));
//        }
//    }else {
//        if (vc) NSLog(@"vcName-->:%@", NSStringFromClass(vc.class));
//    }
#endif
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
- (void)headerWithSize:(HSizeForHeaderBlock)size edgeInsets:(HEdgeInsetsForHeaderBlock)edge tuple:(HHeaderTupleBlock)block {
    self.sizeForHeaderBlock = size;
    self.edgeInsetsForHeaderBlock = edge;
    self.headerTupleBlock = block;
}
- (void)footerWithSize:(HSizeForFooterBlock)size edgeInsets:(HEdgeInsetsForFooterBlock)edge tuple:(HFooterTupleBlock)block {
    self.sizeForFooterBlock = size;
    self.edgeInsetsForFooterBlock = edge;
    self.footerTupleBlock = block;
}
- (void)itemWithSize:(HSizeForItemBlock)size edgeInsets:(HEdgeInsetsForItemBlock)edge tuple:(HItemTupleBlock)block {
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
- (void)tupleView:(UICollectionView *)tupleView headerTuple:(HHeaderTuple)headerBlock inSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &headerBlock, &section];
    }
}
- (void)tupleView:(UICollectionView *)tupleView footerTuple:(HFooterTuple)footerBlock inSection:(NSInteger)section {
    NSString *prefix = [self tupleWithPrefix:section];
    if ([(NSObject *)self.tupleDelegate respondsToSelector:_cmd withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:_cmd withPre:prefix withMethodArgments:&tupleView, &footerBlock, &section];
    }
}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(HItemTuple)itemBlock atIndexPath:(NSIndexPath *)indexPath {
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
- (HTupleState)tupleState {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setTupleState:(HTupleState)tupleState {
    if (self.tupleState != tupleState) {
        objc_setAssociatedObject(self, @selector(tupleState), @(tupleState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self reloadData];
    }
}

- (HTupleCellSignalBlock)signalBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSignalBlock:(HTupleCellSignalBlock)signalBlock {
    objc_setAssociatedObject(self, @selector(signalBlock), signalBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)signalToTupleView:(HTupleSignal *)signal {
    if (self.signalBlock) {
        self.signalBlock(self, signal);
    }
}
- (void)signalToAllItems:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSInteger items = [self numberOfItemsInSection:i];
            for (int j=0; j<items; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UICollectionViewCell *cell = [self.allReuseCells objectForKey:indexPath.string];
                if (cell.signalBlock) {
                    cell.signalBlock(cell, signal);
                }
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal itemSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger items = [self numberOfItemsInSection:section];
        for (int i=0; i<items; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            UICollectionViewCell *cell = [self.allReuseCells objectForKey:indexPath.string];
            if (cell.signalBlock) {
                cell.signalBlock(cell, signal);
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal indexPath:(NSIndexPath *)indexPath  {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UICollectionViewCell *cell = [self.allReuseCells objectForKey:indexPath.string];
        if (cell.signalBlock) {
            cell.signalBlock(cell, signal);
        }
    });
}
- (void)signalToAllHeader:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            HTupleBaseView *cell = [self.allReuseHeaders objectForKey:indexPath.string];
            if (cell.signalBlock) {
                cell.signalBlock(cell, signal);
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal headerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        HTupleBaseView *cell = [self.allReuseHeaders objectForKey:indexPath.string];
        if (cell.signalBlock) {
            cell.signalBlock(cell, signal);
        }
    });
}
- (void)signalToAllFooter:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            HTupleBaseView *cell = [self.allReuseFooters objectForKey:indexPath.string];
            if (cell.signalBlock) {
                cell.signalBlock(cell, signal);
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal footerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        HTupleBaseView *cell = [self.allReuseFooters objectForKey:indexPath.string];
        if (cell.signalBlock) {
            cell.signalBlock(cell, signal);
        }
    });
}
- (id (^)(NSInteger row, NSInteger section))cell {
    return ^id (NSInteger row, NSInteger section) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        return [self.allReuseCells objectForKey:indexPath.string];
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
- (NSString *)string {
    return [NSString stringWithFormat:@"%p", self];
}
@end
