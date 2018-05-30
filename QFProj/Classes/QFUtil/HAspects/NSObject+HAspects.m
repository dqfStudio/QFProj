//
//  NSObject+HAspects.m
//  QFProj
//
//  Created by dqf on 2018/5/8.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSObject+HAspects.h"
#import "HAspectsCenter.h"

@implementation NSObject (HAspects)

/**
 示例：
 [ViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info, BOOL animated) {
 NSLog(@"View Controller %@ will appear animated: %tu", info.instance, animated);
 NSLog(@"%@ %@ %@ %tu", info.instance, info.arguments, info.originalInvocation, animated);
 } error:NULL];
 */

+ (id<AspectToken>)aspectAfter:(SEL)aSelector usingBlock:(id)block {
    id<AspectToken> aspectToken = [self aspect_hookSelector:aSelector withOptions:AspectPositionAfter usingBlock:block error:NULL];
    [[HAspectsCenter defaultCenter] setAspects:aspectToken forClass:[self class]];
    return aspectToken;
}
- (id<AspectToken>)aspectAfter:(SEL)aSelector usingBlock:(id)block {
    return [self aspect_hookSelector:aSelector withOptions:AspectPositionAfter usingBlock:block error:NULL];
}

+ (id<AspectToken>)aspectInstead:(SEL)aSelector usingBlock:(id)block {
    id<AspectToken> aspectToken = [self aspect_hookSelector:aSelector withOptions:AspectPositionInstead usingBlock:block error:NULL];
    [[HAspectsCenter defaultCenter] setAspects:aspectToken forClass:[self class]];
    return aspectToken;
}
- (id<AspectToken>)aspectInstead:(SEL)aSelector usingBlock:(id)block {
    return [self aspect_hookSelector:aSelector withOptions:AspectPositionInstead usingBlock:block error:NULL];
}

+ (id<AspectToken>)aspectBefore:(SEL)aSelector usingBlock:(id)block {
    id<AspectToken> aspectToken = [self aspect_hookSelector:aSelector withOptions:AspectPositionBefore usingBlock:block error:NULL];
    [[HAspectsCenter defaultCenter] setAspects:aspectToken forClass:[self class]];
    return aspectToken;
}
- (id<AspectToken>)aspectBefore:(SEL)aSelector usingBlock:(id)block {
    return [self aspect_hookSelector:aSelector withOptions:AspectPositionBefore usingBlock:block error:NULL];
}

@end
