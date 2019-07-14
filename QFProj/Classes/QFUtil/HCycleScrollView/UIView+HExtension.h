//
//  UIView+HExtension.h
//  HRefreshView
//
//  Created by aier on 15-2-23.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HColorCreater(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

@interface UIView (HExtension)

@property (nonatomic, assign) CGFloat hc_height;
@property (nonatomic, assign) CGFloat hc_width;

@property (nonatomic, assign) CGFloat hc_y;
@property (nonatomic, assign) CGFloat hc_x;

@end
