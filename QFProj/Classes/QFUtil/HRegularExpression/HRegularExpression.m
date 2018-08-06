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
        [self test:nil test2:nil ];
        //查找命令
        //test:(.*) test2:(.*)\]
        //替换命令
        //test:$1    test2:$2 completion:nil]
    }
    return self;
}

-  (void)test:(NSString *)test test2:(NSString *)test2 {
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
}

-  (void)test:(NSString *)test test22:(NSString *)test2 test3:(NSString *)test3  {
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
    NSLog(@"ff");
}

- (void)fsf {
    //搜索NSLog方法
    //(.+?)NSLog(.+?)([\n\r])
    
    //搜索@""形式的字符串，例如@"fsf"
    //@"[^"]*[\u4E00-\u9FA5]+[^"\n]*?"
    
    //两个{}之间的内容，包括换行符
    //\{[\s\S]*?\n\}
}

@end
