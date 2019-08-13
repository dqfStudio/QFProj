//
//  HNullSafe.m
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#ifndef HNullSafe_ENABLED
#define HNullSafe_ENABLED 1
#endif

#pragma clang diagnostic ignored "-Wgnu-conditional-omitted-operand"

@implementation NSNull (HSafeUtil)

#if HNullSafe_ENABLED

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    //look up method signature
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        for (Class someClass in @[
            [NSMutableArray class],
            [NSMutableDictionary class],
            [NSMutableString class],
            [NSNumber class],
            [NSDate class],
            [NSData class]
        ]) {
            @try {
                if ([someClass instancesRespondToSelector:selector]) {
                    signature = [someClass instanceMethodSignatureForSelector:selector];
                    break;
                }
            }
            @catch (__unused NSException *unused) {}
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    invocation.target = nil;
    [invocation invoke];
}

#endif

@end
