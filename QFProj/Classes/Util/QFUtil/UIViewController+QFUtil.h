//
//  UIViewController+QFUtil.h
//  QFProj
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (QFUtil)

/**
 *  将UIViewController的类名作为NibName，使用initWithNibName方法，返回UIViewController对象
 */
+ (instancetype)viewControllerFromNib;

/**
 *  键盘通知
 */
- (void)addKeyboardObserver;
- (void)removeKeyboardObserver;

/**
 *  键盘通知回调事件，主要用于子类重写
 *
 *  @param keyboardRect 键盘rect
 *  @param duration     键盘弹出动画的时间
 */
- (void)keyboardWillShowWithRect:(CGRect)keyboardRect animationDuration:(CGFloat)duration;
- (void)keyboardWillHideWithRect:(CGRect)keyboardRect animationDuration:(CGFloat)duration;

/**
 *  点击背景self.view的时候，关闭键盘
 */
- (void)hideKeyboardWhenTapBackground;

/**
 *  判断当前ViewController是否在顶部显示
 */
- (BOOL)isViewInBackground;

@end
