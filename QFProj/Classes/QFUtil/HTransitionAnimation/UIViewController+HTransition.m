//
//  UIViewController+HTransition.m
//  QFProj
//
//  Created by dqf on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "UIViewController+HTransition.h"

@implementation UIViewController (HTransition)
- (CGSize)containerSize {
    return CGSizeZero;
}
- (CGFloat)animationDuration {
    return 0.25;
}
- (UIColor *)shadowColor {
    return nil;
}
- (BOOL)isShadowDismiss {
    return NO;
}
- (BOOL)hideVisualView {
    return NO;
}
- (HTransitionStyle)presetType {
    return HTransitionStyleAlert;
}
- (HPushAnimationType)animationType {
    return HPushAnimationTypeOCDoor;
}
@end
