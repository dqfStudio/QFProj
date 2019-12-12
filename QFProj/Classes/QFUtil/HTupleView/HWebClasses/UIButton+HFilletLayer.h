//
//  UIButton+HFilletLayer.h
//  QFProj
//
//  Created by dqf on 2019/9/5.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+HFilletLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HFilletLayer)
@property (nonatomic) BOOL fillet;//是否圆角展示图片
@property (nonatomic) UIImageViewFilletStyle filletStyle;//默认居中显示
@end

NS_ASSUME_NONNULL_END
