//
//  HAspectsUtil.h
//  QFProj
//
//  Created by dqf on 2018/5/8.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Aspects/Aspects.h>

typedef void (^aspect_callback)(id<AspectInfo> info);
typedef void (^aspect_callback1)(id<AspectInfo> info, id obj);
typedef void (^aspect_callback2)(id<AspectInfo> info, id obj1, id obj2);
typedef void (^aspect_callback3)(id<AspectInfo> info, id obj1, id obj2, id obj3);
typedef void (^aspect_callback4)(id<AspectInfo> info, id obj1, id obj2, id obj3, id obj4);

/**
 示例：aspectAfter(cls, aSelector, ^(id<AspectInfo> info, NSString *obj) {});
 */
void aspectAfter(id cls, SEL aSelector ,id block);
void aspectInstead(id cls, SEL aSelector ,id block);
void aspectBefore(id cls, SEL aSelector ,id block);
