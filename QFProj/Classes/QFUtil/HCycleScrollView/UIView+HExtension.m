//
//  UIView+HExtension.m
//  HRefreshView
//
//  Created by aier on 15-2-23.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "UIView+HExtension.h"

@implementation UIView (HExtension)

- (CGFloat)hc_height {
    return self.frame.size.height;
}

- (void)setHc_height:(CGFloat)sd_height {
    CGRect temp = self.frame;
    temp.size.height = sd_height;
    self.frame = temp;
}

- (CGFloat)hc_width {
    return self.frame.size.width;
}

- (void)setHc_width:(CGFloat)sd_width {
    CGRect temp = self.frame;
    temp.size.width = sd_width;
    self.frame = temp;
}


- (CGFloat)hc_y {
    return self.frame.origin.y;
}

- (void)setHc_y:(CGFloat)sd_y {
    CGRect temp = self.frame;
    temp.origin.y = sd_y;
    self.frame = temp;
}

- (CGFloat)hc_x {
    return self.frame.origin.x;
}

- (void)setHc_x:(CGFloat)sd_x {
    CGRect temp = self.frame;
    temp.origin.x = sd_x;
    self.frame = temp;
}

@end
