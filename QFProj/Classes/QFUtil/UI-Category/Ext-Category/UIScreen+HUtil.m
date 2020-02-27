//
//  UIScreen+HUtil.m
//  MeTa
//
//  Created by dqf on 2017/8/29.
//  Copyright © 2017年 dqf. All rights reserved.
//

#import "UIScreen+HUtil.h"

@implementation UIScreen (HUtil)
+ (CGRect)bounds {
    return [UIScreen mainScreen].bounds;
}
+ (CGSize)size {
    return [UIScreen mainScreen].bounds.size;
}
+ (CGFloat)height {
    return [UIScreen mainScreen].bounds.size.height;
}
+ (CGFloat)width {
    return [UIScreen mainScreen].bounds.size.width;
}
+ (CGFloat)onePixel {
    UIScreen *mainScreen = [UIScreen mainScreen];
    if ([mainScreen respondsToSelector:@selector(nativeScale)]) {
        return 1.0f / mainScreen.nativeScale;
    }else {
        return 1.0f / mainScreen.scale;
    }
}
+ (BOOL)isIPhoneX {
    static dispatch_once_t onceToken;
    static BOOL iPhoneXSeries = NO;
    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            if (@available(iOS 11.0, *)) {
                UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                if (mainWindow.safeAreaInsets.bottom > 0.0) {
                    iPhoneXSeries = YES;
                }
            }
        }
    });
    return iPhoneXSeries;
}
+ (CGFloat)statusBarHeight {
    CGFloat height = 0.f;
    if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        height = UIScreen.isIPhoneX ? 44.0 : 20.0f;
    }
    return height;
}
+ (CGFloat)naviBarHeight {
    return 44.f;
}
+ (CGFloat)topBarHeight {
    return self.statusBarHeight+self.naviBarHeight;
}
+ (CGFloat)bottomBarHeight {
    return UIScreen.isIPhoneX ? 34.f : 0.f;
}
@end
