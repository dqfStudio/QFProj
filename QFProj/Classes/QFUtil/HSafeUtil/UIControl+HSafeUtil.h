//
//  UIControl+HSafeUtil.h
//  HProj
//
//  Created by dqf on 2017/9/30.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HSwizzleUtil.h"

@interface UIControl (HSafeUtil)
@property (nonatomic) NSTimeInterval timeInterval;//点击时间间隔
@property (nonatomic) UIEdgeInsets touchAreaInsets;//设置按钮额外热区
@end
