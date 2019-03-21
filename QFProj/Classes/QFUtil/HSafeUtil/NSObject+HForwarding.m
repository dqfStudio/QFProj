//
//  NSObject+HForwarding.m
//  QFProj
//
//  Created by wind on 2019/3/20.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "NSObject+HForwarding.h"

@implementation NSObject (HForwarding)
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    NSString *selectorString = NSStringFromSelector(aSelector);
//    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
//    //NSString *string = @"v@:";
//    //NSString *string = @"@@:";
//    NSString *string = @":@:";
//    for (int i=0; i<count; i++) {
//        string = [string stringByAppendingString:@":"];
//        //string = [string stringByAppendingString:@"@"];
//    }
//    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
//}
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//
//}
//#pragma clang diagnostic pop
@end

@implementation NSString (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSValue (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIResponder (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSSet (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSArray (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSDictionary (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSTimer (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSNull (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSError (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSData (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation NSDate (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIFont (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIImage (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIScreen (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIDevice (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end

@implementation UIColor (HForwarding)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
    //NSString *string = @"v@:";
    //NSString *string = @"@@:";
    NSString *string = @":@:";
    for (int i=0; i<count; i++) {
        string = [string stringByAppendingString:@":"];
        //string = [string stringByAppendingString:@"@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end
