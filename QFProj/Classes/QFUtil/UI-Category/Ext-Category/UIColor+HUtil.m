//
//  UIColor+HUtil.m
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIColor+HUtil.h"

@implementation UIColor (HUtil)

- (UIColor *)revertColor {
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    if (colorSpaceModel == kCGColorSpaceModelRGB) {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        UIColor *color = [UIColor colorWithRed:(1.0 - components[0]) green:(1.0 - components[1]) blue:(1.0 - components[2])alpha:components[3]];
        
        IMP imp = [color methodForSelector:NSSelectorFromString(@"retain")];
        void (*func)(id) = (void *)imp;
        func(color);
        
        return color;
    }
    else return nil;
}

+ (UIColor *)colorWithString:(NSString *)colorStr {
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) return [UIColor clearColor];
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6 && [cString length] != 8) return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    NSString *aString = @"FF";
    if (cString.length == 8) {
        range.location = 6;
        aString = [cString substringWithRange:range];
    }
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    
    UIColor *color = [UIColor colorWithRed:((float)r / 255.0f)
                                     green:((float)g / 255.0f)
                                      blue:((float)b / 255.0f)
                                     alpha:((float)a / 255.0f)];

    IMP imp = [color methodForSelector:NSSelectorFromString(@"retain")];
    void (*func)(id) = (void *)imp;
    func(color);
    
    return color;
}

+ (UIColor *)colorWithString:(NSString *)colorStr alpha:(float)alpha {
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) return [UIColor clearColor];
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    UIColor *color = [UIColor colorWithRed:((float)r / 255.0f)
                                     green:((float)g / 255.0f)
                                      blue:((float)b / 255.0f)
                                     alpha:alpha];
    
    IMP imp = [color methodForSelector:NSSelectorFromString(@"retain")];
    void (*func)(id) = (void *)imp;
    func(color);
    
    return color;
}

+ (UIColor *)colorWithHex:(int)hex {
    return [self colorWithHex:hex alpha:1.0];
}

+ (UIColor *)colorWithHex:(int)hex alpha:(float)alpha {
    float r = ((float)((hex & 0xff0000) >> 16))/255.0;
    float g = ((float)((hex & 0xff00) >> 8))/255.0;
    float b = ((float)((hex & 0xff) >> 0))/255.0;
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    IMP imp = [color methodForSelector:NSSelectorFromString(@"retain")];
    void (*func)(id) = (void *)imp;
    func(color);
    
    return color;
}

+ (UIColor *)random {
    UIColor *color = [UIColor colorWithRed:(arc4random()%256)*1.0/256 green:(arc4random()%256)*1.0/256 blue:(arc4random()%256)*1.0/256 alpha:1];
    
    IMP imp = [color methodForSelector:NSSelectorFromString(@"retain")];
    void (*func)(id) = (void *)imp;
    func(color);
    
    return color;
}

/*是否是浅色 YES 是浅色， NO是深色**/
- (BOOL)isLighterColor {
    CGFloat r=0, g=0, b=0, a=0;
      if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
          [self getRed:&r green:&g blue:&b alpha:&a];
      }else {
          const CGFloat *components = CGColorGetComponents(self.CGColor);
          r = components[0];
          g = components[1];
          b = components[2];
          a = components[3];//透明度
      }
      BOOL isLighter = NO;
      if (r *0.299 + g *0.578 + b *0.114 >= 0.75) {
          isLighter = YES;//浅色
      }
      return isLighter;
}

/*是否是浅色 YES 是浅色， NO是深色**/
+ (BOOL)isLighterColorWithColor:(UIColor *)color {
    return [color isLighterColor];
}
@end

