//
//  NSObject+HAspects.h
//  QFProj
//
//  Created by dqf on 2018/5/8.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Aspects/Aspects.h>

@interface NSObject (HAspects)

/**
 示例：
 [ViewController aspectInstead:@selector(viewWillAppear:) usingBlock:^(id<AspectInfo> info, BOOL animated) {
 NSLog(@"");
 }];
 */
+ (id<AspectToken>)aspectAfter:(SEL)aSelector usingBlock:(id)block;
- (id<AspectToken>)aspectAfter:(SEL)aSelector usingBlock:(id)block;

+ (id<AspectToken>)aspectInstead:(SEL)aSelector usingBlock:(id)block;
- (id<AspectToken>)aspectInstead:(SEL)aSelector usingBlock:(id)block;

+ (id<AspectToken>)aspectBefore:(SEL)aSelector usingBlock:(id)block;
- (id<AspectToken>)aspectBefore:(SEL)aSelector usingBlock:(id)block;

@end
