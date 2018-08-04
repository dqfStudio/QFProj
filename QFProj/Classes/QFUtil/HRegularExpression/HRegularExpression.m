//
//  HRegularExpression.m
//  QFProj
//
//  Created by dqf on 2018/8/4.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HRegularExpression.h"

@implementation HRegularExpression

- (instancetype)init {
    self = [super init];
    if (self) {
        [self test:nil test2:nil];
        //查找命令
        //test:(.*) test2:(.*)\]
        //替换命令
        //test:$1 test2:$2 completion:nil]
    }
    return self;
}

- (void)test:(NSString *)test test2:(NSString *)test2 {
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
}

@end
