//
//  NSObject+HForwarding.m
//  QFProj
//
//  Created by dqf on 2019/3/20.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "NSObject+HForwarding.h"

//NSString *string = @"v@:";
//NSString *string = @"@@:";
//string = [string stringByAppendingString:@"@"];

@implementation NSObject (HForwarding)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    NSString *selectorString = NSStringFromSelector(aSelector);
//    if ([self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass(self.class) hasPrefix:@"UIKeyboard"] || [selectorString isEqualToString:@"dealloc"]) {
//        return nil;
//    }
//    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
//    NSString *string = @":@:";
//    for (int i=0; i<count; i++) {
//        string = [string stringByAppendingString:@":"];
//    }
//    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
//}
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    NSString *selectorString = NSStringFromSelector(aSelector);
//    if ([self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass(self.class) hasPrefix:@"UIKeyboard"] || [selectorString isEqualToString:@"dealloc"]) {
//        return nil;
//    }
//    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
//    NSString *string = @":@:";
//    for (int i=0; i<count; i++) {
//        string = [string stringByAppendingString:@":"];
//    }
//    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
//}
//+ (void)forwardInvocation:(NSInvocation *)anInvocation {}
//- (void)forwardInvocation:(NSInvocation *)anInvocation {}
#pragma clang diagnostic pop
@end
