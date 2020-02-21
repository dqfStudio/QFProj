//
//  HGameVC.m
//  QFProj
//
//  Created by dqf on 2018/9/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HWebviewVC.h"
#import <WebKit/WebKit.h>
//#import "UIView+Gradient.h"
//#import <Masonry.h>

@interface HWebviewVC () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic) WKWebView *wkWebview;
@property (nonatomic) NSInteger topHeight;

/**
 保存当前所加载页面的url地址
 */
//@property (nonatomic, copy) NSString *urlStr;

/**
 CQ9电子的大厅按钮
 */
//@property (nonatomic, strong) UIButton *lobbyBtn;

/**
 进度条
 */
@property (nonatomic, strong) UIProgressView *progress;

/**
 需要显示进度条的游戏类型的数组
 */
//@property (nonatomic, strong) NSArray *progressGameTypeArr;

@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation HWebviewVC

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [(HNavigationController *)UIApplication.navi removeFromFullScreenPopBlackList:self];
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [HProgressHUD dismiss];
    
//    UIApplication.appDel.allowRotate = NO;
}

- (void)setHideNaviBar:(BOOL)hideNaviBar {
    if (_hideNaviBar != hideNaviBar) {
        _hideNaviBar = hideNaviBar;
        [self.topBar setHidden:hideNaviBar];
    }
}

- (void)setDisplayProgress:(BOOL)displayProgress {
    if (_displayProgress != displayProgress) {
        _displayProgress = displayProgress;
        if (_displayProgress) {
            [self.wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
            [self.wkWebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        }else {
            [self.wkWebview removeObserver:self forKeyPath:@"estimatedProgress"];
            [self.wkWebview removeObserver:self forKeyPath:@"title"];
        }
    }
}

- (void)setAutorotate:(BOOL)autorotate {
    if (_autorotate != autorotate) {
        _autorotate = autorotate;
        if (_autorotate) {
            if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
                [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            }
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(deviceOrientationChangeEvent:)
                                                         name:UIDeviceOrientationDidChangeNotification
                                                       object:nil];
        }else {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIDeviceOrientationDidChangeNotification
                                                          object:nil];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[HSkinManager vcBgViewColor]];
//    [self.topBar setBackgroundColor:[HSkinManager naviBarColor]];
    if (!_hideNaviBar) {
        [self setLeftNaviImage:[UIImage imageNamed:@"top_Back_pre"]];
    }
//    [self setTitle:@"游戏"];
    
//    self.topHeight = kTopBarHeight;
//    if ([self.progressGameTypeArr containsObject:self.gameType]) {
    
        [self.wkWebview addSubview:self.progress];
//        [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self.wkWebview);
//            make.height.mas_equalTo(2.f);
//        }];
        
        // 为CQ9电子 进入游戏后 增加一个大厅按钮
//        if ([self.gameType isEqualToString:@"CQJ"]) {
//            [self.wkWebview addSubview:self.lobbyBtn];
////            [_lobbyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////                make.top.right.equalTo(self.wkWebview).insets(UIEdgeInsetsMake(10.f, 0.f, 0.f, 15.f));
////                make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
////            }];
//        }
//    }
    
    [self.view addSubview:self.wkWebview];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.wkWebview loadRequest:request];
    
    if ([_gameType isEqualToString:@"TXQP"]) {
        [self.topBar setHidden:YES];
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebview];
        [self.bridge registerHandler:@"exitGame" handler:^(id data, WVJBResponseCallback responseCallback) {
            [self back];
        }];
    } else {
//        if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
//            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//        }
//        [[NSNotificationCenter defaultCenter]addObserver:self
//                                                selector:@selector(deviceOrientationChangeEvent:)
//                                                    name:UIDeviceOrientationDidChangeNotification
//                                                  object:nil];
    }
    
//    [HProgressHUD showLoadingWithStatus:@"加载中，请稍后..."];
//
//    [(HNavigationController *)UIApplication.navi addFullScreenPopBlackListItem:self];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
////    if (!_isTXQP) {
////        UIApplication.appDel.allowRotate = YES;
////    }
//}
//
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    CGRect frame = self.view.frame;
////    if (!_isTXQP) {
//        frame.origin.y += self.topHeight;
//        frame.size.height -= self.topHeight;
////    }
//    [self.wkWebview setFrame:frame];
//}

#pragma mark -- WKUIDelegate
// 显示一个按钮。点击后调用completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 显示两个按钮，通过completionHandler回调判断用户点击的确定还是取消按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 显示一个带有输入框和一个确定按钮的，通过completionHandler回调用户输入的内容
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKNavaigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [HProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSDictionary *errorDic = error.userInfo;
    NSString *urlKey = [errorDic[@"NSErrorFailingURLKey"] absoluteString];
    if (error.code == NSURLErrorCancelled || error.code == 102 || [urlKey containsString:@"no_return"]) {
        return;
    }
    
//    [HProgressHUD showErrorWithStatus:@"游戏加载失败!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self back];
    });
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSArray *decisionArr = @[@"about:blank",
                             @"no_return",
                             @"https://__bridge_loaded__/"];
    if ([decisionArr containsObject:urlStr]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    self.urlStr = navigationResponse.response.URL.absoluteString;
//    NSLog(@"当前跳转地址：%@", _urlStr);
//    if ([self.urlStr isEqualToString:HEADH5BASEINURL]) {
//        [self setNewOrientation:NO];
//
//        [self back];
        // PS电子中子游戏的大厅按钮 会直接调用h5的域名 所以做一个拦截处理
//        decisionHandler(WKNavigationResponsePolicyCancel);
//    } else
//        //允许跳转
        decisionHandler(WKNavigationResponsePolicyAllow);
}

