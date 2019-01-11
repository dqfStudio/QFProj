//
//  HTupleView.m
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleView.h"

@implementation NSIndexPath (HString)
- (NSString *)string {
    return [NSString stringWithFormat:@"%@%@",@(self.section),@(self.row)];
}
@end

@interface HTupleView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic) NSMutableSet *allReuseCells;
@property (nonatomic) NSMutableDictionary *allReuseHeaders;
@property (nonatomic) NSMutableDictionary *allReuseFooters;
@end

@implementation HTupleView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame collectionViewLayout:[UICollectionViewLeftAlignedLayout new]];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(HTupleViewScrollDirection)direction {
    UICollectionViewFlowLayout *flowLayout = nil;
    if (direction == HTupleViewScrollDirectionHorizontal) {
        flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else {
        flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(HTupleViewStyle)style {
    UICollectionViewFlowLayout *flowLayout = nil;
    if (style == HTupleViewStyleLeftAlignedLayout) {
        flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    }else {
        flowLayout = [[ULBCollectionViewFlowLayout alloc] init];
    }
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
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
    self.alwaysBounceVertical = YES;
    self.backgroundColor = [UIColor clearColor];
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _allReuseCells = [NSMutableSet new];
    _allReuseHeaders = [NSMutableDictionary new];
    _allReuseFooters = [NSMutableDictionary new];
    self.delegate = self;
    self.dataSource = self;
}
- (id)headerWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@HeaderCell",NSStringFromClass(aClass)];
    if (![self.allReuseCells containsObject:identifier]) {
        [self.allReuseCells addObject:identifier];
        [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
    }
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
}
- (id)footerWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@FooterCell",NSStringFromClass(aClass)];
    if (![self.allReuseCells containsObject:identifier]) {
        [self.allReuseCells addObject:identifier];
        [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
    }
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
}
- (id)itemWithReuseClass:(Class)aClass atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@ItemCell",NSStringFromClass(aClass)];
    if (![self.allReuseCells containsObject:identifier]) {
        [self.allReuseCells addObject:identifier];
        [self registerClass:aClass forCellWithReuseIdentifier:identifier];
    }
    return [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark - signal

- (HTupleCellSignalBlock)signalBlock {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setSignalBlock:(HTupleCellSignalBlock)signalBlock {
    [self setAssociateValue:signalBlock withKey:@selector(signalBlock)];
}

- (void)signalToTupleView:(HTupleSignal *)signal {
    if (self.signalBlock) {
        self.signalBlock(signal);
    }
}
- (void)signalToAllItems:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSInteger items = [self numberOfItemsInSection:i];
            for (int j=0; j<items; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
                if (cell.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.signalBlock(signal);
                    });
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
            UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
            if (cell.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.signalBlock(signal);
                });
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal indexPath:(NSIndexPath *)indexPath  {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
        if (cell.signalBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.signalBlock(signal);
            });
        }
    });
}
- (void)signalToAllHeader:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSString *identifier = self.allReuseHeaders[@(i).stringValue];
            if (identifier) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                HTupleBaseView *cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
                if (cell.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.signalBlock(signal);
                    });
                }
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal headerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSString *identifier = self.allReuseHeaders[@(section).stringValue];
        if (identifier) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            HTupleBaseView *cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
            if (cell.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.signalBlock(signal);
                });
            }
        }
    });
}
- (void)signalToAllFooter:(HTupleSignal *)signal {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSInteger sections = [self numberOfSections];
        for (int i=0; i<sections; i++) {
            NSString *identifier = self.allReuseFooters[@(i).stringValue];
            if (identifier) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                HTupleBaseView *cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
                if (cell.signalBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.signalBlock(signal);
                    });
                }
            }
        }
    });
}
- (void)signal:(HTupleSignal *)signal footerSection:(NSInteger)section {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        NSString *identifier = self.allReuseFooters[@(section).stringValue];
        if (identifier) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            HTupleBaseView *cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
            if (cell.signalBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.signalBlock(signal);
                });
            }
        }
    });
}
- (id (^)(NSInteger row, NSInteger section))cell {
    return ^id (NSInteger row, NSInteger section) {
        return [self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
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

#pragma mark - UICollectionViewDatasource  & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {    
    if ([self.tupleDelegate respondsToSelector:@selector(numberOfSectionsInTupleView:)]) {
        return [self.tupleDelegate numberOfSectionsInTupleView:self];
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:numberOfItemsInSection:)]) {
        return [self.tupleDelegate tupleView:self numberOfItemsInSection:section];
    }
    return 0;
}
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section {
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:colorForSectionAtIndex:)]) {
        return [self.tupleDelegate tupleView:self colorForSectionAtIndex:section];
    }
    return [UIColor clearColor];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block UICollectionViewCell *cell = nil;
    __block UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    __block HTupleCellInitBlock initCellBlock;
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:initTuple:itemTuple:atIndexPath:)]) {
        [self.tupleDelegate tupleView:self initTuple:^(HTupleCellInitBlock initBlock) {
            initCellBlock = initBlock;
        } itemTuple:^id(__unsafe_unretained Class aClass) {
            NSString *idxPath = [NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)];
            NSString *identifier = [NSString stringWithFormat:@"%@ItemCell%@",NSStringFromClass(aClass),idxPath];
            if (![self.allReuseCells containsObject:identifier]) {
                [self.allReuseCells addObject:identifier];
                [self registerClass:aClass forCellWithReuseIdentifier:identifier];
                cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
                HTupleBaseCell *tmpCell = (HTupleBaseCell *)cell;
                tmpCell.collection = self;
                tmpCell.indexPath = indexPath;
            }else {
                cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            }
            if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForItemAtIndexPath:)]) {
                edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForItemAtIndexPath:indexPath];
            }
            if ([cell respondsToSelector:@selector(edgeInsets)]) {
                [(HTupleBaseCell *)cell setEdgeInsets:edgeInsets];
            }
            if (initCellBlock) {
                initCellBlock();
            }
            if ([cell respondsToSelector:@selector(layoutContentView)]) {
                [(HTupleBaseCell *)cell layoutContentView];
            }
            return cell;
        } atIndexPath:indexPath];
    }else if ([self.tupleDelegate respondsToSelector:@selector(tupleView:initTuple:itemTuple_prefix:atIndexPath:)]) {
        [self.tupleDelegate tupleView:self initTuple:^(HTupleCellInitBlock initBlock) {
            initCellBlock = initBlock;
        } itemTuple_prefix:^id(__unsafe_unretained Class aClass, NSString *prefix, BOOL idx) {
            NSString *idxPath = @"";
            if (idx) idxPath = [NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)];
            prefix = prefix ? : @"";
            NSString *identifier = [NSString stringWithFormat:@"%@%@ItemCell%@", prefix,NSStringFromClass(aClass),idxPath];
            if (![self.allReuseCells containsObject:identifier]) {
                [self.allReuseCells addObject:identifier];
                [self registerClass:aClass forCellWithReuseIdentifier:identifier];
                cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
                HTupleBaseCell *tmpCell = (HTupleBaseCell *)cell;
                tmpCell.collection = self;
                tmpCell.indexPath = indexPath;
            }else {
                cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            }
            if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForItemAtIndexPath:)]) {
                edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForItemAtIndexPath:indexPath];
            }
            if ([cell respondsToSelector:@selector(edgeInsets)]) {
                [(HTupleBaseCell *)cell setEdgeInsets:edgeInsets];
            }
            if (initCellBlock) {
                initCellBlock();
            }
            if ([cell respondsToSelector:@selector(layoutContentView)]) {
                [(HTupleBaseCell *)cell layoutContentView];
            }
            return cell;
        } atIndexPath:indexPath];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:sizeForItemAtIndexPath:)]) {
        return [self.tupleDelegate tupleView:self sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:sizeForHeaderInSection:)]) {
        return [self.tupleDelegate tupleView:self sizeForHeaderInSection:section];
    }
    return CGSizeMake(0.f, 0.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:sizeForFooterInSection:)]) {
        return [self.tupleDelegate tupleView:self sizeForFooterInSection:section];
    }
    return CGSizeMake(0.f, 0.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    __block UICollectionReusableView *cell = nil;
    __block UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    __block HTupleCellInitBlock initHeaderBlock;
    __block HTupleCellInitBlock initFooterBlock;
    if (kind == UICollectionElementKindSectionHeader) {
        if ([self.tupleDelegate respondsToSelector:@selector(tupleView:initTuple:headerTuple:inSection:)]) {
            [self.tupleDelegate tupleView:self initTuple:^(HTupleCellInitBlock initBlock) {
                initHeaderBlock = initBlock;
            } headerTuple:^id(__unsafe_unretained Class aClass) {
                NSString *idxPath = [NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)];
                NSString *identifier = [NSString stringWithFormat:@"%@HeaderCell%@",NSStringFromClass(aClass),idxPath];
                if (![self.allReuseCells containsObject:identifier]) {
                    [self.allReuseCells addObject:identifier];
                    [self.allReuseHeaders setObject:identifier forKey:@(indexPath.section).stringValue];
                    [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
                    HTupleBaseView *tmpCell = (HTupleBaseView *)cell;
                    tmpCell.collection = self;
                    tmpCell.indexPath = indexPath;
                }else {
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
                }
                if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForHeaderInSection:)]) {
                    edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForHeaderInSection:indexPath.section];
                }
                if ([cell respondsToSelector:@selector(edgeInsets)]) {
                    [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
                }
                if (initHeaderBlock) {
                    initHeaderBlock();
                }
                if ([cell respondsToSelector:@selector(layoutContentView)]) {
                    [(HTupleBaseView *)cell layoutContentView];
                }
                return cell;
            } inSection:indexPath.section];
        }else if ([self.tupleDelegate respondsToSelector:@selector(tupleView:initTuple:headerTuple_prefix:inSection:)]) {
            [self.tupleDelegate tupleView:self initTuple:^(HTupleCellInitBlock initBlock) {
                initHeaderBlock = initBlock;
            } headerTuple_prefix:^id(__unsafe_unretained Class aClass, NSString *prefix, BOOL idx) {
                NSString *idxPath = @"";
                if (idx) idxPath = [NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)];
                prefix = prefix ? : @"";
                NSString *identifier = [NSString stringWithFormat:@"%@%@HeaderCell%@",prefix,NSStringFromClass(aClass),idxPath];
                if (![self.allReuseCells containsObject:identifier]) {
                    [self.allReuseCells addObject:identifier];
                    [self.allReuseHeaders setObject:identifier forKey:@(indexPath.section).stringValue];
                    [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
                    HTupleBaseView *tmpCell = (HTupleBaseView *)cell;
                    tmpCell.collection = self;
                    tmpCell.indexPath = indexPath;
                }else {
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
                }
                if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForHeaderInSection:)]) {
                    edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForHeaderInSection:indexPath.section];
                }
                if ([cell respondsToSelector:@selector(edgeInsets)]) {
                    [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
                }
                if (initHeaderBlock) {
                    initHeaderBlock();
                }
                if ([cell respondsToSelector:@selector(layoutContentView)]) {
                    [(HTupleBaseView *)cell layoutContentView];
                }
                return cell;
            } inSection:indexPath.section];
        }
        
    }else if (kind == UICollectionElementKindSectionFooter) {
        if ([self.tupleDelegate respondsToSelector:@selector(tupleView:initTuple:footerTuple:inSection:)]) {
            [self.tupleDelegate tupleView:self initTuple:^(HTupleCellInitBlock initBlock) {
                initFooterBlock = initBlock;
            } footerTuple:^id(__unsafe_unretained Class aClass) {
                NSString *idxPath = [NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)];
                NSString *identifier = [NSString stringWithFormat:@"%@FooterCell%@",NSStringFromClass(aClass),idxPath];
                if (![self.allReuseCells containsObject:identifier]) {
                    [self.allReuseCells addObject:identifier];
                    [self.allReuseFooters setObject:identifier forKey:@(indexPath.section).stringValue];
                    [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
                    HTupleBaseView *tmpCell = (HTupleBaseView *)cell;
                    tmpCell.collection = self;
                    tmpCell.indexPath = indexPath;
                }else {
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
                }
                if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForFooterInSection:)]) {
                    edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForFooterInSection:indexPath.section];
                }
                if ([cell respondsToSelector:@selector(edgeInsets)]) {
                    [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
                }
                if (initFooterBlock) {
                    initFooterBlock();
                }
                if ([cell respondsToSelector:@selector(layoutContentView)]) {
                    [(HTupleBaseView *)cell layoutContentView];
                }
                return cell;
            } inSection:indexPath.section];
        }
        else if ([self.tupleDelegate respondsToSelector:@selector(tupleView:initTuple:footerTuple_prefix:inSection:)]) {
            [self.tupleDelegate tupleView:self initTuple:^(HTupleCellInitBlock initBlock) {
                initFooterBlock = initBlock;
            } footerTuple_prefix:^id(__unsafe_unretained Class aClass, NSString *prefix, BOOL idx) {
                NSString *idxPath = @"";
                if (idx) idxPath = [NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)];
                prefix = prefix ? : @"";
                NSString *identifier = [NSString stringWithFormat:@"%@%@FooterCell%@",prefix,NSStringFromClass(aClass),idxPath];
                if (![self.allReuseCells containsObject:identifier]) {
                    [self.allReuseCells addObject:identifier];
                    [self.allReuseFooters setObject:identifier forKey:@(indexPath.section).stringValue];
                    [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
                    HTupleBaseView *tmpCell = (HTupleBaseView *)cell;
                    tmpCell.collection = self;
                    tmpCell.indexPath = indexPath;
                }else {
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
                }
                if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForFooterInSection:)]) {
                    edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForFooterInSection:indexPath.section];
                }
                if ([cell respondsToSelector:@selector(edgeInsets)]) {
                    [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
                }
                if (initFooterBlock) {
                    initFooterBlock();
                }
                if ([cell respondsToSelector:@selector(layoutContentView)]) {
                    [(HTupleBaseView *)cell layoutContentView];
                }
                return cell;
            } inSection:indexPath.section];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:didSelectItemAtIndexPath:)]) {
        return [self.tupleDelegate tupleView:self didSelectItemAtIndexPath:indexPath];
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:layout:insetForSectionAtIndex:)]) {
        return [self.tupleDelegate tupleView:self layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}
@end


