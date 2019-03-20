//
//  NSObject+HForwarding.m
//  QFProj
//
//  Created by wind on 2019/3/20.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "NSObject+HForwarding.h"

@implementation NSObject (HForwarding)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
#pragma clang diagnostic pop
@end
