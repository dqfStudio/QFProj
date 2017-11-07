//
//  UIScreen+QFUtil.h
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>

//适配
#define KDWIDTH     320.f
#define KDHEIGHT    568.f

#define KWRatio     [UIScreen width]/KDWIDTH
#define KHRatio     [UIScreen height]/KDHEIGHT

@interface UIScreen (QFUtil)

+ (CGSize)size;
+ (CGFloat)height;
+ (CGFloat)width;

@end
