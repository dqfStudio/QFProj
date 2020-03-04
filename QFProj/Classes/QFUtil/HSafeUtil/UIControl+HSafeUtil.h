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
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end
