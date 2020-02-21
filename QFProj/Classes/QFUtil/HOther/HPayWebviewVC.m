
//
//  HPayWebviewVC.m
//  QFProj
//
//  Created by dqf on 2018/10/3.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HPayWebviewVC.h"
#import <WebKit/WebKit.h>
#import <CoreImage/CoreImage.h>
#import "HWebImageView.h"
#import "Masonry.h"

@interface HPayWebviewVC () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic) WKWebView *wkWebview;
@property (nonatomic) HWebImageView *webImageView;
@end

@implementation HPayWebviewVC

//- (WKWebView *)wkWebview {
//    if (!_wkWebview) {
//        CGRect frame = self.view.frame;
//        frame.origin.y += kTopBarHeight;
//        frame.size.height -= kTopBarHeight;
//        _wkWebview = [[WKWebView alloc] initWithFrame:frame];
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        config.preferences = [[WKPreferences alloc] init];
//        config.preferences.minimumFontSize = 10;
//        config.preferences.javaScriptEnabled = true;
//        _wkWebview.backgroundColor = [HSkinManager vcBgViewColor];
//        _wkWebview.UIDelegate = self;
//        _wkWebview.navigationDelegate = self;
//    }
//    return _wkWebview;
//}
//
//- (HWebImageView *)webImageView {
//    if (!_webImageView) {
//        CGRect frame = self.view.frame;
//        frame.origin.y += kTopBarHeight + 70;
//        frame.size.height = 150;
//        _webImageView = [[HWebImageView alloc] initWithFrame:frame];
//        [_webImageView.imageView setContentMode:UIViewContentModeCenter];
//        _webImageView.backgroundColor = [HSkinManager vcBgViewColor];
//        [self.view addSubview:_webImageView];
//    }
//    return _webImageView;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [HProgressHUD dismiss];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[HSkinManager vcBgViewColor]];
//    [self.topBar setBackgroundColor:[HSkinManager naviBarColor]];
//    [self setLeftNaviImage:[UIImage imageNamed:@"top_Back_pre"]];
//    [self.titleLabel setText:self.titleText];
//
//    [HProgressHUD showLoadingWithStatus:@"加载中..."];
//
//    if (self.qrCodeUrl) {
//        [self generateQRCode:self.qrCodeUrl];
//    }else if(!self.htmlurl){
//        [self.wkWebview loadHTMLString:self.htmlcontent baseURL:nil];
//    }else{
//        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.htmlurl]];
//        [self.wkWebview loadRequest:request];
//    }
//}
//
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    CGRect frame = self.view.frame;
//    frame.origin.y += kTopBarHeight;
//    frame.size.height -= kTopBarHeight;
//    if (!self.qrCodeUrl) {
//        [self.wkWebview setFrame:frame];
//    }
//}
//
//- (void)generateQRCode:(NSString *)qrCode {
//    if (!qrCode) return;
//
//    //生成二维码
//    // 1. 创建一个二维码滤镜实例(CIFilter)
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//
//    // 滤镜恢复默认设置
//    [filter setDefaults];
//
//
//    // 2. 给滤镜添加数据
//    NSData *data = [qrCode dataUsingEncoding:NSUTF8StringEncoding];
//    [filter setValue:data forKeyPath:@"inputMessage"];
//
//
//    // 3. 生成高清二维码
//    CIImage *image = [filter outputImage];
//    CGAffineTransform transform = CGAffineTransformMakeScale(2.0f, 2.0f);
//    CIImage *output = [image imageByApplyingTransform:transform];
//
//    UIImage *newImage = [self createNonInterpolatedUIImageFormCIImage:output withSize:150];
//    [self.webImageView setImage:newImage];
//
//    //添加子view
//    [self setup];
//
//    [HProgressHUD dismiss];
//
//}
//
//- (void)setup {
//    [self.view setBackgroundColor:[UIColor blackColor]];
//    [self.webImageView setBackgroundColor:[UIColor blackColor]];
//
//    UIView *bgView = [[UIView alloc] init];
//    [bgView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(kTopBarHeight + 70 + 150 + 50);
//        make.left.mas_equalTo(15);
//        make.width.mas_equalTo(self.view);
//        make.height.mas_equalTo(500);
//
//    }];
//
//    NSString *platCode1 = [kPlatCode uppercaseString];
//    NSString *platCode2 = [kPlatCode lowercaseString];
//    NSString *userName = @"";
//    if (platCode1.length > 0 && self.qruser_name.length >= platCode1.length) {
//        userName = [self.qruser_name substringToIndex:platCode1.length];
//        if ([userName isEqualToString:platCode1]) {
//            userName = [self.qruser_name substringFromIndex:platCode1.length];
//        }else if ([userName isEqualToString:platCode2]) {
//            userName = [self.qruser_name substringFromIndex:platCode2.length];
//        }
//    }
//    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.text = [NSString stringWithFormat:@"用户名：%@", userName];
//    nameLabel.font = [UIFont systemFontOfSize:14.0];
//    nameLabel.textColor = [UIColor whiteColor];
//    [bgView addSubview:nameLabel];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(bgView);
//        make.height.mas_equalTo(20);
//    }];
//
//    UILabel *amountLabel = [[UILabel alloc] init];
//    amountLabel.text = [NSString stringWithFormat:@"金额：%@",self.qracount];
//    amountLabel.font = [UIFont systemFontOfSize:14.0];
//    amountLabel.textColor = [UIColor whiteColor];
//    [bgView addSubview:amountLabel];
//    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(nameLabel.mas_right).offset(50);
//        make.centerY.equalTo(nameLabel);
//        make.height.mas_equalTo(20);
//    }];
//
//    UILabel *orderLabel = [[UILabel alloc] init];
//    orderLabel.text = [NSString stringWithFormat:@"订单号：%@",self.qrorder_no];
//    orderLabel.font = [UIFont systemFontOfSize:14.0];
//    orderLabel.textColor = [UIColor whiteColor];
//    [bgView addSubview:orderLabel];
//    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(nameLabel.mas_bottom).offset(10);
//        make.left.equalTo(bgView);
//        make.height.mas_equalTo(20);
//    }];
//    if ([self.titleText isEqualToString:@"支付宝支付"]) {
//        UILabel *tipLabel = [[UILabel alloc] init];
//        tipLabel.text = @" 二维码仅本次支付有效，不可重复使用";
//        tipLabel.font = [UIFont systemFontOfSize:14.0];
//        tipLabel.textColor = [UIColor redColor];
//        [bgView addSubview:tipLabel];
//        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(orderLabel.mas_bottom).offset(30);
//            make.left.equalTo(bgView);
//            make.height.mas_equalTo(20);
//        }];
//
//        UITextView *textView = [[UITextView alloc] init];
//        textView.textColor = [UIColor redColor];
//        textView.font = [UIFont systemFontOfSize:14];
//        textView.backgroundColor = [UIColor clearColor];
//
//        textView.text = @"(1)截屏二维码。\n(2)打开支付宝点击扫一扫。\n(3)点击右上角相册，选择截屏的二维码。\n(4)支持用另外一台手机扫码。\n(5)如果出现风险提示退出在请重新扫描二维码。\n(6)输错金额或重复扫描都会导致上分失败，请各位玩家注意。";
//        textView.userInteractionEnabled = NO;
//        textView.scrollEnabled = NO;
//
//
//        [bgView addSubview:textView];
//
//        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(tipLabel.mas_bottom).offset(10);
//            make.left.equalTo(bgView);
//            make.bottom.equalTo(bgView);
//            make.right.equalTo(bgView);
//        }];
//    }else
//    {
//    UILabel *tipLabel = [[UILabel alloc] init];
//    tipLabel.text = @"注意：";
//    tipLabel.font = [UIFont systemFontOfSize:17.0];
//    tipLabel.textColor = [UIColor whiteColor];
//    [bgView addSubview:tipLabel];
//    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(orderLabel.mas_bottom).offset(30);
//        make.left.equalTo(bgView);
//        make.height.mas_equalTo(20);
//    }];
//
//
//    UILabel *tipLabel2 = [[UILabel alloc] init];
//    tipLabel2.text = @"(1) 二维码只可支付一次，请不要重复支付！！！";
//    tipLabel2.font = [UIFont systemFontOfSize:14.0];
//    tipLabel2.textColor = [UIColor whiteColor];
//    [tipLabel2 setNumberOfLines:0];
//    [bgView addSubview:tipLabel2];
//    [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(tipLabel.mas_bottom).offset(5);
//        make.left.equalTo(bgView);
//        make.height.mas_equalTo(20);
//    }];
//
//    UILabel *tipLabel3 = [[UILabel alloc] init];
//    tipLabel3.text = @"(2) 请截图保存到相册，在【微信】中扫一扫-照片。";
//    tipLabel3.font = [UIFont systemFontOfSize:14.0];
//    tipLabel3.textColor = [UIColor whiteColor];
//    [tipLabel3 setNumberOfLines:0];
//    [bgView addSubview:tipLabel3];
//    [tipLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(tipLabel2.mas_bottom).offset(5);
//        make.left.equalTo(bgView);
//        make.height.mas_equalTo(20);
//    }];
//    }
//}
//
///**
// *  根据CIImage生成指定大小的UIImage
// *
// *  @param image CIImage
// *  @param size  图片宽度
// */
//- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//
//    // 1.创建bitmap;
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//
//    // 2.保存bitmap到图片
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
//}
//
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//    NSString *scheme = [navigationAction.request.URL scheme];
//    NSURL *requestURL = [navigationAction.request URL];
//    NSString *urlStr = [requestURL absoluteString];
//
//    NSDictionary *resultDict = nil;
//
//    NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//    if (bundleIdentifier) {
//        HKeyChainStore *keyChainStore = [HKeyChainStore keyChainStoreWithService:bundleIdentifier];
//        NSData *cachedData = [keyChainStore dataForKey:bundleIdentifier];
//        if (cachedData) {
//            resultDict = [cachedData dictionary];
//        }else {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kFilePath]];
//            resultDict = [data dictionary];
//        }
//    }
//
//    NSArray *pays = nil;
//    if (resultDict && [resultDict isKindOfClass:NSDictionary.class] && resultDict.count > 0) {
//        pays = [resultDict objectForKey:@"pay_url"];
//    }
//
//    NSArray *schemes = @[@"https", @"weixin", @"alipays"];
//
//    if (pays && [pays isKindOfClass:NSArray.class] && [schemes containsObject:scheme]) {
//
//        for (int i=0; i<[pays count]; i++) {
//
//            NSString *pay = [pays objectAtIndex:i];
//
//            if ([urlStr rangeOfString:pay].location != NSNotFound) {
//                [[UIApplication sharedApplication] openURL:requestURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];
//                decisionHandler(WKNavigationActionPolicyCancel);
//                return ;
//            }
//        }
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self.view addSubview:self.wkWebview];
//    [HProgressHUD dismiss];
//}
//
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    [HProgressHUD dismiss];
//}

@end
