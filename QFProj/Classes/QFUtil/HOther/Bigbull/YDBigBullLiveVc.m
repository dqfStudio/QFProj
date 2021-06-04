////
////  YDBigBullLiveVc.m
////  UserClient
////
////  Created by kevin on 2019/8/21.
////  Copyright © 2019 zex. All rights reserved.
////
//
//#import "YDBigBullLiveVc.h"
//#import "LiveRoomExchangeView.h"
//#import "LiveControlViewCtr.h"
//#import "LoadingLiveView.h"
//#import "YDLiveLeadView.h"
//#import "YDLiveClearVc.h"
//#import "TXVedioPlayerCtl.h"
//#import <TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>
//#import <MBProgressHUD/MBProgressHUD.h>
//#import "TXVodPlayerCtl.h"
//#import "EmptyView.h"
//#import "YDBigBullPlayerVc.h"
//#import "SmartPlayerSDK.h"
//#import "USVGAView.h"
//#import "LiveGiftTableView.h"
//#import "LiveCountDownView.h"
//#import "ChipManager.h"
//
//@interface YDBigBullLiveVc ()<LiveRoomExchangeViewDelegate>
////切换直播间的View
//@property (nonatomic, strong) LiveRoomExchangeView *roomChangeView;
////直播控制层
//@property (nonatomic, strong) LiveControlViewCtr *liveControlViewCtr;
////直播清屏页
//@property (nonatomic, strong) YDLiveClearVc *liveClearVc;
//@property (nonatomic, strong) YDLiveLeadView *leadView;
////大牛播放器
//@property (nonatomic, strong) YDBigBullPlayerVc *bigBullPlayerCtl;
////拉流播放器
//@property (nonatomic, strong) TXVedioPlayerCtl *vedioPlayerCtl;
////超级播放器
//@property (nonatomic, strong) TXVodPlayerCtl *vodPlayerCtl;
//
//@property (nonatomic, assign) BOOL showErr;
////列表所有的直播信息
////@property (nonatomic, copy) NSString *sid;
//@property (nonatomic, strong) NSMutableArray <VideoItemModel *> *videosList;
//@property (nonatomic, assign) NSInteger selectIndex;
//@property (nonatomic, assign) BOOL isFirstCome;
//@property (nonatomic, assign) BOOL reConnect;
//@property (nonatomic, assign) BOOL kEnter;
//@end
//
//@implementation YDBigBullLiveVc
//
//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.videosList = [NSMutableArray new];
//    self.selectIndex = 0;
//    _kEnter = YES;
//    self.isFirstCome = YES;
//    self.forbiddenGestureBack = YES;
//    [self.view addSubview:self.roomChangeView];
//
//    if (self.routerParams) {
//        _sid = self.routerParams[@"sid"];
//        _anchorId = self.routerParams[@"anchorId"];
//        _isMultiplayer = self.routerParams[@"isMultiplayer"];
//    }
//
//    [self requestLiveRoomType];
//
//    [self requestAllLiveData];
//
//    [self addNotifications];
//    if (!GVUserDefaultsDefalut.isComed) {
//        self.leadView = [[YDLiveLeadView alloc] initWithFrame:self.view.frame];
//        [APPDELEGATE.window addSubview:self.leadView];
//    }
//
//    // 获取筹码
//    [[ChipManager shared] asyncFetchChipsWithCompletion:^(NSArray<id<UCChip>> * _Nonnull chips) {
//
//    }];
//
//}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self setupCaptureScreen];
//}
//
//#pragma mark -----------------------------截屏监测---------------------------
//- (void) setupCaptureScreen {
//        UIScreen * sc = [UIScreen mainScreen];
//        if (@available(iOS 11.0, *)) {
//            if (sc.isCaptured) {
//                NSLog(@"正在录制 or  截屏~~~~~~~~~%d",sc.isCaptured);
//                [self screenshots];
//            }
//        } else {
//    }
//        if (@available(iOS 11.0, *)) {
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenshots) name:UIScreenCapturedDidChangeNotification  object:nil];
//        } else {
//    }
//}
//
//- (void)screenshots {
//    NSDate *dt = [NSDate nowDate];
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    [df setValue:dt forKey:@"NOWTIMESTAMP"];
//     [self.navigationController popViewControllerAnimated:YES];
//    YDCustomAlertView *yDCustomAlertView = [YDCustomAlertView creatAlertWithTitle:Local_String(@"app.prohibit.screenshot") message:nil cancelBtnTitle:nil otherBtnTitle:Local_String(@"common.confirm") Type:CustomAlertViewTypeNomal cancelButtonBlock:nil otherButtonBlock:nil textBlock:nil];
//    [APPDELEGATE.window addSubview:yDCustomAlertView];
//}
//
//#pragma mark ------------------ 通知相关------------------
//- (void)addNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kRealReachabilityChangedNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(notificationAction:)
//                                                 name:notificationKeyCanScroll
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(notificationAction:)
//                                                 name:notificationKeyStartLive
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(notificationAction:)
//                                                 name:notificationKeyStopLive
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(notificationAction:)
//                                                 name:notificationKeyRefreshLive
//                                               object:nil];
//
//    //主播下线通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(hostOutRoom:)
//                                                 name:notificationKeyHostOutRoom
//                                               object:nil];
//}
//
//
//
//
//-(void)hostOutRoom:(NSNotification *)notify {
//    [self clearPlayer];
//    [self showHostOutRoomView];
//}
//
////空页面
//- (void)showHostOutRoomView {
//    [self hideEmptyView];
//    EmptyModel *model = [[EmptyModel alloc] init];
//    model.topDistance = CFSize(187) + CFNaviHeight;
//    model.bgColor = [UIColor clearColor];
//    model.textColor = [UIColor whiteColor];
//    model.tipText = Local_String(@"live.room.anchor.offline");
//    model.iconImgUrl = @"hostOut";
//    model.bttonTitle = Local_String(@"live.room.back.home");
//    model.sendback = YES;
//    weakSelf(self);
//    model.block = ^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    };
//    model.frame = CGRectMake(0, CFNaviHeight, kCFScreenWidth, self.view.height - model.topDistance);
//    [EmptyView showEmptyViewWithModel:model inSuperView:self.liveControlViewCtr.view];
//
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    effectView.frame = APPDELEGATE.window.bounds;
//    effectView.alpha = 0.2;
//    [self.liveControlViewCtr.view sendSubviewToBack:effectView];
//}
//
//- (void)notificationAction:(NSNotification *)notify {
//    NSString *name = notify.name;
//    DDLog(@"notify*************%@", name);
//    if ([name isEqualToString:notificationKeyCanScroll]) { //直播间是否可以滚动通知
//        BOOL canScroll = [notify.object boolValue];
//        if (canScroll) {
//            self.roomChangeView.scrollView.scrollEnabled = YES;
//        } else {
//            self.roomChangeView.scrollView.scrollEnabled = NO;
//        }
//        if (self.videosList.count == 1) {
//            self.roomChangeView.scrollView.scrollEnabled = NO;
//        }
//    } else if ([name isEqualToString:notificationKeyStartLive]) { //可以直播
//        //loading
//
//        [LoadingLiveView showLoadingInteractionInSuperView:self.view canTouch:YES];
//        VideoItemModel *itemModel = self.liveControlViewCtr.videoItemModel;
//        self.roomChangeView.coverUrl = itemModel.coverUrl;
//
//        if ([itemModel.videoType intValue] == 2) {//超级播放器
//            [self.vodPlayerCtl startPlay:itemModel];
//        } else {
//            if (!itemModel || itemModel.pullLCAddress.length <= 0) {
//                return;
//            }
//            [self clearPlayer];
//            if ([self.homeModel.se intValue] == 1) {
//                 [self.bigBullPlayerCtl startPlay:itemModel];
//            } else {
//                [self.vedioPlayerCtl startPlay:itemModel];
//            }
//
//        }
//    } else if ([name isEqualToString:notificationKeyStopLive]) { //停止直播
//        [self clearPlayer];
//    } else if ([name isEqualToString:notificationKeyRefreshLive]) { //重新刷新直播间
////        VideoItemModel *model = self.liveControlViewCtr.videoItemModel;
////        [self reloadPlayerWithUrl:[NSURL URLWithString:model.pullLCAddress]];
//        //移除之前的控制层
//        [self removeLiveControlView];
//        //清除之前的播放器
//        [self clearPlayer];
//        [self requestLiveRoomType];
//    }
//}
//
//#pragma mark ------------------ 空白页------------------
//
////空页面
//- (void)showEmptyView {
//    [self hideEmptyView];
//    EmptyModel *model = [[EmptyModel alloc] init];
//    model.topDistance = CFSize(187) + CFNaviHeight;
//    model.bgColor = [UIColor clearColor];
//    model.textColor = [UIColor whiteColor];
//    model.tipText = Local_String(@"live.room.livestream.failure");
//    model.iconImgUrl = @"teamReportEmpty";
//    model.bttonTitle = Local_String(@"common.back");
//    weakSelf(self);
//    model.block = ^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    };
//    model.frame = CGRectMake(0, CFNaviHeight, kCFScreenWidth, self.view.height - model.topDistance);
//    [EmptyView showEmptyViewWithModel:model inSuperView:self.view];
//}
//
////进入直播间时的主播已下播
//-(void)showOutLineWithMsg:(NSString *)msg{
//    [self hideEmptyView];
//    EmptyModel *model = [[EmptyModel alloc] init];
//    model.topDistance = CFSize(187) + CFNaviHeight;
//    model.bgColor = [UIColor clearColor];
//    model.textColor = [UIColor whiteColor];
//    model.tipText = msg;
//    model.iconImgUrl = @"hostOut";
//    model.bttonTitle = Local_String(@"live.room.back.home");
//    weakSelf(self);
//    model.block = ^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    };
//    model.frame = CGRectMake(0, CFNaviHeight, kCFScreenWidth, self.view.height - model.topDistance);
//    [EmptyView showEmptyViewWithModel:model inSuperView:self.view];
//}
//
//-(void)showReconnectView{
//    [self hideEmptyView];
//    EmptyModel *model = [[EmptyModel alloc] init];
//    model.topDistance = CFSize(187) + CFNaviHeight;
//    model.bgColor = [UIColor clearColor];
//    model.textColor = [UIColor whiteColor];
//    model.textColor = [UIColor whiteColor];
//    model.tipText = Local_String(@"live.room.livestream.failure");
//    model.iconImgUrl = @"lodingCenter";
//    model.bttonTitle = Local_String(@"empty.retry");
//    model.sendback = YES;
//    weakSelf(self);
//    model.block = ^{
//        [weakSelf hideEmptyView];
//
//        [LoadingLiveView showLoadingInteractionInSuperView:weakSelf.view canTouch:YES];
//        //重新拉所有接口
//        [weakSelf.liveControlViewCtr requestLiveRoomType:NO];
//
//    };
//    model.frame = CGRectMake(0, CFNaviHeight, kCFScreenWidth, self.view.height - model.topDistance);
//    [EmptyView showEmptyViewWithModel:model inSuperView:self.liveControlViewCtr.view];
//
//}
//- (void)hideEmptyView {
//    [EmptyView hideEmptyViewFromSuperView:self.view];
//}
//
//-(void)handleErrorWithKey:(NSString *)key{
//    [self showEmptyView];
//}
//- (void)hideLoadingAction {
//    self.showErr = YES;
//    [LoadingLiveView hideLoadingViewInSuperView:self.view];
//
//}
//
////移除控制层
//- (void)removeLiveControlView {
//    NSArray *views = self.childViewControllers;
//    weakSelf(self);
//    [views enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//        if ([obj isKindOfClass:[LiveControlViewCtr class]]) {
//            LiveControlViewCtr *liveCtr = (LiveControlViewCtr *)obj;
//            [liveCtr willMoveToParentViewController:nil];
//            [liveCtr removeFromParentViewController];
//            [liveCtr.view removeFromSuperview];
//            weakSelf.liveControlViewCtr = nil;
//        } else if ([obj isKindOfClass:[YDLiveClearVc class]]) {
//            YDLiveClearVc *liveCtr = (YDLiveClearVc *)obj;
//            [liveCtr willMoveToParentViewController:nil];
//            [liveCtr removeFromParentViewController];
//            [liveCtr.view removeFromSuperview];
//            weakSelf.liveClearVc = nil;
//        } else if ([obj isKindOfClass:[YDBigBullPlayerVc class]]) {
//            YDBigBullPlayerVc *liveCtr = (YDBigBullPlayerVc *)obj;
//            [liveCtr willMoveToParentViewController:nil];
//            [liveCtr removeFromParentViewController];
//            [liveCtr.view removeFromSuperview];
//            weakSelf.bigBullPlayerCtl = nil;
//        } else if ([obj isKindOfClass:[TXVodPlayerCtl class]]) {
//            TXVodPlayerCtl *liveCtr = (TXVodPlayerCtl *)obj;
//            [liveCtr willMoveToParentViewController:nil];
//            [liveCtr removeFromParentViewController];
//            [liveCtr.view removeFromSuperview];
//            weakSelf.vodPlayerCtl = nil;
//        } else if ([obj isKindOfClass:[TXVedioPlayerCtl class]]) {
//            TXVedioPlayerCtl *liveCtr = (TXVedioPlayerCtl *)obj;
//            [liveCtr willMoveToParentViewController:nil];
//            [liveCtr removeFromParentViewController];
//            [liveCtr.view removeFromSuperview];
//            weakSelf.vedioPlayerCtl = nil;
//        }
//    }];
//}
//#pragma mark ------------------ liveRoomExchangeView delegate------------------
//- (void)liveRoomExchangeView:(LiveRoomExchangeView *)roomView selectIndex:(NSInteger)index {
//    self.selectIndex = index;
//    VideoItemModel *model = self.videosList[index];
//    self.sid = [NSString stringWithFormat:@"%@", model.sid];
//    self.anchorId = [NSString stringWithFormat:@"%@",model.anchorId];
//    [self removeLiveControlView];
//    [self clearPlayer];
//
//    [self requestLiveRoomType];
//    [self requestAllLiveData];
//}
//
//
//
//
//
////添加控制层到直播也
//- (void)addLiveControlViewWithItemModel:(VideoItemModel *)itemModel {
//    weakSelf(self);
//    [USVGAView.shareInstance stopAnimation];
//    [USVGAView.shareApproach stopAnimation];
//    self.isFirstCome = YES;
//    if ([itemModel.videoType intValue] == 2 ) {//超级播放器
//        if (_bigBullPlayerCtl) {
//            [self.bigBullPlayerCtl.view removeFromSuperview];
//            self.bigBullPlayerCtl = nil;
//            [self.bigBullPlayerCtl removeFromParentViewController];
//        }
//        if (_vedioPlayerCtl) {
//            [self.vedioPlayerCtl.view removeFromSuperview];
//            self.vedioPlayerCtl = nil;
//            [self.vedioPlayerCtl removeFromParentViewController];
//        }
//        if (!_vodPlayerCtl) {
//            weakSelf(self);
//            [self addChildViewController:self.vodPlayerCtl];
//
//            [self.vodPlayerCtl.playerSubject subscribeNext:^(id _Nullable x) {
//                int EvtID = [x[@"EvtID"] intValue];
//                NSDictionary *param = x[@"param"];
//                [weakSelf onSuperPlayEvent:EvtID withParam:param];
//            }];
//            [self.vodPlayerCtl.netSubject subscribeNext:^(id _Nullable x) {
//            }];
//            _vodPlayerCtl.view.frame = CGRectMake(0, kCFScreenHeight, kCFScreenWidth, kCFScreenHeight);
//            [self.roomChangeView.scrollView addSubview:_vodPlayerCtl.view];
//        }
//        _vodPlayerCtl.videoItemModel = itemModel;
//    } else {
//        if (_vodPlayerCtl) {
//            [_vodPlayerCtl.view removeFromSuperview];
//            _vodPlayerCtl = nil;
//            [_vodPlayerCtl removeFromParentViewController];
//        }
//
//        if ([self.homeModel.se intValue] == 1) {
//            if (_vedioPlayerCtl) {
//                [self.vedioPlayerCtl.view removeFromSuperview];
//                self.vedioPlayerCtl = nil;
//                [self.vedioPlayerCtl removeFromParentViewController];
//            }
//             if (!self.bigBullPlayerCtl) {
//                 self.bigBullPlayerCtl = [[YDBigBullPlayerVc alloc]init];
//
//                 weakSelf(self);
//
//                 [self.bigBullPlayerCtl.playerSubject subscribeNext:^(NSDictionary *x) {
//                     //[self.playerSubject sendNext:@{@"EvtID":@(EvtID),@"param":param}];
//                     int EvtID = [x[@"EvtID"] intValue];
//                     NSDictionary *param = x[@"param"];
//                     [weakSelf onPlayEvent:EvtID withParam:param];
//                 }];
//
//
//                 [self.bigBullPlayerCtl.netSubject subscribeNext:^(NSDictionary *x) {
//                     //网络状态不好，弹出提示框
//                 }];
//
//                 [self addChildViewController:self.bigBullPlayerCtl];
//                 _bigBullPlayerCtl.view.frame = CGRectMake(0, kCFScreenHeight, kCFScreenWidth, kCFScreenHeight);
//                 [self.roomChangeView.scrollView addSubview:_bigBullPlayerCtl.view];
//                 [_bigBullPlayerCtl didMoveToParentViewController:self];
//             }
//             _bigBullPlayerCtl.videoItemModel = itemModel;
//
//        } else {
//            if (_bigBullPlayerCtl) {
//                [self.bigBullPlayerCtl.view removeFromSuperview];
//                self.bigBullPlayerCtl = nil;
//                [self.bigBullPlayerCtl removeFromParentViewController];
//            }
//            if (!self.vedioPlayerCtl) {
//                self.vedioPlayerCtl = [[TXVedioPlayerCtl alloc]init];
//
//                weakSelf(self);
//                //腾讯云播放状态
//                [self.vedioPlayerCtl.playerSubject subscribeNext:^(NSDictionary *x) {
//                    //[self.playerSubject sendNext:@{@"EvtID":@(EvtID),@"param":param}];
//                    int EvtID = [x[@"EvtID"] intValue];
//                    NSDictionary *param = x[@"param"];
//                    [weakSelf onTXVideoPlayEvent:EvtID withParam:param];
//                }];
//
//                //腾讯云网络状态
//                [self.vedioPlayerCtl.netSubject subscribeNext:^(NSDictionary *x) {
//                    //网络状态不好，弹出提示框
//                    [weakSelf onTXVideoNetStatus:x];
//
//                }];
//
//                [self addChildViewController:self.vedioPlayerCtl];
//                _vedioPlayerCtl.view.frame = CGRectMake(0, kCFScreenHeight, kCFScreenWidth, kCFScreenHeight);
//                [self.roomChangeView.scrollView addSubview:_vedioPlayerCtl.view];
//                [_vedioPlayerCtl didMoveToParentViewController:self];
//            }
//            _vedioPlayerCtl.videoItemModel = itemModel;
//
//        }
//
//
//
//
//
//    }
//
//    YDLiveClearVc *clearVc = [[YDLiveClearVc alloc] init];
//    //    clearVc.videoItemModel = itemModel;
//    self.liveClearVc = clearVc;
//    [self addChildViewController:clearVc];
//    clearVc.view.frame = CGRectMake(0, kCFScreenHeight, kCFScreenWidth, kCFScreenHeight);
//    clearVc.view.alpha = 0;
//    [self.roomChangeView.scrollView addSubview:clearVc.view];
//    [clearVc didMoveToParentViewController:self];
//    clearVc.leftClosePageBlock = ^{
//        [UIView animateWithDuration:0.5 animations:^{
//            weakSelf.liveControlViewCtr.view.x = 0;
//        } completion:^(BOOL finished) {
//            weakSelf.liveClearVc.view.alpha = 0;
//        }];
//    };
//    //添加前会被移除 防止重复添加
//    LiveControlViewCtr *liveControlCtr = [[LiveControlViewCtr alloc] init];
//    liveControlCtr.videoItemModel = itemModel;
//    liveControlCtr.roomModel = _roomModel;
//    liveControlCtr.isMultiplayer = _isMultiplayer;
//
//    self.liveControlViewCtr = liveControlCtr;
//    [self addChildViewController:liveControlCtr];
//    liveControlCtr.view.frame = CGRectMake(0, kCFScreenHeight, kCFScreenWidth, kCFScreenHeight);
//    [self.roomChangeView.scrollView addSubview:liveControlCtr.view];
//    [liveControlCtr didMoveToParentViewController:self];
//
//    //关闭页面
//    liveControlCtr.closePageBlock = ^{
//        [USVGAView.shareInstance stopAnimation];
//        [USVGAView.shareApproach stopAnimation];
//        [weakSelf hideLoadingAction];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    };
//    [liveControlCtr setRightClosePageBlock:^(LiveRoomInfoModel *model) {
//        [UIView animateWithDuration:0.5 animations:^{
//            weakSelf.liveControlViewCtr.view.x = kCFScreenWidth;
//        } completion:^(BOOL finished) {
//            [weakSelf.liveClearVc refreshData:model];
//            weakSelf.liveClearVc.view.alpha = 1;
//        }];
//    } ];
//}
//#pragma mark ------------------ 请求相关------------------
////////API////
//- (void)requestLiveRoomType{ //获取直播间类型
//    CFClient *client = [[CFClient alloc] initWithDelegate:self];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"anchorId"] = _anchorId;
//    [client postUrl:liveInRoomUrl params:params];
//    [LoadingView showLoadingInView:self.view];
//}
//- (void)requestAllLiveData {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"sid"] = self.sid;
//    [[[CFClient alloc] initWithDelegate:self] postUrl:liveGetVideoListUrl params:params];
//}
//
//
//
//- (void)networkResponse:(NSDictionary *)result key:(NSString *)key client:(CFClient *)client {
//
//    if ([key isEqualToString:liveGetVideoListUrl] ) {
//        if ([result[@"iRet"] isEqualToString:successCode]) {
//            NSArray *rows = result[@"body"];
//            NSMutableArray *items = [NSMutableArray array];
////            NSArray *items = [UCLiveVedioModel getModelsFromArray:rows];
//            [rows enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//                UCLiveVedioModel *model = [UCLiveVedioModel getModel:obj];
//                [items addObject:[model tranformToVedioModel]];
//            }];
//            if (items.count > 0) {
//                [self.videosList removeAllObjects];
//                self.videosList = [NSMutableArray arrayWithArray:items];
//                if (self.videosList.count == 1) {
//                    self.selectIndex = 0;
//                } else {
//                    self.selectIndex = 1;
//                }
//                [self refreshLiveInfo];
//            }
//        }else{
//            [self showEmptyView];
//        }
//    }else if ([key isEqualToString:liveInRoomUrl]){
//        [LoadingView hideLoadingFromView:self.view];
//        if ([result[@"iRet"] isEqualToString:successCode]) {//刷新homeModel
//            _roomModel = [UCEnterRoomModel getModel:result[@"body"]];
//            _homeModel = [_roomModel.vm tranformToVedioModel];
//            [self addLiveControlViewWithItemModel:_homeModel];
//        }else if ([result[@"code"] isEqualToString:zhuboOutLine] || [result[@"code"] isEqualToString:streamNotExist]){
//            [self showOutLineWithMsg:result[@"msg"]];
//        }else{
//            [self showEmptyView];
//        }
//    }
//
//}
//
//- (void)refreshLiveInfo {
//    //添加直播控制层
//    VideoItemModel *model;
//    if (self.videosList.count == 0) {
//        return;
//    } else if (self.videosList.count == 1) {
//        model = [self.videosList[0] copy];
//        self.roomChangeView.scrollView.scrollEnabled = NO;
//    } else {
//        model = [self.videosList[1] copy];
//        self.roomChangeView.scrollView.scrollEnabled = YES;
//        [self.roomChangeView updateForItemsList:self.videosList withSelectIndex:1];
//    }
//
//
//}
//
//
//
//
//
//#pragma mark ------------------ 播放回调------------------
//- (void)onTXVideoPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
//    weakSelf(self);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
//
//        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END) {
//            if (EvtID == PLAY_ERR_NET_DISCONNECT) {//网络重连结束
//                [weakSelf hideLoadingAction];
//                [weakSelf showReconnectView];
//            }
//        } else if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
//            weakSelf.isFirstCome = NO;
//            [weakSelf hideLoadingAction];
//            [LoadingView hideLoading];
//            [weakSelf hideEmptyView];
//            [LoadingLiveView hideLoadingViewInSuperView:weakSelf.view];
//        } else if (EvtID == WARNING_VIDEO_PLAY_LAG) {//视频出现卡顿
//
//        } else if (EvtID == EVT_VIDEO_PLAY_PROGRESS) {
//            [LoadingLiveView hideLoadingViewInSuperView:weakSelf.view];
//
//        }
//    });
//}
//- (void)onTXVideoNetStatus:(NSDictionary *)param {
//    NSInteger speed =  [[param objectForKey:@"NET_SPEED"] integerValue];
//     long speed_KBs = speed;
////    kNSLog(@"##########%ld",speed_KBs);
//    if (speed_KBs > 0) {
//          [self hideEmptyView];
//    }
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
//    [dict setObject:[NSString stringWithFormat:@"%ld",speed * 1024] forKey:@"speed"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:notificationKeybBigBulldownLoadSpeed object:nil userInfo:dict];
//}
//- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
//    weakSelf(self);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (EvtID == EVENT_DANIULIVE_ERC_PLAYER_RESOLUTION_INFO) {
//            weakSelf.isFirstCome = NO;
//            [weakSelf hideLoadingAction];
//            [LoadingView hideLoading];
//            [weakSelf hideEmptyView];
//            [LoadingLiveView hideLoadingViewInSuperView:weakSelf.view];
//        }else if (EvtID == EVENT_DANIULIVE_ERC_PLAYER_CONNECTION_FAILED){
////            [LoadingLiveView hideLoadingViewInSuperView:weakSelf.view];
////            [LoadingLiveView showLoadingInteractionInSuperView:weakSelf.view canTouch:YES];
//            [weakSelf hideLoadingAction];
//            [weakSelf showReconnectView];
//        } else if (EvtID == EVENT_DANIULIVE_ERC_PLAYER_NO_MEDIADATA_RECEIVED) {
//            [weakSelf hideLoadingAction];
//            [weakSelf showReconnectView];
//        } else if (EvtID == EVENT_DANIULIVE_ERC_PLAYER_DOWNLOAD_SPEED) {
//            [LoadingLiveView hideLoadingViewInSuperView:weakSelf.view];
//            NSInteger speed =  [[param objectForKey:@"speed"] integerValue];
//             long speed_KBs = speed/1024;
////            kNSLog(@"##########%ld",speed_KBs);
//            if (speed_KBs > 0) {
//                  [weakSelf hideEmptyView];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:notificationKeybBigBulldownLoadSpeed object:nil userInfo:param];
//
//        }
//
//    });
//}
//
//
//
//- (void)onSuperPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
//    if (EvtID == PLAY_EVT_PLAY_END) {//结束
//    } else if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {//第一帧
//        [self hideLoadingAction];
//    }
//}
//
//#pragma mark ------------------ lazyloading------------------
//
//- (TXVodPlayerCtl *)vodPlayerCtl {
//    if (!_vodPlayerCtl) {
//        _vodPlayerCtl = [[TXVodPlayerCtl alloc]init];
//    }
//    return _vodPlayerCtl;
//}
//
//- (LiveRoomExchangeView *)roomChangeView {
//    if (!_roomChangeView) {
//        _roomChangeView = [[LiveRoomExchangeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _roomChangeView.delegate = self;
//        _roomChangeView.scrollView.scrollEnabled = NO;
//    }
//    return _roomChangeView;
//}
//
//#pragma mark ------------------ 释放内存------------------
////清除之前的播放器
//- (void)clearPlayer {
//    if (_bigBullPlayerCtl) {
//        [self.bigBullPlayerCtl stopPlay];
//    }
//    if (_vedioPlayerCtl) {
//        [self.vedioPlayerCtl stopPlay];
//    }
//    if (_vodPlayerCtl) {//关闭播放器
//        [self.vodPlayerCtl stopPlay];
//    }
//}
//- (void)dealloc {
//    [LiveCountDownView.shareInstance hideForSelf];
//    DDLog(@"******************liveview释放啦~");
//    [self removeNotifications];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLoadingAction) object:nil];
//    [LiveGiftTableView.shareInstance.dataArr removeAllObjects];
//    [LiveGiftTableView.shareInstance.tableView reloadData];
////    [UIApplication sharedApplication].idleTimerDisabled = NO;
//}
//- (void)removeNotifications {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//#pragma mark ------------------ 网络变化------------------
//- (void)networkChanged:(NSNotification *)notification {
//    RealReachability *reachability = (RealReachability *)notification.object;
//    ReachabilityStatus status = [reachability currentReachabilityStatus];
//    [RealReachabilityManager getNetworkStatus:status];
//    if (status == RealStatusViaWWAN || status == RealStatusViaWiFi) {//从无网络-->有网络，
//        [self.liveControlViewCtr socketConnet];
//    } else {
//    }
//}
//
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
