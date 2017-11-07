//
//  UIScreen+QFUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import "UIScreen+QFUtil.h"

@implementation UIScreen (QFUtil)

+ (CGSize)size {
    return [UIScreen mainScreen].bounds.size;
}

+ (CGFloat)height {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)width {
    return [UIScreen mainScreen].bounds.size.width;
}

@end
