//
//  HSendVideoVC.m
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HSendVideoVC.h"
#import "UIAlertController+HUtil.h"

@interface HSendVideoVC ()

@end

@implementation HSendVideoVC

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = UIScreen.bounds;
        _tupleView = [HTupleView tupleFrame:^CGRect{
            return frame;
        } exclusiveSections:^NSArray *_Nullable{
            return nil;
        }];
    }
    return _tupleView;
}

- (void)setSendVideoStatus:(HSendVideoStatus)sendVideoStatus {
    if (_sendVideoStatus != sendVideoStatus) {
        _sendVideoStatus = sendVideoStatus;
        [self.tupleView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tupleView setBackgroundColor:[UIColor colorWithString:@"#634848"]];
    [self.tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
    [self.view addSubview:self.tupleView];
    
    self.tupleView.tupleState = 3;
    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:2.f repeats:YES block:^(NSTimer * _Nonnull timer) {
//        self.sendVideoStatus +=1;
//        self.tupleView.tupleState = self.sendVideoStatus;
//        if (self.sendVideoStatus >= 2) {
//            self.sendVideoStatus = -1;
//        }
//        [self.tupleView reloadData];
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (BOOL)prefersBackButtonHidden {
    return YES;
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
        if (@available(iOS 11.0, *)) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.bounds;
    _tupleView.frame = frame;
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

- (BOOL)prefersNavigationBarHidden {
    return YES;
}

@end
