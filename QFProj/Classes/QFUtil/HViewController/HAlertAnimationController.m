//
//  HAlertAnimationController.m
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HAlertAnimationController.h"

@interface HAlertAnimationController ()
@property (nonatomic) UIVisualEffectView *visualView;
@end

@implementation HAlertAnimationController

- (UIVisualEffectView *)visualView {
    if (!_visualView) {
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _visualView;
}

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = CGRectMake(0, 0, 270, 121);//默认系统弹框大小
        _tupleView = [[HTupleView alloc] initWithFrame:frame];
        _tupleView.backgroundColor = UIColor.clearColor;
        _tupleView.layer.cornerRadius = 10.f;//默认系统弹框圆角为10.f
        [_tupleView setScrollEnabled:NO];
    }
    return _tupleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    [self.topBar setHidden:YES];
    if (self.hideVisualView) {
        self.tupleView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:self.tupleView];
    }else {
        [self.visualView.contentView addSubview:self.tupleView];
        [self.view addSubview:self.visualView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.hideVisualView) {
        [self animationAlert:self.tupleView];
    }else {
        [self animationAlert:self.visualView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.hideVisualView) {
        self.tupleView.center = self.view.center;
    }else {
        if (!CGRectEqualToRect(self.tupleView.frame, self.visualView.bounds)) {
            //设置visualView属性
            self.visualView.frame = self.tupleView.frame;
            for (UIView *subview in self.visualView.subviews) {
                subview.layer.cornerRadius = self.tupleView.layer.cornerRadius;
            }
            self.visualView.center = self.view.center;
        }
    }
}

- (void)back {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)animationAlert:(UIView *)view {
    view.alpha = 0.0f;
    view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:50 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha = 1.0f;
        view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end

