//
//  HAlertController.m
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HAlertController.h"
#import "HTupleView.h"

@interface HAlertController () <HTupleViewDelegate>
@property (nonatomic) UIVisualEffectView *visualView;
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HAlertController

- (UIVisualEffectView *)visualView {
    if (!_visualView) {
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _visualView;
}

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:CGRectZero];
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
    [self.tupleView setTupleDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = CGRectMake(0, 0, 270, 121);
    if (!CGRectEqualToRect(frame, self.visualView.bounds)) {
        //设置visualView属性
        self.visualView.frame = frame;
        for (UIView *subview in self.visualView.subviews) {
            subview.layer.cornerRadius = 10;
        }
        self.visualView.center = [[UIApplication sharedApplication] getKeyWindow].center;
        //设置tupleView属性
        self.tupleView.frame = frame;
        self.tupleView.layer.cornerRadius = 10;
        //执行动画
        [self animationAlert:self.visualView];
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

- (NSInteger)numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0:
            return CGSizeMake(self.tupleView.width, 42.5);
            break;
        case HCell1:
            return CGSizeMake(self.tupleView.width, 35);
            break;
        case HCell2:
            return CGSizeMake(self.tupleView.width, 1);
            break;
        case HCell3:
            return CGSizeMake(self.tupleView.width, 42.5);
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0:
            return UIEdgeInsetsMake(0, 15, 2.5, 15);
        case HCell1:
            return UIEdgeInsetsMake(2.5, 15, 0, 15);
        case HCell2:
            return UIEdgeInsetsZero;
        case HCell3:
            return UIEdgeInsetsZero;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont boldSystemFontOfSize:17.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textVerticalAlignment = HTextVerticalAlignmentBottom;
            cell.label.textColor = HColorHex(#0B0A0C);
            cell.label.text = @"过期提醒";
        }
            break;
        case HCell1: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont systemFontOfSize:12.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textVerticalAlignment = HTextVerticalAlignmentTop;
            cell.label.numberOfLines = 0;
            cell.label.textColor = HColorHex(#070507);
            cell.label.text = @"您的会员资格已不足3天，请及时充值!";
        }
            break;
        case HCell2: {
            HTupleBlankCell *cell = itemBlock(nil, HTupleBlankCell.class, nil, YES);
            cell.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        }
            break;
        case HCell3: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            cell.label.font = [UIFont boldSystemFontOfSize:17.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textColor = HColorHex(#3184DD);
            cell.label.text = @"确定";
        }
            break;
            
        default:
            break;
    }
    
}
- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == HCell3) {
        [self back];
    }
}

@end

