//
//  HCollectionViewFlowLayout.h
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 扩展section的背景色
@protocol HCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout colorForSectionAtIndex:(NSInteger)section;
@end

@interface HCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
