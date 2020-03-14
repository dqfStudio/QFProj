//
//  CADisplayLink+HUtil.h
//  QFProj
//
//  Created by dqf on 2020/3/14.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSObject+HBlockSEL.h"

@interface CADisplayLink (HUtil)

+ (CADisplayLink *)displayLinkWithTarget:(id)target block:(void(^)(CADisplayLink *displayLink))block;

@end