//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSURLCredential* newCredential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    if ([[[challenge protectionSpace]authenticationMethod] isEqualToString:@"NSURLAuthenticationMethodServerTrust"]) {
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
        SecTrustSetExceptions(serverTrust, exceptions);
        CFRelease(exceptions);
        newCredential = [NSURLCredential credentialForTrust:serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, newCredential);
    }else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, newCredential);
    }
}

//防止点击H5中的按钮没有反应
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - notification method
- (void)deviceOrientationChangeEvent:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight: {
            if (!_hideNaviBar) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.topBar.hidden = YES;
                    [self.wkWebview setFrame:self.view.frame];
                }];
            }
        }
            break;
        case UIDeviceOrientationPortrait: {
            [UIApplication sharedApplication].statusBarHidden = NO;
            if (!_hideNaviBar) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.topBar.hidden = NO;
                    CGRect frame = self.view.frame;
                    frame.origin.y += UIDevice.topBarHeight;
                    frame.size.height -= UIDevice.topBarHeight;
                    [self.wkWebview setFrame:frame];
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.wkWebview)
        {
//            NSLog(@"== webview progress  %f", self.wkWebview.estimatedProgress);
            
//            [HProgressHUD dismiss];
            
//            if ([self.progressGameTypeArr containsObject:self.gameType]) {
            
                [self.progress setAlpha:1.0f];
                [self.progress setProgress:self.wkWebview.estimatedProgress animated:YES];
                if(self.wkWebview.estimatedProgress >= 1.0f)
                {
                    [UIView animateWithDuration:0.5f
                                          delay:0.3f
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         [self.progress setAlpha:0.0f];
                                     }
                                     completion:^(BOOL finished) {
                                         [self.progress setProgress:0.0f animated:NO];
                                     }];
//                }
//                if ([self.gameType isEqualToString:@"CQJ"]) {
//                    // CQ9电子进入游戏
//                    if ([self.wkWebview.title isEqualToString:@"Welcome"] || ([self.urlStr containsString:@"?token="] && [self.urlStr containsString:@"language=zh-cn&dollarsign=Y"])) {
//                        if (self.wkWebview.estimatedProgress == 1.0f) {
//                            _lobbyBtn.hidden = NO;
//                        }
//                    }
//                }
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
//        NSLog(@"== webview title  %@", self.wkWebview.title);
//        if ([self.gameType isEqualToString:@"CQJ"]) {
//            if ([self.wkWebview.title isEqualToString:@"Game Lobby"]) {
//                _lobbyBtn.hidden = YES;
//            }
//        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - private method
/**
 强制横竖屏切换
 
 @param fullscreen 是否全屏（横屏时 即为全屏）
 */
- (void)setNewOrientation:(BOOL)fullscreen{
    if (fullscreen) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }else{
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

#pragma mark - over load
- (BOOL)shouldAutorotate {
//    return _isTXQP ? NO : UIApplication.appDel.allowRotate;
    return NO;
}

#pragma mark - lazy load
- (WKWebView *)wkWebview {
    if (_wkWebview == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        //        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = true;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        
        _wkWebview = [[WKWebView alloc] initWithFrame:CGRectZero
                                        configuration:config];
//        _wkWebview.backgroundColor = [HSkinManager vcBgViewColor];
        _wkWebview.UIDelegate = self;
        _wkWebview.navigationDelegate = self;
        if (@available(iOS 11.0, *)) {
            _wkWebview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        
        // KVO方式获取webView的进度条和标题
        [_wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_wkWebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _wkWebview;
}

//- (UIButton *)lobbyBtn
//{
//    if (!_lobbyBtn) {
//        _lobbyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _lobbyBtn.hidden = YES;
////        [_lobbyBtn setGradientBackgroundWithColors:@[[UIColor colorWithString:@"#FEFEFE"], [UIColor colorWithString:@"#D6C1AB"]] locations:nil startPoint:CGPointMake(0.f, 0.f) endPoint:CGPointMake(0.f, 1.f)];
//        [_lobbyBtn setCornerRadius:16.f];
//        [_lobbyBtn setImage:[UIImage imageNamed:@"cq9_lobby"] forState:UIControlStateNormal];
//        @www
//        [_lobbyBtn addSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
//            @sss
//            [self.wkWebview goBack];
//        }];
//    }
//    return _lobbyBtn;
//}

@end
