//
//  HVCDisappear.h
//  HProjectModel1
//
//  Created by wind on 2019/7/17.
//  Copyright © 2019 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HSwizzleUtil.h"

typedef NS_OPTIONS(NSUInteger, HVCDisappearType) {
    HVCDisappearTypeOther = 0,
    HVCDisappearTypePush,
    HVCDisappearTypePop,
    HVCDisappearTypeDismiss
};

@interface UIViewController (HDisappear)
/**
 *  vc消失的类型,需自己重写
 *
 *  type 类型枚举
 */
- (void)vcWillDisappear:(HVCDisappearType)type;
@end


@interface UINavigationController (HDisappear)

@end
