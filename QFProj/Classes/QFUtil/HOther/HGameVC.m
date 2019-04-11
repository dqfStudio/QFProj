//
//  HGameVC.m
//  HProjectModel1
//
//  Created by txkj_mac on 2018/9/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HGameVC.h"
#import <WebKit/WebKit.h>
//#import "UIView+Gradient.h"
#import <Masonry.h>

@interface HGameVC () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic) WKWebView *wkWebview;
@property (nonatomic) NSInteger topHeight;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIButton *lobbyBtn;
@property (nonatomic, strong) UIProgressView *progress;

@end

@implementation HGameVC

//- (WKWebView *)wkWebview {
//    if (_wkWebview == nil) {
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        config.preferences = [[WKPreferences alloc] init];
//        //        config.preferences.minimumFontSize = 10;
//        config.preferences.javaScriptEnabled = true;
//        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
//
//        _wkWebview = [[WKWebView alloc] initWithFrame:CGRectZero
//                                        configuration:config];
//        //_wkWebview.backgroundColor = [HSkinManager vcBgViewColor];
//        _wkWebview.UIDelegate = self;
//        _wkWebview.navigationDelegate = self;
//
//
//        [self.wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
//        [self.wkWebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
//
//    }
//    return _wkWebview;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [HProgressHUD dismiss];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[HSkinManager vcBgViewColor]];
//
//    [self.topBar setBackgroundColor:[HSkinManager naviBarColor]];
//    [self setLeftNaviImage:[UIImage imageNamed:@"top_Back_pre"]];
//    [self.titleLabel setText:@"游戏"];
//    self.topHeight = kTopBarHeight;
//
//    if ([self.gameType isEqualToString:@"CQJ"]) {
//
//        [self.wkWebview addSubview:self.progress];
//        [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self.wkWebview);
//            make.height.mas_equalTo(2.f);
//        }];
//
//        [self.wkWebview addSubview:self.lobbyBtn];
//        [_lobbyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.equalTo(self.wkWebview).insets(UIEdgeInsetsMake(10.f, 0.f, 0.f, 15.f));
//            make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
//        }];
//    }
//
//    [HProgressHUD showLoadingWithStatus:@"加载中，请稍后..."];
//
//    [self.view addSubview:self.wkWebview];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
//    [self.wkWebview loadRequest:request];
//
//    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    }
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:)
//                                                name:UIDeviceOrientationDidChangeNotification object:nil];
//}
//
//
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    CGRect frame = self.view.frame;
//    frame.origin.y += self.topHeight;
//    frame.size.height -= self.topHeight;
//    [self.wkWebview setFrame:frame];
//}
//
//#pragma mark - WKUIDelegate & WKNavaigationDelegate
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [HProgressHUD dismiss];
//}
//
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    if (error.code == NSURLErrorCancelled) {
//        return;
//    }
//    [HProgressHUD showErrorWithStatus:@"游戏加载失败!"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self back];
//    });
//}
//
//// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//    NSString * urlStr = navigationAction.request.URL.absoluteString;
//    NSLog(@"发送跳转请求：%@",urlStr);
//
//    //如果是跳转一个新页面
//    if (navigationAction.targetFrame == nil) {
//        [webView loadRequest:navigationAction.request];
//    }
//    if ([urlStr isEqualToString:@"about:blank"]) {
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else
//        decisionHandler(WKNavigationActionPolicyAllow);
//}
//
//// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    self.urlStr = navigationResponse.response.URL.absoluteString;
//    NSLog(@"当前跳转地址：%@", _urlStr);
//    //允许跳转
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}
//
////需要响应身份验证时调用 同样在block中需要传入用户身份凭证
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//
//    NSLog(@"== didReceiveAuthenticationChallenge ==");
//
//    NSURLCredential*newCredential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//
//    if ([[[challenge protectionSpace]authenticationMethod] isEqualToString: @"NSURLAuthenticationMethodServerTrust"]) {
//        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
//        CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
//        SecTrustSetExceptions(serverTrust, exceptions);
//        CFRelease(exceptions);
//        newCredential = [NSURLCredential credentialForTrust:serverTrust];
//        completionHandler(NSURLSessionAuthChallengeUseCredential, newCredential);
//    } else {
//        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, newCredential);
//    }
//}
//
////防止点击H5中的按钮没有反应
//-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    NSLog(@"===== createWebViewWithConfiguration ====");
//
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    if (navigationAction.targetFrame == nil) {
//        [webView loadRequest:navigationAction.request];
//    }
//
//    return nil;
//}
//
//#pragma mark - notification method
//- (void)handleDeviceOrientationChange:(NSNotification *)notification {
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    switch (deviceOrientation) {
//        case UIDeviceOrientationLandscapeLeft:
//        case UIDeviceOrientationLandscapeRight:
//        {
//            self.topBar.hidden = YES;
//            self.topHeight = 0;
//            [self.wkWebview setFrame:self.view.frame];
//        }
//            break;
//        case UIDeviceOrientationPortrait:
//        {
//            [UIApplication sharedApplication].statusBarHidden = NO;
//
//            self.topHeight = kTopBarHeight;
//            self.topBar.hidden = NO;
//
//            CGRect frame = self.view.frame;
//            frame.origin.y += self.topHeight;
//            frame.size.height -= self.topHeight;
//            [self.wkWebview setFrame:frame];
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//#pragma mark KVO的监听代理
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//
//    //加载进度值
//    if ([keyPath isEqualToString:@"estimatedProgress"])
//    {
//        if (object == self.wkWebview)
//        {
//            NSLog(@"== webview progress  %f", self.wkWebview.estimatedProgress);
//            if ([self.gameType isEqualToString:@"CQJ"]) {
//
//                [self.progress setAlpha:1.0f];
//                [self.progress setProgress:self.wkWebview.estimatedProgress animated:YES];
//                if(self.wkWebview.estimatedProgress >= 1.0f)
//                {
//                    [UIView animateWithDuration:0.5f
//                                          delay:0.3f
//                                        options:UIViewAnimationOptionCurveEaseOut
//                                     animations:^{
//                                         [self.progress setAlpha:0.0f];
//                                     }
//                                     completion:^(BOOL finished) {
//                                         [self.progress setProgress:0.0f animated:NO];
//                                     }];
//                }
//                // 进入游戏
//                if ([self.wkWebview.title isEqualToString:@"Welcome"] || ([self.urlStr containsString:@"?token="] && [self.urlStr containsString:@"language=zh-cn&dollarsign=Y"])) {
//                    if (self.wkWebview.estimatedProgress == 1.0f) {
//                        _lobbyBtn.hidden = NO;
//                    }
//                }
//            }
//        }
//        else
//        {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//    }
//    //网页title
//    else if ([keyPath isEqualToString:@"title"])
//    {
//        NSLog(@"== webview title  %@", self.wkWebview.title);
//        if ([self.gameType isEqualToString:@"CQJ"]) {
//            if ([self.wkWebview.title isEqualToString:@"Game Lobby"]) {
//                _lobbyBtn.hidden = YES;
//            }
//        }
//    }
//    else
//    {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//#pragma mark - over load
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//#pragma mark - lazy load
//- (UIButton *)lobbyBtn
//{
//    if (!_lobbyBtn) {
//        _lobbyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _lobbyBtn.hidden = YES;
//        [_lobbyBtn setGradientBackgroundWithColors:@[[UIColor colorWithString:@"#FEFEFE"], [UIColor colorWithString:@"#D6C1AB"]] locations:nil startPoint:CGPointMake(0.f, 0.f) endPoint:CGPointMake(0.f, 1.f)];
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
//
//- (UIProgressView *)progress
//{
//    if (!_progress) {
//        _progress = [[UIProgressView alloc] initWithFrame:CGRectZero];
//        _progress.backgroundColor = [HSkinManager naviBarColor];
//        _progress.progressTintColor = [UIColor blueColor];
//        _progress.trackTintColor = [HSkinManager naviBarColor];
//    }
//    return _progress;
//}

@end
