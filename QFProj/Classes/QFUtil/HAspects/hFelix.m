//
//  HFelix.m
//  HProj
//
//  Created by dqf on 2018/5/4.
//  Copyright © 2018年 socool. All rights reserved.
//

#import "HFelix.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

@implementation HFelix

+ (JSContext *)context {
    static JSContext *_context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _context = [[JSContext alloc] init];
        [_context setExceptionHandler:^(JSContext *context, JSValue *value) {
            NSLog(@"Oops: %@", value);
        }];
        [self fixIt:_context];
    });
    return _context;
}

+ (void)evalString:(NSString *)javascriptString {
    [[self context] evaluateScript:javascriptString];
}

+ (void)fixIt:(JSContext *)context {

    context[@"fixInstanceMethodBefore"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self fixWithMethod:NO aspectionOptions:AspectPositionBefore instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };

    context[@"fixInstanceMethodReplace"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self fixWithMethod:NO aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };

    context[@"fixInstanceMethodAfter"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self fixWithMethod:NO aspectionOptions:AspectPositionAfter instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };

    context[@"fixClassMethodBefore"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self fixWithMethod:YES aspectionOptions:AspectPositionBefore instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };

    context[@"fixClassMethodReplace"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self fixWithMethod:YES aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };

    context[@"fixClassMethodAfter"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self fixWithMethod:YES aspectionOptions:AspectPositionAfter instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };

    context[@"runClassWithNoParamter"] = ^id(NSString *className, NSString *selectorName) {
        return [self runClassWithClassName:className selector:selectorName obj1:nil obj2:nil];
    };

    context[@"runClassWith1Paramter"] = ^id(NSString *className, NSString *selectorName, id obj1) {
        return [self runClassWithClassName:className selector:selectorName obj1:obj1 obj2:nil];
    };

    context[@"runClassWith2Paramters"] = ^id(NSString *className, NSString *selectorName, id obj1, id obj2) {
        return [self runClassWithClassName:className selector:selectorName obj1:obj1 obj2:obj2];
    };

    context[@"runVoidClassWithNoParamter"] = ^(NSString *className, NSString *selectorName) {
        [self runClassWithClassName:className selector:selectorName obj1:nil obj2:nil];
    };

    context[@"runVoidClassWith1Paramter"] = ^(NSString *className, NSString *selectorName, id obj1) {
        [self runClassWithClassName:className selector:selectorName obj1:obj1 obj2:nil];
    };

    context[@"runVoidClassWith2Paramters"] = ^(NSString *className, NSString *selectorName, id obj1, id obj2) {
        [self runClassWithClassName:className selector:selectorName obj1:obj1 obj2:obj2];
    };

    context[@"runInstanceWithNoParamter"] = ^id(id instance, NSString *selectorName) {
        return [self runInstanceWithInstance:instance selector:selectorName obj1:nil obj2:nil];
    };

    context[@"runInstanceWith1Paramter"] = ^id(id instance, NSString *selectorName, id obj1) {
        return [self runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:nil];
    };

    context[@"runInstanceWith2Paramters"] = ^id(id instance, NSString *selectorName, id obj1, id obj2) {
        return [self runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:obj2];
    };

    context[@"runVoidInstanceWithNoParamter"] = ^(id instance, NSString *selectorName) {
        [self runInstanceWithInstance:instance selector:selectorName obj1:nil obj2:nil];
    };

    context[@"runVoidInstanceWith1Paramter"] = ^(id instance, NSString *selectorName, id obj1) {
        [self runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:nil];
    };

    context[@"runVoidInstanceWith2Paramters"] = ^(id instance, NSString *selectorName, id obj1, id obj2) {
        [self runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:obj2];
    };

    context[@"runInvocation"] = ^(NSInvocation *invocation) {
        [invocation invoke];
    };

    // helper
    [context evaluateScript:@"var console = {}"];
    context[@"console"][@"log"] = ^(id message) {
        NSLog(@"Javascript log: %@",message);
    };
}

+ (void)fixWithMethod:(BOOL)isClassMethod aspectionOptions:(AspectOptions)option instanceName:(NSString *)instanceName selectorName:(NSString *)selectorName fixImpl:(JSValue *)fixImpl {
    Class klass = NSClassFromString(instanceName);
    if (isClassMethod) {
        klass = object_getClass(klass);
    }
    SEL sel = NSSelectorFromString(selectorName);
    [klass aspect_hookSelector:sel withOptions:option usingBlock:^(id<AspectInfo> info){
        [fixImpl callWithArguments:@[info.instance, info.originalInvocation, info.arguments]];
    } error:nil];
}

+ (id)runClassWithClassName:(NSString *)className selector:(NSString *)selector obj1:(id)obj1 obj2:(id)obj2 {
    Class klass = NSClassFromString(className);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [klass performSelector:NSSelectorFromString(selector) withObject:obj1 withObject:obj2];
#pragma clang diagnostic pop
}

+ (id)runInstanceWithInstance:(id)instance selector:(NSString *)selector obj1:(id)obj1 obj2:(id)obj2 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [instance performSelector:NSSelectorFromString(selector) withObject:obj1 withObject:obj2];
#pragma clang diagnostic pop
}

@end
