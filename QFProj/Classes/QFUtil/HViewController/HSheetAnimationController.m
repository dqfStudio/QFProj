//
//  HSheetAnimationController.m
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HSheetAnimationController.h"

@interface HSheetAnimationController ()
@property (nonatomic) UIVisualEffectView *visualView;
@end

@implementation HSheetAnimationController

- (UIVisualEffectView *)visualView {
    if (!_visualView) {
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _visualView;
}

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size.height = 190;
        if (UIScreen.isIPhoneX) {
            frame.size.height += UIScreen.bottomBarHeight;
        }
        _tupleView = [[HTupleView alloc] initWithFrame:frame];
        _tupleView.backgroundColor = UIColor.clearColor;
        _tupleView.layer.cornerRadius = 3.f;//默认为3.f
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
    if (!self.hideVisualView) {
        for (UIView *subview in self.visualView.subviews) {
            subview.layer.cornerRadius = self.tupleView.layer.cornerRadius;
        }
    }
}

- (void)back {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)animationAlert:(UIView *)view {
    view.alpha = 0.0f;
    view.frame = CGRectMake(0, UIScreen.height, self.tupleView.width, self.tupleView.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.alpha = 1.0f;
        view.frame = CGRectMake(0, UIScreen.height-self.tupleView.height, self.tupleView.width, self.tupleView.height);
    } completion:nil];
}

@end

