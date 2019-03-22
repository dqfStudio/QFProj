//
//  NSObject+HForwarding.m
//  QFProj
//
//  Created by wind on 2019/3/20.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "NSObject+HForwarding.h"

//NSString *string = @"v@:";
//NSString *string = @"@@:";
//string = [string stringByAppendingString:@"@"];

#define KMethodSignature \
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {\
NSString *selectorString = NSStringFromSelector(aSelector);\
if ([self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass(self.class)\ hasPrefix:@"UIKeyboard"] || [selectorString isEqualToString:@"dealloc"]) {\
    return nil;\
}\
NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;\
NSString *string = @":@:";\
for (int i=0; i<count; i++) {\
    string = [string stringByAppendingString:@":"];\
}\
return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];\
}\
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {\
    NSString *selectorString = NSStringFromSelector(aSelector);\
    if ([self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass(self.class)\ hasPrefix:@"UIKeyboard"] || [selectorString isEqualToString:@"dealloc"]) {\
        return nil;\
    }\
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;\
    NSString *string = @":@:";\
    for (int i=0; i<count; i++) {\
        string = [string stringByAppendingString:@":"];\
    }\
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];\
}\
+ (void)forwardInvocation:(NSInvocation *)anInvocation {}\
- (void)forwardInvocation:(NSInvocation *)anInvocation {}


@implementation NSObject (HForwarding)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    if ([self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass(self.class) hasPrefix:@"UIKeyboard"] || [selectorString isEqualToString:@"dealloc"]) {
        return nil;
    }
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    if ([self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass(self.class) hasPrefix:@"UIKeyboard"] || [selectorString isEqualToString:@"dealloc"]) {
        return nil;
    }
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
+ (void)forwardInvocation:(NSInvocation *)anInvocation {}
- (void)forwardInvocation:(NSInvocation *)anInvocation {}
#pragma clang diagnostic pop
@end

//@implementation NSString (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSValue (HForwarding)
//KMethodSignature
//@end
//
//@implementation UIResponder (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSSet (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSArray (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSDictionary (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSTimer (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSNull (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSError (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSData (HForwarding)
//KMethodSignature
//@end
//
//@implementation NSDate (HForwarding)
//KMethodSignature
//@end
//
//@implementation UIFont (HForwarding)
//KMethodSignature
//@end
//
//@implementation UIImage (HForwarding)
//KMethodSignature
//@end
//
//@implementation UIScreen (HForwarding)
//KMethodSignature
//@end
//
//@implementation UIDevice (HForwarding)
//KMethodSignature
//@end
//
//@implementation UIColor (HForwarding)
//KMethodSignature
//@end
