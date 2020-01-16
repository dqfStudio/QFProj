//
//  HPresentationController.m
//  KYProjectModel
//
//  Created by TX-Kevin on 2019/12/13.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HPresentationController.h"

@implementation HPresentationController

#pragma mark - 重写UIPresentationController的方法
//重写构造方法
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom自定义
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

// 呈现过渡即将开始的时候被调用的
// 可以在此方法创建和设置自定义动画所需的view
- (void)presentationTransitionWillBegin {
    //将蒙版插入最下面
    [self.containerView insertSubview:self.contentCoverView atIndex:0];
    // 获取presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
   // 动画期间，背景View的动画方式
   self.contentCoverView.alpha = 0.f;
   @weakify(self);
   [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
       @strongify(self);
       self.contentCoverView.alpha = 1.0f;
   } completion:NULL];
}

// 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
- (void)presentationTransitionDidEnd:(BOOL)completed {
    //NSLog(@"过渡结束");
}

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin {
//    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
//     @weakify(self);
//    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        @strongify(self);
//        self.contentCoverView.alpha = 0.0f;
//    } completion:NULL];
    self.contentCoverView.alpha = 0.0f;
}

// 消失过渡完成之后调用，此时应该将视图移除
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.presentedView removeFromSuperview];
        //去掉蒙版
        [self.contentCoverView removeFromSuperview];
        self.contentCoverView = nil;
    }
}

//设置要显示的view的frame(布局）
- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
    self.contentCoverView.frame = self.containerView.bounds;
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGRect makeRect = CGRectZero;
    if(self.presentType == HTransitionStyleAlert) {
        makeRect = CGRectMake(self.containerView.center.x- self.contentSize.width*0.5, self.containerView.center.y-self.contentSize.height*0.5, self.contentSize.width, self.contentSize.height);
        
    }else if(self.presentType == HTransitionStyleSheet) {
        if(CGSizeEqualToSize(self.contentSize, CGSizeZero)){
            self.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds));
        }
        if(self.contentSize.width == 0 && self.contentSize.height) {
            self.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.bounds), self.contentSize.height);
        }
        makeRect = CGRectMake(self.containerView.bounds.size.width - self.contentSize.width, self.containerView.bounds.size.height - self.contentSize.height, self.contentSize.width, self.contentSize.height);
    }
    return makeRect;
}

- (BOOL)shouldPresentInFullscreen {
    return NO;
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}

#pragma mark - 蒙层
- (UIView *)contentCoverView {
    if(_contentCoverView == nil){
        _contentCoverView = [[UIView alloc]initWithFrame:self.containerView.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
       [_contentCoverView addGestureRecognizer:tap];
    }
    return _contentCoverView;
}

/*蒙层颜色*/
- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    if(_shadowColor == nil){
        _shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
    }
    _contentCoverView.backgroundColor = _shadowColor;
}

- (void)dismissAction {
    if (!self.isShadowDismiss) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
