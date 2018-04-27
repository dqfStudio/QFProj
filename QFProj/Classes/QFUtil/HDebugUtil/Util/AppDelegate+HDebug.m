//
//  AppDelegate+HDebug.m
//  MGMobileMusic
//
//  Created by dqf on 2017/7/20.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "AppDelegate+HDebug.h"
#import "HDebugUtil.h"

@implementation AppDelegate (HDebug)

#if DEBUG
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [[HDebugUtil share] showDebugView];
    }
}
#endif

@end
