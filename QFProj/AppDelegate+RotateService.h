//
//  AppDelegate+RotateService.h
//  QFProj
//
//  Created by dqf on 2020/2/27.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, UIDeviceOrientationStyle) {
    UIDeviceOrientationStyleAll, // 横竖屏
    UIDeviceOrientationStyleVertical, //竖屏
    UIDeviceOrientationStyleHorizontal, //横屏
    UIDeviceOrientationStyleHorizontalLeft, //横屏左旋转
    UIDeviceOrientationStyleHorizontalRight //横屏右旋转
};

@interface AppDelegate (RotateService)
@property (nonatomic, class) UIDeviceOrientationStyle orientationStyle; //旋转方向
@end
