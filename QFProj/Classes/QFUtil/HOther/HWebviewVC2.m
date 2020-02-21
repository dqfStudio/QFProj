//
//  HWebviewVC.m
//  QFProj
//
//  Created by dqf on 2018/9/22.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HWebviewVC2.h"
#import <WebKit/WebKit.h>

@interface HWebviewVC2 () <UIWebViewDelegate>
@property (nonatomic) UIWebView *webview;
@end

@implementation HWebviewVC2

- (UIWebView *)webview {
    if (!_webview) {
        CGRect frame = self.view.frame;
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
        _webview = [[UIWebView alloc] initWithFrame:frame];
//        self.webview.backgroundColor = [HSkinManager vcBgViewColor];
        [self.webview setDelegate:self];
    }
    return _webview;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [HProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[HSkinManager vcBgViewColor]];
//    [self.topBar setBackgroundColor:[HSkinManager naviBarColor]];
    [self setLeftNaviImage:[UIImage imageNamed:@"top_Back_pre"]];
    [self.titleLabel setText:self.titleText];
    
    //下面注销的这种方式加载不出来本地图片
//    NSString *path = [[NSBundle mainBundle] pathForResource:[self.htmlFile stringByDeletingPathExtension] ofType:[self.htmlFile pathExtension]];
//    NSString *content = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:nil];
//    [self.webview loadHTMLString:content baseURL:nil];
    
//    [HProgressHUD showLoadingWithStatus:@"加载中..."];
    
    if(self.htmlFile.length > 0){
        NSString *basePath = [[NSBundle mainBundle] bundlePath];
        NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory: YES];
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@", basePath,self.htmlFile];
        NSString *indexContent = [NSString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:nil];
        [self.webview loadHTMLString:indexContent baseURL: baseUrl];
    }else if (self.htmlurl.length > 0) {
        self.webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.htmlurl]];
        [self.webview loadRequest:request];
    }
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.frame;
    frame.origin.y += UIDevice.topBarHeight;
    frame.size.height -= UIDevice.topBarHeight;
    [self.webview setFrame:frame];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //改变字体大小
    //    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"];
    
    //去掉页面标题
    if (self.htmlurl.length > 0) {
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
        
    }else {
        //改变背景颜色
//        NSString *bgColorString = [NSString stringWithFormat:@"document.body.style.backgroundColor = '%@'", [HSkinManager vcBgViewClrString]];
//        [webView stringByEvaluatingJavaScriptFromString:bgColorString];
        //改变字体颜色
//        NSString *textColorString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '%@'", [HSkinManager textClsString]];
//        [webView stringByEvaluatingJavaScriptFromString:textColorString];
    }
    
    if (![self.view.subviews containsObject:self.webview]) {
        [self.view addSubview:self.webview];
//        [HProgressHUD dismiss];
    }
}

@end
