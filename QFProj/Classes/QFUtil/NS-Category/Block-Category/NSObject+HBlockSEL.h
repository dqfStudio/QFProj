//
//  NSObject+HBlockSEL.h
//  HProj
//
//  Created by dqf on 2018/4/12.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @param weakSelf 方便使用，用来打破循环引用。使用时需要改成实际类型，否则没有代码提示.
 @param arg 事件默认传递的对象，比如`NSNotification`，`UIButton`。
 */
typedef void (^HBCallback)(id weakSelf, id arg);

@interface NSObject (HBlockSEL)

/**
 用block来代替selector
 */
- (SEL)selectorBlock:(HBCallback)block;

@end
