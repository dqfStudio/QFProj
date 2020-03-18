//
//  UIColor+HUtil.h
//  HProj
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HColorHex(_hex_) [UIColor colorWithString:((__bridge NSString *)CFSTR(#_hex_))]
#define HColorHexAlpha(_hex_, _alpha_) [UIColor colorWithString:((__bridge NSString *)CFSTR(#_hex_)) alpha:_alpha_]

@interface UIColor (HUtil)

- (UIColor *)revertColor;

//formate : @"#f6ee34" or @"0x45fed2"
+ (UIColor *)colorWithString:(NSString *)colorStr alpha:(float)alpha;
+ (UIColor *)colorWithString:(NSString *)colorStr;

//formate : 0x9875a3
+ (UIColor *)colorWithHex:(int)hex alpha:(float)alpha;
+ (UIColor *)colorWithHex:(int)hex;

+ (UIColor *)random;
- (BOOL)isLighterColor;
@end

