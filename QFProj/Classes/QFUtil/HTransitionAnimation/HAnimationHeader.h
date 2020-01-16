//
//  HAnimationHeader.h
//  KYProjectModel
//
//  Created by TX-Kevin on 2019/12/13.
//  Copyright © 2019 admin. All rights reserved.
//

#ifndef HAnimationHeader_h
#define HAnimationHeader_h

#define HAnimationWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

/*
 * 弹出框的类型
 */
typedef NS_ENUM(NSUInteger, HTransitionStyle) {
    HTransitionStyleAlert, //中间弹出
    HTransitionStyleSheet  //底部弹出
};

/*
 * 转场动画类型（push、pop、present、dismiss)
 */
typedef NS_ENUM(NSInteger, HTransitionAnimationType) {
    HTransitionAnimationTypePush,    //push
    HTransitionAnimationTypePop,     //push
    HTransitionAnimationTypePresent, //present
    HTransitionAnimationTypeDismiss  //dismiss
};

/*
 * 弹框动画完成类型
 */
typedef NS_ENUM(NSInteger, HFinishedAnimationType) {
    HFinishedAnimationTypeNone,    //
    HFinishedAnimationTypeShow,    //显示
    HFinishedAnimationTypeDismiss  //消失
};

/*
 * 弹出动画结束后回调
 */
typedef void (^HAnimationCompletion) (HTransitionAnimationType transitionType, BOOL finished);

#endif /* HAnimationHeader_h */
