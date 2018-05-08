//
//  HAspectsUtil.m
//  QFProj
//
//  Created by dqf on 2018/5/8.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAspectsUtil.h"

/**
 示例：
 aspectAfter(cls, aSelector, ^(id<AspectInfo> info, NSString *obj) {});
 
 [TestViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info, BOOL animated) {
 NSLog(@"View Controller %@ will appear animated: %tu", info.instance, animated);
 NSLog(@"%@ %@ %@ %tu", info.instance, info.arguments, info.originalInvocation, animated);
 } error:NULL];
 */
void aspectAfter(id cls, SEL aSelector ,id block) {
    [cls aspect_hookSelector:aSelector
                 withOptions:AspectPositionAfter
                  usingBlock:block
                       error:NULL];
}

void aspectInstead(id cls, SEL aSelector ,id block) {
    [cls aspect_hookSelector:aSelector
                 withOptions:AspectPositionInstead
                  usingBlock:block
                       error:NULL];
}

void aspectBefore(id cls, SEL aSelector ,id block) {
    [cls aspect_hookSelector:aSelector
                 withOptions:AspectPositionBefore
                  usingBlock:block
                       error:NULL];
}
