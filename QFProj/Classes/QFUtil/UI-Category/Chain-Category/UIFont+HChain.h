//
//  UIFont+HChain.h
//  TestProject
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (HChain)

+ (UIFont *(^)(CGFloat size))sysFont;
+ (UIFont *(^)(CGFloat size))boldFont;

@end
