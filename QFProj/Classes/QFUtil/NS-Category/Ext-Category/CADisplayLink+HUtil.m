//
//  CADisplayLink+HUtil.m
//  QFProj
//
//  Created by wind on 2020/3/14.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "CADisplayLink+HUtil.h"

@implementation CADisplayLink (HUtil)

+ (CADisplayLink *)displayLinkWithTarget:(id)target block:(void(^)(CADisplayLink *displayLink))block {
    SEL selector = [self selectorBlock:^(id weakSelf, id arg) {
        if (block) block(weakSelf);
    }];
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:target selector:selector];
    if (@available(iOS 10.0, *)) {
        displayLink.preferredFramesPerSecond = 1;
    }else {
        displayLink.frameInterval = 1;
    }
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    return displayLink;
}

@end
