//
//  UIView+HUserInterfaceStyle.m
//  QFProj
//
//  Created by wind on 2020/3/10.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "UIView+HUserInterfaceStyle.h"
#import "NSObject+HSwizzleUtil.h"

@implementation UIView (HUserInterfaceStyle)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodSwizzleWithOrigSEL:@selector(willMoveToSuperview:) overrideSEL:@selector(pvc_willMoveToSuperview:)];
    });
}
- (void)pvc_willMoveToSuperview:(nullable UIView *)newSuperview {
    //关闭暗黑模式
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
    [self pvc_willMoveToSuperview:newSuperview];
}
@end
