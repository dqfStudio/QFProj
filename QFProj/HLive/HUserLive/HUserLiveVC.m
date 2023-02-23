//
//  HUserLiveVC.m
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserLiveVC.h"
#import "HUserLiveCell.h"
#import "UIAlertController+HUtil.h"

@interface HUserLiveVC ()

@end

@implementation HUserLiveVC

- (HTextField *)inputField {
    if (!_inputField) {
        CGRect frame = CGRectMake(0, UIScreen.height, UIScreen.width, 40);
        _inputField = [[HTextField alloc] initWithFrame:frame];
        [_inputField setBackgroundColor:UIColor.whiteColor];
        [_inputField setPlaceholderFont:[UIFont systemFontOfSize:14.f]];
        [_inputField setPlaceholder:@"请输入内容..."];
        
        _inputField.leftWidth = 10;
        [_inputField.leftLabel setText:@""];
        
        // 去掉键盘上的toolBar
        _inputField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
        [_inputField reloadInputViews];
        
        [_inputField setRightWidth:60];
        [_inputField.rightLabel setText:@"完成"];
        [_inputField.rightLabel setTextAlignment:NSTextAlignmentCenter];
        [_inputField.rightLabel setFont:[UIFont systemFontOfSize:17.f]];
        @www
        [_inputField.rightLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @sss
            [self->_inputField resignFirstResponder];
        }];
    }
    return _inputField;
}

- (void)setLiveStatus:(HLiveStatus)liveStatus {
    if (_liveStatus != liveStatus) {
        _liveStatus = liveStatus;
        [self.tupleView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.topExtendedLayout = NO;
    self.tupleView.pagingEnabled = YES;
    [self.tupleView setTupleDelegate:self];
    
    //添加键盘
    [self addKeyboardObserver];
    [self hideKeyboardWhenTapBackground];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboardNotifyAction) name:KShowKeyboardNotify object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tupleView.contentSize = CGSizeMake(0, self.tupleView.height*3);
    self.tupleView.contentOffset = CGPointMake(0, self.tupleView.height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 监测当前设备是否处于录屏状态
    UIScreen *sc = [UIScreen mainScreen];
    if (@available(iOS 11.0, *)) {
        if (sc.isCaptured) {
            [self recordingScreen];
        }
    }
    if (@available(iOS 11.0, *)) {
        // 检测到当前设备录屏状态发生变化
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordingScreen) name:UIScreenCapturedDidChangeNotification object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 截屏检测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenshot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)vcWillDisappear:(HVCDisappearType)type {
    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
        [self.tupleView releaseTupleBlock];
        //释放相关内容
        [[HLRDManager defaults] clear];
        [self removeKeyboardObserver];
        if (@available(iOS 11.0, *)) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:KShowKeyboardNotify object:nil];
        //通知释放跟直播相关的tupleView
        [[NSNotificationCenter defaultCenter] postNotificationName:KLiveRoomReleaseTupleKey object:nil];
    }
}

// 录屏
- (void)recordingScreen {
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIAlertController showAlertWithTitle:@"安全提醒" message:@"请不要录屏分享给他人以保障账户安全。" style:UIAlertControllerStyleAlert cancelButtonTitle:@"我知道了" otherButtonTitles:nil completion:nil];
    //[[[UIAlertView alloc] initWithTitle:@"安全提醒" message:@"请不要录屏分享给他人以保障账户安全。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil] show];
}

// 截屏
- (void)screenshot {
    //[UIAlertController showAlertWithTitle:@"安全提醒" message:@"请不要截屏分享给他人以保障账户安全。" style:UIAlertControllerStyleAlert cancelButtonTitle:@"我知道了" otherButtonTitles:nil completion:nil];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[[UIAlertView alloc] initWithTitle:@"安全提醒" message:@"请不要截屏分享给他人以保障账户安全。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil] show];
#pragma clang diagnostic pop
}

- (void)showKeyboardNotifyAction {
    [[UIApplication getKeyWindow] addSubview:self.inputField];
    [self.inputField becomeFirstResponder];
}

- (BOOL)prefersNavigationBarHidden {
    return YES;
}

- (void)keyboardWillShowWithRect:(CGRect)keyboardRect animationDuration:(CGFloat)duration {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, keyboardRect.origin.y-40, UIScreen.width, 40);
        self.inputField.frame = frame;
    }];
}

- (void)keyboardWillHideWithRect:(CGRect)keyboardRect animationDuration:(CGFloat)duration {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, UIScreen.height, UIScreen.width, 40);
        self.inputField.frame = frame;
    } completion:^(BOOL finished) {
        //释放textField
        [self.inputField removeFromSuperview];
        self.inputField.text = @"";
        self.inputField = nil;
    }];
}

- (void)tupleScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 2*self.view.viewHeight) {//向上滚动
        [scrollView setContentOffset:CGPointMake(0, self.view.viewHeight) animated:NO];
        [self tupleScrollViewDidScrollToTop:scrollView];
    }else if (offsetY <= 0) {//向下滚动
        [scrollView setContentOffset:CGPointMake(0, self.view.viewHeight) animated:NO];
        [self tupleScrollViewDidScrollToBottom:scrollView];
    }
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.tupleView.size;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            itemBlock(nil, HUserLiveBgCell.class, nil, YES);
        }
            break;
        case 2: {
            itemBlock(nil, HUserLiveBgCell.class, nil, YES);
        }
            break;
        case 1: {
            if (self.liveStatus == HLiveStatusLoading) {
                HUserLiveBgCell *cell = itemBlock(nil, HUserLiveBgCell.class, nil, YES);
                // 禁止滚动
                self.tupleView.scrollEnabled = NO;
                // 开始旋转
                [cell.activityIndicator startAnimating];
                //可反复加载内容的直播功能
                [self reloadLiveBroadcast:^{
                    // 解除禁止滚动
                    self.tupleView.scrollEnabled = YES;
                    // 停止旋转
                    [cell.activityIndicator stopAnimating];
                    // 更改直播状态
                    self.liveStatus = HLiveStatusLiveing;
                }];
            }else if (self.liveStatus == HLiveStatusLiveing) {
                itemBlock(nil, HUserLiveCell.class, nil, YES);
            }
        }
            break;

        default:
            break;
    }

}

//向上滚动
- (void)tupleScrollViewDidScrollToTop:(UIScrollView *)scrollView {
    // 更改直播状态
    self.liveStatus = HLiveStatusLoading;
}
//向下滚动
- (void)tupleScrollViewDidScrollToBottom:(UIScrollView *)scrollView {
    // 更改直播状态
    self.liveStatus = HLiveStatusLoading;
}
//可反复加载内容的直播功能
- (void)reloadLiveBroadcast:(void (^)(void))completion {
    dispatchAfter(3, ^{
        completion();
    });
}

@end