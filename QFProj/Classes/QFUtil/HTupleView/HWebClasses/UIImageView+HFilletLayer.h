//
//  UIImageView+HFilletLayer.h
//  QFProj
//
//  Created by wind on 2019/9/5.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HSwizzleUtil.h"

typedef NS_OPTIONS(NSUInteger, UIImageViewFilletStyle) {
    UIImageViewFilletCenter = 0,
    UIImageViewFilletLeftOrTop,
    UIImageViewFilletRightOrBottom
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (HFilletLayer)
@property (nonatomic) BOOL fillet;//是否圆角展示图片
@property (nonatomic) UIImageViewFilletStyle filletStyle;//默认居中显示
@end

NS_ASSUME_NONNULL_END
