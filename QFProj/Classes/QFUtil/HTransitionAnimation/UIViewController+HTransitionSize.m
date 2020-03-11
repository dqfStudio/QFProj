//
//  UIViewController+HTransitionSize.m
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "UIViewController+HTransitionSize.h"

@implementation UIViewController (HTransitionSize)
- (CGSize)containerSize {
    return CGSizeZero;
}
- (CGFloat)transitionDuration {
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
