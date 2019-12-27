//
//  NSObject+HSelector.m
//  MGMobileMusic
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "NSObject+HSelector.h"

@implementation NSObject (HSelector)

#pragma --mark 执行实例方法

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    
    //1、创建签名对象
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    //2、判断传入的方法是否存在
    if (signature==nil) {
        //传入的方法不存在 就抛异常
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"此方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    //3、、创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    //4、保存方法所属的对象
    invocation.target = self;
    invocation.selector = aSelector;
    
    //5、设置参数
    /*
     当前如果直接遍历参数数组来设置参数
     如果参数数组元素多余参数个数，那么就会报错
     */
    NSInteger arguments =signature.numberOfArguments-2;
    
    /*
     如果直接遍历参数的个数，会存在问题
     如果参数的个数大于了参数值的个数，那么数组会越界
     */
    /*
     谁少就遍历谁
     */
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
    
    //6、调用NSinvocation对象
    [invocation invoke];
    
    //7、获取返回值

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
        else if(!strcmp(returnType, @encode(NSInteger)) ){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(NSUInteger)) ){
            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(float)) ){
            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
        }
        else if(!strcmp(returnType, @encode(double)) ){
            returnValue = [NSNumber numberWithFloat:*((double*)buffer)];
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

- (id)performSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ... {
    
    //1、创建签名对象
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    //2、判断传入的方法是否存在
    if (signature==nil) {
        //传入的方法不存在 就抛异常
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"此方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    //3、、创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    //4、保存方法所属的对象
    invocation.target = self;
    invocation.selector = aSelector;
    
    //5、设置参数
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
    
    //6、调用NSinvocation对象
    [invocation invoke];
    
    //7、获取返回值
    
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
        else if(!strcmp(returnType, @encode(NSInteger)) ){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(NSUInteger)) ){
            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(float)) ){
            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
        }
        else if(!strcmp(returnType, @encode(double)) ){
            returnValue = [NSNumber numberWithFloat:*((double*)buffer)];
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

- (BOOL)respondsToSelector:(SEL)aSelector withPre:(NSString *)pre {
    NSString *selectorString = [NSString stringWithFormat:@"%@%@",pre,NSStringFromSelector(aSelector)];
    SEL selector = NSSelectorFromString(selectorString);
    return [self respondsToSelector:selector];
}

- (id)performSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ... {
    NSString *selectorString = [NSString stringWithFormat:@"%@%@",pre,NSStringFromSelector(aSelector)];
    SEL selector = NSSelectorFromString(selectorString);
    //1、创建签名对象
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    
    //2、判断传入的方法是否存在
    if (signature==nil) {
        //传入的方法不存在 就抛异常
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(selector)];
        @throw [[NSException alloc] initWithName:@"此方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    //3、、创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    //4、保存方法所属的对象
    invocation.target = self;
    invocation.selector = selector;
    
    //5、设置参数
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
    
    //6、调用NSinvocation对象
    [invocation invoke];
    
    //7、获取返回值
    
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
        else if(!strcmp(returnType, @encode(NSInteger)) ){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(NSUInteger)) ){
            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(float)) ){
            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
        }
        else if(!strcmp(returnType, @encode(double)) ){
            returnValue = [NSNumber numberWithFloat:*((double*)buffer)];
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

#pragma --mark 执行类方法

+ (id)performClassSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    
    //1、创建签名对象
    NSMethodSignature *signature = [[self class] methodSignatureForSelector:aSelector];
    
    //2、判断传入的方法是否存在
    if (signature==nil) {
        //传入的方法不存在 就抛异常
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"此方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    //3、、创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    //4、保存方法所属的对象
    invocation.target = self;
    invocation.selector = aSelector;
    
    //5、设置参数
    /*
     当前如果直接遍历参数数组来设置参数
     如果参数数组元素多余参数个数，那么就会报错
     */
    NSInteger arguments =signature.numberOfArguments-2;
    
    /*
     如果直接遍历参数的个数，会存在问题
     如果参数的个数大于了参数值的个数，那么数组会越界
     */
    /*
     谁少就遍历谁
     */
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
    
    //6、调用NSinvocation对象
    [invocation invoke];
    
    //7、获取返回值

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
        else if(!strcmp(returnType, @encode(NSInteger)) ){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(NSUInteger)) ){
            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(float)) ){
            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
        }
        else if(!strcmp(returnType, @encode(double)) ){
            returnValue = [NSNumber numberWithFloat:*((double*)buffer)];
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

- (id)performClassSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    return [[self class] performClassSelector:aSelector withObjects:objects];
}




+ (id)performClassSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ... {
    
    //1、创建签名对象
    NSMethodSignature *signature = [[self class] methodSignatureForSelector:aSelector];
    
    //2、判断传入的方法是否存在
    if (signature==nil) {
        //传入的方法不存在 就抛异常
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"此方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    //3、、创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    //4、保存方法所属的对象
    invocation.target = self;
    invocation.selector = aSelector;
    
    //5、设置参数
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
    
    //6、调用NSinvocation对象
    [invocation invoke];
    
    //7、获取返回值

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
        else if(!strcmp(returnType, @encode(NSInteger)) ){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(NSUInteger)) ){
            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
        }
        else if(!strcmp(returnType, @encode(float)) ){
            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
        }
        else if(!strcmp(returnType, @encode(double)) ){
            returnValue = [NSNumber numberWithFloat:*((double*)buffer)];
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

- (id)performClassSelector:(SEL)aSelector withMethodArgments:(void *)firstParameter, ... {
    return [[self class] performClassSelector:aSelector withMethodArgments:firstParameter];
}





+ (id)performClassSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ... {
    NSString *selectorString = [NSString stringWithFormat:@"%@%@",pre,NSStringFromSelector(aSelector)];
    SEL selector = NSSelectorFromString(selectorString);
    return [self performSelector:selector withMethodArgments:firstParameter];
}

- (id)performClassSelector:(SEL)aSelector withPre:(NSString *)pre withMethodArgments:(void *)firstParameter, ... {
    return [self performSelector:aSelector withPre:pre withMethodArgments:firstParameter];
}


@end
