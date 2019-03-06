//
//  QFButton.m
//  QFProj
//
//  Created by dqf on 2018/5/8.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "QFButton.h"

@implementation QFButton

- (id)init {
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(testAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (void)testAction:(id)sender {
    NSLog(@"");
}

@end
