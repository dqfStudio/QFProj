//
//  HTransitionHeader.h
//  QFProj
//
//  Created by dqf on 2019/12/13.
//  Copyright © 2019 admin. All rights reserved.
//

#ifndef HTransitionHeader_h
#define HTransitionHeader_h

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
typedef NS_ENUM(NSInteger, HTransitionType) {
    HTransitionTypePush,    //push
    HTransitionTypePop,     //push
    HTransitionTypePresent, //present
    HTransitionTypeDismiss  //dismiss
};

/*
 * push动画类型
 */
typedef NS_ENUM(NSInteger, HPushAnimationType) {
    HPushAnimationTypeOCDoor //开关门动画
};

/*
 * 弹出动画结束后回调
 */
typedef void (^HTransitionCompletion) (HTransitionType transitionType);

#endif /* HTransitionHeader_h */
