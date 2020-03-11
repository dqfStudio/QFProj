//
//  HAnimationController.m
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HAnimationController.h"

@interface HAnimationController ()
@property (nonatomic) UIVisualEffectView *visualView;
@end

@implementation HAnimationController

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
        _tupleView.layer.cornerRadius = 10.f;//默认系统弹框圆角为10.f
        [_tupleView setScrollEnabled:NO];
        [self.visualView.contentView addSubview:self.tupleView];
    }
    return _tupleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    [self.topBar setHidden:YES];
    [self.view addSubview:self.visualView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self animationAlert:self.visualView];//执行动画
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(self.tupleView.frame, self.visualView.bounds)) {
        //设置visualView属性
        self.visualView.frame = self.tupleView.frame;
        for (UIView *subview in self.visualView.subviews) {
            subview.layer.cornerRadius = self.tupleView.layer.cornerRadius;
        }
        self.visualView.center = self.view.center;
    }
}

- (void)back {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)animationAlert:(UIView *)view {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.3;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15f, 1.15f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

@end

