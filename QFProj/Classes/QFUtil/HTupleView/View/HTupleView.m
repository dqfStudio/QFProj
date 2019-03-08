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
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:itemTuple:atIndexPath:)]) {
        [self.tupleDelegate tupleView:self itemTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
            NSString *identifier = NSStringFromClass(cls);
            identifier = [identifier stringByAppendingString:[self string]];
            identifier = [identifier stringByAppendingString:@"ItemCell"];
            if (pre) identifier = [identifier stringByAppendingString:pre];
            if (idx) identifier = [identifier stringByAppendingString:[indexPath string]];
            if (![self.allReuseCells containsObject:identifier]) {
                [self.allReuseCells addObject:identifier];
                [self registerClass:cls forCellWithReuseIdentifier:identifier];
                cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
                HTupleBaseCell *tmpCell = (HTupleBaseCell *)cell;
                tmpCell.collection = self;
                tmpCell.indexPath = indexPath;
            }else {
                cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            }
            UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
            if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForItemAtIndexPath:)]) {
                edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForItemAtIndexPath:indexPath];
            }
            if ([cell respondsToSelector:@selector(edgeInsets)]) {
                [(HTupleBaseCell *)cell setEdgeInsets:edgeInsets];
            }
            if (iblk) {
                HTupleCellInitBlock initCellBlock = iblk;
                if (initCellBlock) {
                    initCellBlock(self);
                }
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
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:sizeForFooterInSection:)]) {
        return [self.tupleDelegate tupleView:self sizeForFooterInSection:section];
    }
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    __block UICollectionReusableView *cell = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if ([self.tupleDelegate respondsToSelector:@selector(tupleView:headerTuple:inSection:)]) {
            [self.tupleDelegate tupleView:self headerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                NSString *identifier = NSStringFromClass(cls);
                identifier = [identifier stringByAppendingString:[self string]];
                identifier = [identifier stringByAppendingString:@"HeaderCell"];
                if (pre) identifier = [identifier stringByAppendingString:pre];
                if (idx) identifier = [identifier stringByAppendingString:[indexPath string]];
                if (![self.allReuseCells containsObject:identifier]) {
                    [self.allReuseCells addObject:identifier];
                    [self.allReuseHeaders setObject:identifier forKey:@(indexPath.section).stringValue];
                    [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
                    HTupleBaseView *tmpCell = (HTupleBaseView *)cell;
                    tmpCell.collection = self;
                    tmpCell.indexPath = indexPath;
                }else {
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
                }
                UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
                if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForHeaderInSection:)]) {
                    edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForHeaderInSection:indexPath.section];
                }
                if ([cell respondsToSelector:@selector(edgeInsets)]) {
                    [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
                }
                if (iblk) {
                    HTupleCellInitBlock initHeaderBlock = iblk;
                    if (initHeaderBlock) {
                        initHeaderBlock(self);
                    }
                }
                if ([cell respondsToSelector:@selector(layoutContentView)]) {
                    [(HTupleBaseView *)cell layoutContentView];
                }
                return cell;
            } inSection:indexPath.section];
        }
    }else if (kind == UICollectionElementKindSectionFooter) {
        if ([self.tupleDelegate respondsToSelector:@selector(tupleView:footerTuple:inSection:)]) {
            [self.tupleDelegate tupleView:self footerTuple:^id(id iblk, __unsafe_unretained Class cls, id pre, bool idx) {
                NSString *identifier = NSStringFromClass(cls);
                identifier = [identifier stringByAppendingString:[self string]];
                identifier = [identifier stringByAppendingString:@"FooterCell"];
                if (pre) identifier = [identifier stringByAppendingString:pre];
                if (idx) identifier = [identifier stringByAppendingString:[indexPath string]];
                if (![self.allReuseCells containsObject:identifier]) {
                    [self.allReuseCells addObject:identifier];
                    [self.allReuseFooters setObject:identifier forKey:@(indexPath.section).stringValue];
                    [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
                    HTupleBaseView *tmpCell = (HTupleBaseView *)cell;
                    tmpCell.collection = self;
                    tmpCell.indexPath = indexPath;
                }else {
                    cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
                }
                UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
                if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForFooterInSection:)]) {
                    edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForFooterInSection:indexPath.section];
                }
                if ([cell respondsToSelector:@selector(edgeInsets)]) {
                    [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
                }
                if (iblk) {
                    HTupleCellInitBlock initFooterBlock = iblk;
                    if (initFooterBlock) {
                        initFooterBlock(self);
                    }
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
    return UIEdgeInsetsZero;
}
@end


