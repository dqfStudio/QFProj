//
//  HSheetController.m
//  QFProj
//
//  Created by dqf on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HSheetController.h"
#import "UIViewController+HTransition.h"
#import "HTupleView.h"

@interface HSheetController () <HTupleViewDelegate>
@property (nonatomic) UIVisualEffectView *visualView;
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HSheetController

- (CGSize)containerSize {
    return CGSizeMake(UIScreen.width, 190+UIScreen.bottomBarHeight);
}

- (HTransitionStyle)presetType {
    return HTransitionStyleSheet;
}

- (UIVisualEffectView *)visualView {
    if (!_visualView) {
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
        CGRect frame = CGRectZero;
        frame.size = self.containerSize;
        _visualView.frame = frame;
    }
    return _visualView;
}

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = CGRectZero;
        frame.size = self.containerSize;
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
    self.view.backgroundColor = UIColor.clearColor;
    [self.topBar setHidden:YES];
    if (self.hideVisualView) {
        self.tupleView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:self.tupleView];
    }else {
        [self.visualView.contentView addSubview:self.tupleView];
        [self.view addSubview:self.visualView];
    }
    [self.tupleView setTupleDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.hideVisualView) {
        for (UIView *subview in self.visualView.subviews) {
            subview.layer.cornerRadius = self.tupleView.layer.cornerRadius;
        }
    }
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
            return CGSizeMake(self.tupleView.width, 40);
            break;
        case HCell1:
            return CGSizeMake(self.tupleView.width, 50);
            break;
        case HCell2:
            return CGSizeMake(self.tupleView.width, 50);
            break;
        case HCell3:
            return CGSizeMake(self.tupleView.width, 50);
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsZero;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
            cell.label.font = [UIFont boldSystemFontOfSize:17.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.textColor = HColorHex(#0B0A0C);
            cell.label.text = @"过期提醒";
        }
            break;
        case HCell1: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
            cell.label.font = [UIFont systemFontOfSize:12.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.numberOfLines = 0;
            cell.label.textColor = HColorHex(#070507);
            cell.label.text = @"您的会员资格已不足3天，请及时充值!";
        }
            break;
        case HCell2: {
            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
            [cell addBottomLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
            cell.label.font = [UIFont systemFontOfSize:12.f];
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.numberOfLines = 0;
            cell.label.textColor = HColorHex(#070507);
            cell.label.text = @"您的会员资格已不足3天，请及时充值!";
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
