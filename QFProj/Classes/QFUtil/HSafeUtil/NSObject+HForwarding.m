//
//  NSObject+HForwarding.m
//  QFProj
//
//  Created by wind on 2019/3/20.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "NSObject+HForwarding.h"

@implementation NSString (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {

}
@end

@implementation NSValue (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIResponder (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSSet (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSArray (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSDictionary (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSTimer (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSNull (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSError (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSData (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSDate (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIFont (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIImage (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIScreen (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIDevice (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIColor (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end
