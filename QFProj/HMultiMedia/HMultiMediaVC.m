//
//  HMultiMediaVC.m
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HMultiMediaVC.h"
#import "HSendAudioVC.h"
#import "HAcceptAudioVC.h"
#import "HSendVideoVC.h"
#import "HAcceptVideoVC.h"
#import "UIAlertController+HUtil.h"

@interface HMultiMediaVC ()

@end

@implementation HMultiMediaVC

- (void)setMultiMediaStatus:(HMultiMediaStatus)multiMediaStatus {
    if (_multiMediaStatus != multiMediaStatus) {
        _multiMediaStatus = multiMediaStatus;
        [self.tupleView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.topExtendedLayout = NO;
    self.tupleView.scrollEnabled = NO;// 禁止滚动
    [self.tupleView setTupleDelegate:self];
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

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.tupleView.size;
}
- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (self.multiMediaStatus) {
        case HMultiMediaInAudio: {
//            itemBlock(nil, HUserLiveBgCell.class, nil, YES);
        }
            break;
        case HMultiMediaOutAudio: {
//            itemBlock(nil, HUserLiveBgCell.class, nil, YES);
        }
            break;
        case HMultiMediaInVideo: {
//            itemBlock(nil, HUserLiveBgCell.class, nil, YES);
        }
            break;
        case HMultiMediaOutVideo: {
//            itemBlock(nil, HUserLiveBgCell.class, nil, YES);
        }
            break;
            
        default:
            break;
    }
//    switch (indexPath.row) {
//        case 0: {
//            itemBlock(nil, HUserLiveBgCell.class, nil, YES);
//        }
//            break;
//        case 2: {
//            itemBlock(nil, HUserLiveBgCell.class, nil, YES);
//        }
//            break;
//        case 1: {
//            if (self.liveStatus == HLiveStatusLoading) {
//                HUserLiveBgCell *cell = itemBlock(nil, HUserLiveBgCell.class, nil, YES);
//                // 禁止滚动
//                self.tupleView.scrollEnabled = NO;
//                // 开始旋转
//                [cell.activityIndicator startAnimating];
//                //可反复加载内容的直播功能
//                [self reloadLiveBroadcast:^{
//                    // 解除禁止滚动
//                    self.tupleView.scrollEnabled = YES;
//                    // 停止旋转
//                    [cell.activityIndicator stopAnimating];
//                    // 更改直播状态
//                    self.liveStatus = HLiveStatusLiveing;
//                }];
//            }else if (self.liveStatus == HLiveStatusLiveing) {
//                itemBlock(nil, HUserLiveCell.class, nil, YES);
//            }
//        }
//            break;
//
//        default:
//            break;
//    }

}

@end
