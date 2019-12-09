//
//  NSObject+HSelector.m
//  MGMobileMusic
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "NSObject+HSelector.h"

@implementation NSObject (HSelector)

- (BOOL)respondsToSelector:(SEL)aSelector withPre:(NSString *)pre {
    NSString *selectorString = [NSString stringWithFormat:@"%@%@",pre,NSStringFromSelector(aSelector)];
    SEL selector = NSSelectorFromString(selectorString);
    return [self respondsToSelector:selector];
}

#pragma --mark 执行实例方法

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    return [[self class] performSelector:aSelector withSignature:signature withObjects:objects withMethodArgments:nil];
}

- (id)performSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ... {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    return [[self class] performSelector:aSelector withSignature:signature withObjects:nil withMethodArgments:firstParameter];
}

- (id)performSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ... {
    NSString *selectorString = [NSString stringWithFormat:@"%@%@",pre,NSStringFromSelector(aSelector)];
    SEL selector = NSSelectorFromString(selectorString);
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    return [[self class] performSelector:aSelector withSignature:signature withObjects:nil withMethodArgments:firstParameter];
}

#pragma --mark 执行类方法

+ (id)performClassSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [[self class] methodSignatureForSelector:aSelector];
    return [self performSelector:aSelector withSignature:signature withObjects:objects withMethodArgments:nil];
}

- (id)performClassSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    return [[self class] performClassSelector:aSelector withObjects:objects];
}




+ (id)performClassSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ... {
    NSMethodSignature *signature = [[self class] methodSignatureForSelector:aSelector];
    return [self performSelector:aSelector withSignature:signature withObjects:nil withMethodArgments:firstParameter];
}

- (id)performClassSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ... {
    return [[self class] performClassSelector:aSelector withMethodArgments:firstParameter];
}



+ (id)performClassSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ... {
    NSString *selectorString = [NSString stringWithFormat:@"%@%@",pre,NSStringFromSelector(aSelector)];
    SEL selector = NSSelectorFromString(selectorString);
    return [self performClassSelector:selector withMethodArgments:firstParameter];
}

- (id)performClassSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ... {
    return [self performSelector:aSelector withPre:pre withMethodArgments:firstParameter];
}



+ (id)performSelector:(SEL)aSelector withSignature:(NSMethodSignature *)signature withObjects:(NSArray *)objects withMethodArgments:(void *)firstParameter, ... {
    
    //1、判断传入的方法是否存在
    if (signature==nil) {
        //传入的方法不存在 就抛异常
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"此方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    //2、创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    //3、保存方法所属的对象
    invocation.target = self;
    invocation.selector = aSelector;
    
    //4、设置参数
    if (objects.count > 0) {
        NSInteger arguments =signature.numberOfArguments-2;
        NSUInteger objectsCount = objects.count;
        NSInteger count = MIN(arguments, objectsCount);
        for (int i = 0; i<count; i++) {
            NSObject*obj = objects[i];
            //处理参数是NULL类型的情况
            if ([obj isKindOfClass:[NSNull class]]) {
                obj = nil;
            }
            [invocation setArgument:&obj atIndex:i+2];
        }
    }else {
        if (signature.numberOfArguments > 2) {
            [invocation setArgument:firstParameter atIndex:2];
            va_list arg_ptr;
            va_start(arg_ptr, firstParameter);
            for (NSUInteger i = 3; i < signature.numberOfArguments; i++) {
                void * parameter = va_arg(arg_ptr, void *);
                [invocation setArgument:parameter atIndex:i];
            }
            va_end(arg_ptr);
        }
    }
    
    //5、调用NSinvocation对象
    [invocation invoke];
    
    //6、获取返回值

    //获得返回值类型
    const char *returnType = signature.methodReturnType;
    //声明返回值变量
    id returnValue;
    //如果没有返回值，也就是消息声明为void，那么returnValue=nil
    if(!strcmp(returnType, @encode(void)) ){
        returnValue =  nil;
    }
    //如果返回值为对象，那么为变量赋值
    else if(!strcmp(returnType, @encode(id)) ){
        [invocation getReturnValue:&returnValue];
    }
    else {
        //如果返回值为普通类型NSInteger/BOOL等
        
        //返回值长度
        NSUInteger length = [signature methodReturnLength];
        //根据长度申请内存
        void *buffer = (void *)malloc(length);
        //为变量赋值
        [invocation getReturnValue:buffer];
        
        if(!strcmp(returnType, @encode(BOOL)) ) {
            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
        }
        else if(!strcmp(returnType, @encode(float)) ){
            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
        }
        else if(!strcmp(returnType, @encode(double)) ){
            returnValue = [NSNumber numberWithDouble:*((double*)buffer)];
        }
        else if(!strcmp(returnType, @encode(NSInteger)) ){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(NSUInteger)) ){
            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(int))) {
            returnValue = [NSNumber numberWithInt:*((int*)buffer)];
        }
        else if(!strcmp(returnType, @encode(char))) {
            returnValue = [NSNumber numberWithChar:*((char*)buffer)];
        }
        else {
            returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
        }
    }
    return returnValue;
}

@end
