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
        frame.origin.y += UIScreen.topBarHeight;
        frame.size.height -= UIScreen.topBarHeight;
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
    
    if (self.imageUrl.length > 0) {
        
        //[HProgressHUD showLoadingWithStatus:@"加载中..."];
        
        if ([self.imageUrl hasSuffix:@"http"]) {
            self.webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl]];
            [self.webview loadRequest:request];
        }else {
            NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"HWebImageViewHtml.html" ofType:nil];
            NSURL *url = [[NSURL alloc] initWithString:htmlPath];
            [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.bounds;
    frame.origin.y += UIScreen.topBarHeight;
    frame.size.height -= UIScreen.topBarHeight;
    [self.webview setFrame:frame];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.imageUrl.length > 0) {
        if ([self.imageUrl hasSuffix:@"http"]) {
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
            NSString *imagePath = [[NSBundle mainBundle] resourcePath];
            //加载工程内的图片
            imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
            NSString *tmpImageUrl = self.imageUrl;
            if (![tmpImageUrl containsString:@"."]) {
                UIImage *image = [UIImage imageNamed:tmpImageUrl];
                if (image) {
                    NSData *data = UIImagePNGRepresentation(image);
                    if (data) {
                        NSString *imageType = [self contentTypeForImageData:data];
                        if (imageType) {
                            tmpImageUrl = [tmpImageUrl stringByAppendingString:@"."];
                            tmpImageUrl = [tmpImageUrl stringByAppendingString:imageType];
                        }
                    }
                }
            }
            if (imagePath && tmpImageUrl) {
                imagePath = [NSString stringWithFormat:@"file:/%@//%@",imagePath, tmpImageUrl];
                //注入js
                NSString *js = [NSString stringWithFormat:@"document.images[0].src='%@'",imagePath];
                [webView stringByEvaluatingJavaScriptFromString:js];
            }
        }
    }
    
    if (![self.view.subviews containsObject:self.webview]) {
        [self.view addSubview:self.webview];
        //[HProgressHUD dismiss];
    }
}

//通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];

    switch(c) {
        case 0xFF:
            return @"jpg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
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
            frame.origin.y += UIScreen.topBarHeight;
            frame.size.height -= UIScreen.topBarHeight;
            [self.webview setFrame:frame];
        }
            break;
        default:
            break;
    }
}

@end
