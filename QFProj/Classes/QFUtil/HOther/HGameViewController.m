//
//  HGameViewController.m
//  QFProj
//
//  Created by txkj_jordan on 2019/4/10.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "HGameViewController.h"
//#import <Masonry.h>
//#import "HSFSafariViewController.h"
//
//@interface HGameViewController ()
//
//@property (nonatomic, strong) UIView *gameContentView;
//
///**
// 需要迷你型navBar(同时statusBar需要隐藏)的游戏类型数组 -> 有的游戏能全屏显示 能划掉‘全屏显示’的蒙层
// */
//@property (nonatomic, strong) NSArray *miniNavbarGameTypeArr;
//
//@property (nonatomic ,strong) HSFSafariViewController *sfsafarViewController;
//@property (nonatomic ,strong) NSURL *gameURL;
//@end
//
//@implementation HGameViewController

//- (instancetype)initWithURL:(NSURL *)url{
//    if ([super init]) {
//        self.gameURL = url;
//    }
//    return self;
//}
//- (UIView *)gameContentView{
//    if (_gameContentView == nil) {
//        _gameContentView =  [UIView new];
//        _gameContentView.backgroundColor = [UIColor clearColor];
//    }
//    return _gameContentView;
//}


//- (void)back{
//    //移除子视图
//    [self.sfsafarViewController willMoveToParentViewController:nil];
//    [self.sfsafarViewController removeFromParentViewController];
//    [self.sfsafarViewController.view removeFromSuperview];
//    [super back];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [AppDelegate setShouldAutorotate:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [AppDelegate setShouldAutorotate:NO];
//}
//- (void)game_viewDidLoad{
//    [self.view insertSubview:self.gameContentView atIndex:0];
//    [self.gameContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    self.sfsafarViewController.delegate = (id<SFSafariViewControllerDelegate>)self;
//
//    [self addChildViewController:self.sfsafarViewController];
//    [self.sfsafarViewController didMoveToParentViewController:self];
//    self.sfsafarViewController.preferredControlTintColor = self.preferredControlTintColor;
//
//    [self.gameContentView addSubview:self.sfsafarViewController.view];
//    [self.sfsafarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.gameContentView);
//    }];
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
//    [self.view setBackgroundColor:[HSkinManager vcBgViewColor]];
//    [self.topBar setBackgroundColor:[HSkinManager naviBarColor]];
//    [self setLeftNaviImage:[UIImage imageNamed:@"top_Back_pre"]];
//    [self.titleLabel setText:@"游戏"];
//    [self game_viewDidLoad];
//
//    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    }
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleDeviceOrientationChange:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
//}
//
//#pragma mark - SFSafariViewControllerDelegate
//- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [controller dismissViewControllerAnimated:YES completion:^{
//
//    }];
//}
//
//- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
////    self.didFinishLaunch = YES;
//}
//
//- (HSFSafariViewController *)sfsafarViewController{
//    if (_sfsafarViewController == nil) {
//        _sfsafarViewController = [[HSFSafariViewController alloc] initWithURL:self.gameURL];
//    }
//    return _sfsafarViewController;
//}
//
//#pragma mark - notification method
//- (void)handleDeviceOrientationChange:(NSNotification *)notification {
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    switch (deviceOrientation) {
//        case UIDeviceOrientationLandscapeLeft:
//        case UIDeviceOrientationLandscapeRight:
//        {
//
//            [self.gameContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.view.mas_top).offset(-44);
//            }];
//             self.topBar.hidden = YES;
//        }
//            break;
//        case UIDeviceOrientationPortrait:
//        {
//
//            [self.gameContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.view.mas_top).offset(0);
//            }];
//            self.topBar.hidden = NO;
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}
//
//#pragma mark - 进度条颜色(默认颜色蓝色)
//- (void)setPreferredControlTintColor:(UIColor *)preferredControlTintColor{
//    _preferredControlTintColor = preferredControlTintColor;
//    if (self.sfsafarViewController) {
//        self.sfsafarViewController.preferredControlTintColor = _preferredControlTintColor;
//    }
//}
//
//#pragma mark - over load
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//#pragma mark - lazy load
//- (NSArray *)miniNavbarGameTypeArr {
//    if (!_miniNavbarGameTypeArr) {
//        _miniNavbarGameTypeArr = @[@"PT"];
//    }
//    return _miniNavbarGameTypeArr;
//}
//
//@end
