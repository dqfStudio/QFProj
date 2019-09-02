//
//  NSObject+HBlockSEL.m
//  TestProject
//
//  Created by dqf on 2018/4/12.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "NSObject+HBlockSEL.h"
#import <objc/runtime.h>

@implementation NSObject (HBlockSEL)
- (SEL)selectorBlock:(void (^)(id, id))block {
    if (!block) {
        [NSException raise:@"block can not be nil" format:@"%@ selectorBlock error", self];
    }
    NSString *selName = [NSString stringWithFormat:@"selector_%p:", block];
    SEL sel = NSSelectorFromString(selName);
    class_addMethod([self class], sel, (IMP)selectorImp, "v@:@");
    objc_setAssociatedObject(self, sel, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return sel;
}
static void selectorImp(id self, SEL _cmd, id arg) {
    HBCallback block = objc_getAssociatedObject(self, _cmd);
    __weak typeof(self) weakSelf = self;
    if (block) {
        block(weakSelf, arg);
    }
}
@end
