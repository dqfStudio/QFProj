//
//  HAlertFormatter.m
//  QFProj
//
//  Created by Wind on 2021/6/2.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HAlertFormatter.h"

@implementation HWaitingTransition
- (instancetype)init {
    self = [super init];
    if (self) {
        _style = 2;
    }
    return self;
}
@end

@implementation HResultTransition
- (instancetype)init {
    self = [super init];
    if (self) {
        _style = 0;
    }
    return self;
}
@end

@implementation HToastTransition
- (instancetype)init {
    self = [super init];
    if (self) {
        _delay = 2.f;
        _inView = [[UIApplication sharedApplication] keyWindow];
    }
    return self;
}
@end
