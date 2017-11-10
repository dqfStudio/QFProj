//
//  UIColor+QFUtil.h
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QFUtil)

- (UIColor *(^)(void))revertColor;

//formate : @"#f6ee34" or @"0x45fed2" or @"23, 86, 123, 0.5"
+ (UIColor *(^)(NSString *color))color;
+ (UIColor *(^)(NSString *color, CGFloat alpha))alColor;

//formate : 0x9875a3
+ (UIColor *(^)(int hex))hexColor;
+ (UIColor *(^)(int hex, int alpha))alHexColor;

+ (UIColor *(^)(void))random;

@end
