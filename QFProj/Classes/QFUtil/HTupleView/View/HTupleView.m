//
//  HTupleView.m
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleView.h"

@interface HTupleView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic) NSMutableSet *allReuseCells;
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
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
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
    
    _allReuseCells = [NSMutableSet new];
    self.delegate = self;
    self.dataSource = self;
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block UICollectionViewCell *cell = nil;
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if ([self.tupleDelegate respondsToSelector:@selector(tupleView:itemTuple:atIndexPath:)]) {
        [self.tupleDelegate tupleView:self itemTuple:^id(__unsafe_unretained Class aClass) {
            if (![self.allReuseCells containsObject:NSStringFromClass(aClass)]) {
                [self.allReuseCells addObject:NSStringFromClass(aClass)];
                [self registerClass:aClass forCellWithReuseIdentifier:NSStringFromClass(aClass)];
            }
            cell = [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(aClass) forIndexPath:indexPath];
            return cell;
        } atIndexPath:indexPath];
        if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForItemAtIndexPath:)]) {
            edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForItemAtIndexPath:indexPath];
        }
        if ([cell respondsToSelector:@selector(edgeInsets)]) {
            [(HTupleBaseCell *)cell setEdgeInsets:edgeInsets];
        }
        if ([cell respondsToSelector:@selector(layoutContentView)]) {
            [(HTupleBaseCell *)cell layoutContentView];
        }
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
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (kind == UICollectionElementKindSectionHeader) {
        if ([self.tupleDelegate respondsToSelector:@selector(tupleView:headerTuple:inSection:)]) {
            [self.tupleDelegate tupleView:self headerTuple:^id(__unsafe_unretained Class aClass) {
                if (![self.allReuseCells containsObject:NSStringFromClass(aClass)]) {
                    [self.allReuseCells addObject:NSStringFromClass(aClass)];
                    [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(aClass)];
                }
                cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(aClass) forIndexPath:indexPath];
                return cell;
            } inSection:indexPath.section];
            if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForHeaderInSection:)]) {
                edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForHeaderInSection:indexPath.section];
            }
            if ([cell respondsToSelector:@selector(edgeInsets)]) {
                [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
            }
            if ([cell respondsToSelector:@selector(layoutContentView)]) {
                [(HTupleBaseView *)cell layoutContentView];
            }
        }
        
    }else if (kind == UICollectionElementKindSectionFooter) {
        if ([self.tupleDelegate respondsToSelector:@selector(tupleView:footerTuple:inSection:)]) {
            [self.tupleDelegate tupleView:self footerTuple:^id(__unsafe_unretained Class aClass) {
                if (![self.allReuseCells containsObject:NSStringFromClass(aClass)]) {
                    [self.allReuseCells addObject:NSStringFromClass(aClass)];
                    [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(aClass)];
                }
                cell = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(aClass) forIndexPath:indexPath];
                return cell;
            } inSection:indexPath.section];
            if ([self.tupleDelegate respondsToSelector:@selector(tupleView:edgeInsetsForFooterInSection:)]) {
                edgeInsets = [self.tupleDelegate tupleView:self edgeInsetsForFooterInSection:indexPath.section];
            }
            if ([cell respondsToSelector:@selector(edgeInsets)]) {
                [(HTupleBaseView *)cell setEdgeInsets:edgeInsets];
            }
            if ([cell respondsToSelector:@selector(layoutContentView)]) {
                [(HTupleBaseView *)cell layoutContentView];
            }
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
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}
@end


