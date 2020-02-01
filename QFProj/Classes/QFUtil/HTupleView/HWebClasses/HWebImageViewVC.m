//
//  HWebImageViewVC.m
//  QFProj
//
//  Created by wind on 2020/2/1.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HWebImageViewVC.h"
#import <WebKit/WebKit.h>

@interface HWebImageViewVC () <UIWebViewDelegate>
@property (nonatomic) UIWebView *webview;
@end

@implementation HWebImageViewVC

- (UIWebView *)webview {
    if (!_webview) {
        CGRect frame = self.view.bounds;
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
        _webview = [[UIWebView alloc] initWithFrame:frame];
        _webview.backgroundColor = UIColor.clearColor;
        [_webview setScalesPageToFit:YES];
        [_webview setDelegate:self];
    }
    return _webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.topBar setBackgroundColor:UIColor.whiteColor];

    /*
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleDeviceOrientationChange:)
                                                name:UIDeviceOrientationDidChangeNotification
                                              object:nil];
    */

    //[HProgressHUD showLoadingWithStatus:@"加载中..."];
    
    if (self.imageUrl.length > 0) {
        self.webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl]];
        [self.webview loadRequest:request];
    }

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.bounds;
    frame.origin.y += UIDevice.topBarHeight;
    frame.size.height -= UIDevice.topBarHeight;
    [self.webview setFrame:frame];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //去掉页面标题
    if (self.imageUrl.length > 0) {
        //根据标签类型获取指定标签的元素
        NSMutableString *str = [NSMutableString string];
        [str appendString:@"var header = document.getElementsByClassName(\"TopHeader\")[0];"];
        //移除头部的导航栏
        [str appendString:@"header.style.display = 'none';"];
        [webView stringByEvaluatingJavaScriptFromString:str];
        //解决界面卡顿的问题
        str = [NSMutableString string];
        [str appendString:@"document.getElementsByClassName(\"publicpage\")[0].style.cssText += '-webkit-overflow-scrolling:touch'"];
        [webView stringByEvaluatingJavaScriptFromString:str];
    }
    
    if (![self.view.subviews containsObject:self.webview]) {
        [self.view addSubview:self.webview];
        //[HProgressHUD dismiss];
    }
}

#pragma mark - notification method
- (void)handleDeviceOrientationChange:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight: {
            self.topBar.hidden = YES;
            [self.webview setFrame:self.view.frame];
        }
            break;
        case UIDeviceOrientationPortrait: {
            self.topBar.hidden = NO;
            CGRect frame = self.view.frame;
            frame.origin.y += UIDevice.topBarHeight;
            frame.size.height -= UIDevice.topBarHeight;
            [self.webview setFrame:frame];
        }
            break;
        default:
            break;
    }
}

@end
