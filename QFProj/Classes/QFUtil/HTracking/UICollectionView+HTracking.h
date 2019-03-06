//
//  UICollectionView+HTracking.h
//  QFProj
//
//  Created by dqf on 2018/7/28.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HSwizzleUtil.h"

/*
 *必须原collectionView的delegate实现了collectionView:didSelectItemAtIndexPath:才能AOP
 */

@interface UICollectionView (HTracking)

@end
