//
//  ULBCollectionViewFlowLayout.m
//  uliaobao
//
//  Created by FishYu on 16/8/24.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import "ULBCollectionViewFlowLayout.h"


static NSString *const ULBCollectionViewSectionColor = @"com.ulb.ULBCollectionElementKindSectionColor";


@interface ULBCollectionViewLayoutAttributes  : UICollectionViewLayoutAttributes
// 背景色
@property (nonatomic, strong) UIColor *backgroudColor;

@end

@implementation ULBCollectionViewLayoutAttributes

@end

@interface ULBCollectionReusableView : UICollectionReusableView

@end


@implementation ULBCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    ULBCollectionViewLayoutAttributes *attr = (ULBCollectionViewLayoutAttributes *)layoutAttributes;
    self.backgroundColor = attr.backgroudColor;
}

@end



@interface ULBCollectionViewFlowLayout  ()

@property (nonatomic, strong) UIColor *sectonColor;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end


@implementation ULBCollectionViewFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    NSInteger sections = [self.collectionView numberOfSections];
    //id<ULBCollectionViewDelegateFlowLayout> delegate  = self.collectionView.delegate;
    id<ULBCollectionViewDelegateFlowLayout> delegate  = (id)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:colorForSectionAtIndex:)]) {
    }else{
        return ;
    }
    
    //1.初始化
    [self registerClass:[ULBCollectionReusableView class] forDecorationViewOfKind:ULBCollectionViewSectionColor];
    [self.decorationViewAttrs removeAllObjects];
    
    for (NSInteger section =0; section < sections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems > 0) {
            UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            UICollectionViewLayoutAttributes *lastAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:(numberOfItems - 1) inSection:section]];
            
            UIEdgeInsets sectionInset = self.sectionInset;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
                if (!UIEdgeInsetsEqualToEdgeInsets(inset, sectionInset)) {
                    sectionInset = inset;
                }
            }
            
            
            CGRect sectionFrame = CGRectUnion(firstAttr.frame, lastAttr.frame);
            sectionFrame.origin.x -= sectionInset.left;
            sectionFrame.origin.y -= sectionInset.top;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                sectionFrame.size.width += sectionInset.left + sectionInset.right;
                sectionFrame.size.height = self.collectionView.frame.size.height;
            }else{
                sectionFrame.size.width = self.collectionView.frame.size.width;
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
            }
            
            //2. 定义
            ULBCollectionViewLayoutAttributes *attr = [ULBCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:ULBCollectionViewSectionColor withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attr.frame = sectionFrame;
            attr.zIndex = -1;
            attr.backgroudColor = [delegate collectionView:self.collectionView layout:self colorForSectionAtIndex:section];
            [self.decorationViewAttrs addObject:attr];
        }else{
            continue ;
        }
    }
    
}

//此类原有方法
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSMutableArray *attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
//        if (CGRectIntersectsRect(rect, attr.frame)) {
//            [attrs addObject:attr];
//        }
//    }
//    return [attrs copy];
//}

//此类原有方法 并加上 去掉Cell之间的间隔线
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    /*
    //去掉Cell之间的间隔线
    //从第二个循环到最后一个
    for(int i =1; i < [attrs count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attrs[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attrs[i -1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = 0;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    */
    
    return [attrs copy];
}

//去掉Cell之间的间隔线
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    //从第二个循环到最后一个
//    for(int i =1; i < [attributes count]; ++i) {
//        //当前attributes
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
//        //上一个attributes
//        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i -1];
//        //我们想设置的最大间距，可根据需要改
//        NSInteger maximumSpacing = 0;
//        //前一个cell的最右边
//        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
//        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
//        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
//        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
//           CGRect frame = currentLayoutAttributes.frame;
//           frame.origin.x = origin + maximumSpacing;
//           currentLayoutAttributes.frame = frame;
//        }
//    }
//    return attributes;
//}


- (NSMutableArray<UICollectionViewLayoutAttributes *> *)decorationViewAttrs{
    if (!_decorationViewAttrs) {
        _decorationViewAttrs = [NSMutableArray array];
    }
    return _decorationViewAttrs;
}

@end
