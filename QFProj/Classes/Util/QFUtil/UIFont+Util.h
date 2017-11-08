//
//  UIFont+Util.h
//  TestProject
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Util)

+ (UIFont *(^)(CGFloat size))sysFont;
+ (UIFont *(^)(CGFloat size))boldFont;

@end
