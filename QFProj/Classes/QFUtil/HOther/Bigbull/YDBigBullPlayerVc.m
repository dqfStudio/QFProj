////
////  YDBigBullPlayerVc.m
////  UserClient
////
////  Created by kevin on 2019/8/21.
////  Copyright © 2019 zex. All rights reserved.
////
//
//#import "YDBigBullPlayerVc.h"
//#import <AFNetworking/AFNetworkReachabilityManager.h>
//#import "AESEncodeManager.h"
//#import <SDWebImageManager.h>
//#import "UIView+Additions.h"
//#import "SmartPlayerSDK.h"
//#ifdef DEBUG
//static const BOOL showDebugLog = YES;
//#else
//static const BOOL showDebugLog = NO;
//#endif
//
//@interface YDBigBullPlayerVc ()<SmartPlayerDelegate> {
//    UIView *_videoView;                            // 视频画面
//
//
//    NSString        *playback_url_;             //拉流url
//    NSInteger       stream_width_;              //视频宽
//    NSInteger       stream_height_;             //视频高
//    Boolean         is_fast_startup_;           //是否快速启动模式
//    Boolean         is_low_latency_mode_;       //是否开启极速模式
//    NSInteger       buffer_time_;               //buffer时间
//    Boolean         is_hardware_decoder_;       //默认软解码
//    Boolean         is_switch_url_;             //切换url flag
//    Boolean         is_mute_;                   //静音flag
//    
//    NSString        *encrypt_key_;              //RTMP解密Key
//    NSString        *encrypt_iv_;               //RTMP IV解密向量
//}
//
//@property (nonatomic, strong) NSString *playUrl;
//
//@property (nonatomic, strong) UIView *noHomeView; // 主播不在页面
//@property (strong, nonatomic) UILabel *textPlayerEventLabel;
//@property (nonatomic, strong) SmartPlayerSDK *smartPlayer;
//@property (nonatomic, assign) BOOL isPlaying;                //是否播放状态
//@property (nonatomic, assign) BOOL isInitedPlayer;
//@end
//
//@implementation YDBigBullPlayerVc
//// XXX: -
//- (BOOL)swipToUrl:(NSString *)rtmpUrl {
//    return true;
//}
//
//-(UIView *)noHomeView{
//    if (!_noHomeView) {
//        _noHomeView = [[UIView alloc]initWithFrame:self.view.bounds];
//        _noHomeView.backgroundColor = CFHexColorAlpha(@"#000000", 0.6);
//        [self.view addSubview:_noHomeView];
//
//        UIImageView *centerImg = [[UIImageView alloc]init];
//        [_noHomeView addSubview:centerImg];
//        centerImg.image = [UIImage imageNamed:@"lodingCenter"];
//        weakSelf(self);
//        [centerImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.noHomeView).offset(CFSize(227));
//            make.centerX.equalTo(weakSelf.noHomeView);
//            make.width.mas_equalTo(@34);
//            make.height.mas_equalTo(@47);
//        }];
//
//
//        UILabel *lb = [[UILabel alloc]init];
//        lb.text = Local_String(@"live.room.anchor.left");
//        lb.font = [UIFont systemFontOfSize:14];
//        lb.textColor = [UIColor whiteColor];
//        [_noHomeView addSubview:lb];
//        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(centerImg.mas_bottom).offset(12);
//            make.centerX.equalTo(centerImg);
//        }];
//
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_noHomeView addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lb.mas_bottom).offset(12);
//            make.centerX.equalTo(centerImg);
//        }];
//    }
//    return _noHomeView;
//}
//
//- (instancetype)init {
//    if (self = [super init]) {
//        _playerSubject = [[RACSubject alloc]init];
//        _netSubject = [[RACSubject alloc]init];
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [self stopPlay];
//      [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
////暂停
//- (void)pausePlay {
////    [_player pause];
//}
//
//- (void)startPlay:(VideoItemModel *)videoItemModel {
//    _videoItemModel = videoItemModel;
//    [self stopPlay];
//    [self creatPlayer];
//}
//
////- (BOOL)isPlaying {
////    return _player.isPlaying;//播放器状态
////}
//
//- (void)setVideoItemModel:(VideoItemModel *)videoItemModel {
//    _videoItemModel = videoItemModel;
//
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//     self.view.backgroundColor = [UIColor clearColor];
//    [self configData];
//    stream_width_  = CGRectGetWidth([UIScreen mainScreen].bounds);
//    stream_height_ = CGRectGetHeight([UIScreen mainScreen].bounds);
//    // 界面布局
//    [self initUI];
//    [self addNotifition];
////    [self creatPlayer];
//}
//- (void)addNotifition {
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
//}
//- (void)onAppWillResignActive:(NSNotification *)notification {
//    [self stopPlay];
////    [self.smartPlayer SmartPlayerSetMute:1];
//
//}
//
//- (void)onAppDidBecomeActive:(NSNotification *)notification {
//
//    if([UCAppdelegate.shareInstance.isNeedBuy intValue]!=1){
//        [self creatPlayer];
//    }
////    _appIsInActive = NO;
////    if (!_appIsBackground && !_appIsInActive) {
////        if (!_pushState) {
////            //            [_pusher resumePush];
////            [self continuePushBigBull];
////        }
////    }
////    [self.smartPlayer SmartPlayerSetMute:0];
//}
//
////- (void)onAppDidEnterBackGround:(NSNotification *)notification {
////    [self StopPlayer];
//////    [self.smartPlayer SmartPlayerSetMute:1];
////}
////
////- (void)onAppWillEnterForeground:(NSNotification *)notification {
////    [self creatPlayer];
//////    [self.smartPlayer SmartPlayerSetMute:0];
////}
//
//- (void)initUI {
//    // 创建Event状态显示文本
//    _textPlayerEventLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCFScreenHeight/2, self.view.frame.size.width, 50)];
//    // 设置UILabel的背景色
//    _textPlayerEventLabel.backgroundColor = [UIColor clearColor];
//    // 设置UILabel的文本颜色
//    _textPlayerEventLabel.textColor = [UIColor colorWithRed:1.0 green:0.0
//                                                       blue:1.0 alpha:1.0];
//    _textPlayerEventLabel.adjustsFontSizeToFitWidth = YES;
//
//    _textPlayerEventLabel.text = Local_String(@"live.room.current.state");
//    [self.view addSubview:_textPlayerEventLabel];
//    if (!showDebugLog) {
//        _textPlayerEventLabel.hidden = YES;
//    }
//
//}
//
//#pragma mark ------------------ 大牛播放器初始化------------------
////设置播放参数
//- (void)configData {
//
//    self.isPlaying      = NO;
//    is_fast_startup_       = YES;   //是否快速启动模式
//    is_low_latency_mode_   = NO;    //是否开启极速模式
//    buffer_time_           = 5000;     //buffer时间 ms
//    is_hardware_decoder_   = NO;    //默认软解码
//    is_switch_url_         = NO;    //URL快速切换
//    is_mute_               = NO;    //是否静音
//    self.isInitedPlayer            = NO;
//    encrypt_key_           = AESKey;
//    encrypt_iv_            = SOCKETAESIV;
//}
//
//- (void)creatPlayer {
//    if(self.isPlaying) return;
//
//    [self InitPlayer];
//    if(![self StartPlayer])
//    {
//        kNSLog(@"Call StartPlayer failed..");
//    }
//    self.isPlaying = YES;
//}
//-(bool)InitPlayer
//{
//    if(self.isInitedPlayer) {
//
//         return true;
//    }
//
//    self.smartPlayer = [[SmartPlayerSDK alloc] init];
//
//    if (self.smartPlayer ==nil ) {
//         return false;
//    }
//
////    NSString *playUrl = [AESEncodeManager AES128DecryptWithString:self.videoItemModel.pullBQAddress key:AESKey iv:SOCKETAESIV];
//    NSString *playUrl = decryptAES128(self.videoItemModel.pullBQAddress, AESKey, SOCKETAESIV);
//    playback_url_ = playUrl;
//
//    if (playback_url_.length == 0) {
//         return false;
//    }
//    _playUrl = playback_url_;
//    NSLog(@"播放地址为&&&&&&&&&&&&&%@",playback_url_);
//    if (self.smartPlayer.delegate == nil)
//    {
//        self.smartPlayer.delegate = self;
//     }
//
//    NSInteger initRet = [self.smartPlayer SmartPlayerInitPlayer];
//    if ( initRet != DANIULIVE_RETURN_OK ) {
//
//        kNSLog(@"SmartPlayerSDK call SmartPlayerInitPlayer failed, ret=%ld", (long)initRet);
//        return false;
//    }
//
//    [self.smartPlayer SmartPlayerSetPlayURL:playback_url_];
//
//    //超低延迟模式设置
//    [self.smartPlayer SmartPlayerSetLowLatencyMode:(NSInteger)is_low_latency_mode_];
//
//    //buffer time设置
//    if(buffer_time_ >= 0)
//    {
//        [self.smartPlayer SmartPlayerSetBuffer:buffer_time_];
//    }
//
//    //快速启动模式设置
//    [self.smartPlayer SmartPlayerSetFastStartup:(NSInteger)is_fast_startup_];
//
//    //如需查看实时流量信息，可打开以下接口
//    NSInteger is_report = 1;
//    NSInteger report_interval = 3;
//    [self.smartPlayer SmartPlayerSetReportDownloadSpeed:is_report report_interval:report_interval];
//
//    //录制MP4文件 是否录制视频
//    NSInteger is_record_video = 0;
//    [self.smartPlayer SmartPlayerSetRecorderVideo:is_record_video];
//
////    录制MP4文件 是否录制音频
//    NSInteger is_record_audio = 0;
//    [self.smartPlayer SmartPlayerSetRecorderAudio:is_record_audio];
//
////    [self.smartPlayer SmartPlayerSetEchoCancellationMode:1];
//
//
//    [self aesLiveData];
//
//    self.isInitedPlayer = YES;
//
//    NSLog(@"InitPlayer--");
//    return true;
//}
//
//-(bool)StartPlayer
//{
//    NSLog(@"StartPlayer++");
//
//    if ( self.smartPlayer == nil )
//    {
//        NSLog(@"StartPlayer, player SDK with nil");
//        return false;
//    }
//
//    //设置视频view旋转角度
//    [self.smartPlayer SmartPlayerSetRotation:0];
//
//    //软/硬解码模式设置
//    [self.smartPlayer SmartPlayerSetVideoDecoderMode:is_hardware_decoder_];
//    _videoView = nil;
//    _videoView  = (__bridge UIView *)([SmartPlayerSDK SmartPlayerCreatePlayView:0 y:0 width:stream_width_ height:stream_height_]);
////    _videoView.contentMode = UIViewContentModeScaleAspectFit;
//
//    if (_videoView == nil ) {
//        kNSLog(@"CreatePlayView failed..");
//        return false;
//    }
//
//    [self.view addSubview:_videoView];
//    _videoView.hidden = YES;
//    [self.smartPlayer SmartPlayerSetPlayView:(__bridge void *)(_videoView)];
//
//    [self.view bringSubviewToFront:self.textPlayerEventLabel];
//
//    /*
//     _smart_player_sdk.yuvDataBlock = ^void(int width, int height, unsigned long long time_stamp,
//     unsigned char*yData, unsigned char* uData, unsigned char*vData,
//     int yStride, int uStride, int vStride)
//     {
//     NSLog(@"[PlaySideYuvCallback] width:%d, height:%d, ts:%lld, y:%d, u:%d, v:%d", width, height, time_stamp, yStride, uStride, vStride);
//     //这里接收底层回调的YUV数据
//     };
//
//     //设置YUV数据回调输出
//     [_smart_player_sdk SmartPlayerSetYuvBlock:true];
//     */
//
//    NSInteger ret = [self.smartPlayer SmartPlayerStart];
//
//    if(ret != DANIULIVE_RETURN_OK)
//    {
//        kNSLog(@"Call SmartPlayerStart failed..ret:%ld", (long)ret);
//        return false;
//    }
//
//    NSLog(@"StartPlayer--");
//    return true;
//}
//
//
//
//- (void)aesLiveData {
//    NSInteger key_length = [encrypt_key_ length];
//
//    if(key_length > 0)
//    {
//        int key_len = 16;
//
//        if (key_length > 16 && key_length <= 24) {
//            key_len = 24;
//        } else if (key_length > 24) {
//            key_len = 32;
//        }
//
//        unsigned char key[32];
//        memset(key, 0, 32);
//
//        NSData* key_data = [encrypt_key_ dataUsingEncoding:NSUTF8StringEncoding];
//
//        NSInteger copy_key_len = key_length < key_len ? key_length : key_len;
//
//        Byte *copy_key_data = (Byte *)[key_data bytes];
//
//        for(int i=0;i<copy_key_len;i++)
//        {
//            key[i] = copy_key_data[i];
//        }
//
//        [self.smartPlayer SmartPlayerSetKey:key key_size:key_len];
//    }
//
//    NSInteger iv_length = [encrypt_iv_ length];
//
//    if(iv_length > 0)
//    {
//        int iv_len = 16;
//
//        unsigned char iv[16];
//        memset(iv, 0, 16);
//
//        NSData* iv_data = [encrypt_iv_ dataUsingEncoding:NSUTF8StringEncoding];
//
//        NSInteger copy_iv_len = iv_length < iv_len ? iv_length : iv_len;
//
//        Byte *copy_iv_data = (Byte *)[iv_data bytes];
//
//        for(int i=0;i<copy_iv_len;i++)
//        {
//            iv[i] = copy_iv_data[i];
//        }
//
//        [self.smartPlayer SmartPlayerSetDecryptionIV:iv iv_size:iv_len];
//    }
//}
//
//
////- (BOOL)swipToUrl:(NSString *)rtmpUrl {
////    _videoItemModel.pullLCAddress = rtmpUrl;
////    NSString *playUrl = [AESEncodeManager AES128DecryptWithString:rtmpUrl key:AESKey iv:SOCKETAESIV];
////    if (_player) {
////        return [_player switchStream:playUrl];
////    } else {
////        return NO;
////    }
////}
//
//
//
//- (void)stopPlay {
//    [self stopLoadingAnimation];
//    self.isPlaying = NO;
//    [self StopPlayer];
//    [self UnInitPlayer];
//}
//-(bool)StopPlayer
//{
//    NSLog(@"StopPlayer++");
//    if (self.smartPlayer.delegate != nil)
//    {
//        self.smartPlayer.delegate = nil;
//    }
//    if (self.smartPlayer != nil)
//    {
//        [self.smartPlayer SmartPlayerStop];
//        [self.smartPlayer SmartPlayerStopPullStream];
//    }
//
//    if (_videoView != nil) {
//        [SmartPlayerSDK SmartPlayeReleasePlayView:(__bridge void *)(_videoView)];
//        [_videoView removeFromSuperview];
//        _videoView = nil;
//    }
//
//
//    NSLog(@"StopPlayer--");
//    return true;
//}
//
//-(bool)UnInitPlayer
//{
//    NSLog(@"UnInitPlayer++");
//
//    if (self.smartPlayer != nil)
//    {
//        [self.smartPlayer SmartPlayerUnInitPlayer];
//        self.smartPlayer = nil;
//    }
//
//    self.isInitedPlayer = NO;
//
//    NSLog(@"UnInitPlayer--");
//    return true;
//}
//
//
//- (void)startLoadingAnimation {
//}
//
//- (void)stopLoadingAnimation {
//}
//#pragma mark ------------------ 大牛回调------------------
//- (NSInteger) handleSmartPlayerEvent:(NSInteger)nID param1:(unsigned long long)param1 param2:(unsigned long long)param2 param3:(NSString*)param3 param4:(NSString*)param4 pObj:(void *)pObj;
//{
//    NSString* player_event = @"";
//    NSString* lable = @"";
//
//    if (nID == EVENT_DANIULIVE_ERC_PLAYER_STARTED) {
//        player_event = Local_String(@"event_start_playing");
////
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_CONNECTING)
//    {
//        player_event = Local_String(@"event_connecting");
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_CONNECTION_FAILED)
//    {
//        player_event = Local_String(@"event_connection_failed");
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_CONNECTED)
//    {
//        player_event = Local_String(@"event_connected");
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_DISCONNECTED)
//    {
//        player_event = Local_String(@"event_disconnected");
//
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_STOP)
//    {
//        player_event = Local_String(@"event_stop_playing");
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_RESOLUTION_INFO)
//    {
////        __block
//        stream_width_ = (NSInteger)param1;
//        stream_height_ = (NSInteger)param2;
//        NSString *str_w = [NSString stringWithFormat:@"%ld", (long)(NSInteger)param1];
//        NSString *str_h = [NSString stringWithFormat:@"%ld", (long)(NSInteger)param2];
//        NSInteger screenWidth = kCFScreenHeight/self->stream_height_ * self->stream_width_;
//        NSInteger screenHeight = kCFScreenWidth/self->stream_width_ * self->stream_height_;
//        NSInteger xbegin;
//        NSInteger ybegin;
//        if (screenWidth >= kCFScreenWidth) {
//            xbegin = (screenWidth - kCFScreenWidth) / 2;
//            screenHeight = kCFScreenHeight;
//            ybegin = 0;
//        } else {
//            xbegin = 0;
//            ybegin = (screenHeight - kCFScreenHeight) / 2;
//            screenWidth = kCFScreenWidth;
//        }
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self->_videoView.frame = CGRectMake(-xbegin, -ybegin,screenWidth , screenHeight);
//                self->_videoView.hidden = NO;
//                [self.smartPlayer SmartPlayerSetPlayView:(__bridge void *)(self->_videoView)];
//
//            });
//        });
//
//        lable = Local_String(@"event_video_resolution");
//        player_event = [lable stringByAppendingFormat:@"%@*%@", str_w, str_h];
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_NO_MEDIADATA_RECEIVED)
//    {
//        player_event = Local_String(@"event_no_rtmp_data");
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_SWITCH_URL)
//    {
//        player_event = Local_String(@"event_change_url");
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_CAPTURE_IMAGE)
//    {
////        if ((int)param1 == 0)
////        {
////            NSLog(@"[event]快照成功: %@", param3);
////            lable = @"[event]快照成功:";
////            player_event = [lable stringByAppendingFormat:@"%@", param3];
////
////            tmp_path_ = param3;
////
////            image_path_ = [ UIImage imageNamed:param3];
////
////            UIImageWriteToSavedPhotosAlbum(image_path_, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
////        }
////        else
////        {
////            lable = @"[event]快照失败";
////            player_event = [lable stringByAppendingFormat:@"%@", param3];
////        }
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_RECORDER_START_NEW_FILE)
//    {
//        lable = Local_String(@"event_write_new_files");
//        player_event = [lable stringByAppendingFormat:@"%@", param3];
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_ONE_RECORDER_FILE_FINISHED)
//    {
//        lable = Local_String(@"event_video_file_recorded");
//        player_event = [lable stringByAppendingFormat:@"%@", param3];
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_START_BUFFERING)
//    {
////        NSLog(@"[event]开始buffer..");
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_BUFFERING)
//    {
////        NSLog(@"[event]buffer百分比: %lld", param1);
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_STOP_BUFFERING)
//    {
////        NSLog(@"[event]停止buffer..");
//    }
//    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_DOWNLOAD_SPEED)
//    {
//
//        NSInteger speed_kbps = (NSInteger)param1*8/1000;
//        NSInteger speed_KBs = (NSInteger)param1/1024;
//
////        if (self.smartPlayer) {
////            NSArray *arr = @[@8000,@8000,@8000,@8000,@7000,@7000,@6000,@6000,@5000,@4000];
////            NSInteger current_buff = 0;
////            NSInteger index = speed_KBs / 20;
////            if (index>=10) {//100K及其以上
////                current_buff = 3000;
////            }else{
////                current_buff = [arr[index] intValue];
////            }
////
////            if (current_buff != buffer_time_) {//不要重复设置
////                buffer_time_ = current_buff;
////                [self.smartPlayer SmartPlayerSetBuffer:buffer_time_];
////            }
////        }
//        lable = Local_String(@"[event]download speed :");
//        player_event = [lable stringByAppendingFormat:@"%ld kbps - %ld KB/s", (long)speed_kbps, (long)speed_KBs];
//    }
//    else if(nID == EVENT_DANIULIVE_ERC_PLAYER_RTSP_STATUS_CODE)
//    {
//
//    }
//    else if(nID == EVENT_DANIULIVE_ERC_PLAYER_NEED_KEY)
//    {
//        player_event = Local_String(@"event_please_set_key");
//    }
//    else if(nID == EVENT_DANIULIVE_ERC_PLAYER_KEY_ERROR)
//    {
//        player_event = Local_String(@"event_key_error_please_reset");
//    }
//    else{
////        NSLog(@"[event]nID:%lx", (long)nID);
//    }
//    NSString* player_event_tag = Local_String(@"current_state");
//    NSString* event = [player_event_tag stringByAppendingFormat:@"%@", player_event];
//
////    kNSLog(@"%@", event);
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.textPlayerEventLabel.text = event;
//            [self.playerSubject sendNext:@{@"EvtID": @(nID), @"param":@{@"speed":[NSNumber numberWithLong:param1]}}];
//        });
//    });
//
//
//
//
//    return 0;
//}
//
//
//
//- (void)onNetStatus:(NSDictionary *)param {
//    [self.netSubject sendNext:param];
//    //    NSLog(@"onNetStatus===%@",param);
//}
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
