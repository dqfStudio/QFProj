//
//  HOther.m
//  QFProj
//
//  Created by dqf on 2019/4/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HOther.h"
#import "HUserDefaults.h"

@implementation HOther

- (void)fasd {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self loadConfigAction];
    }];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperations:@[operation] waitUntilFinished:YES];
}

- (void)loadConfigAction {
//
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//
//    dispatch_async(dispatch_queue_create(0, 0), ^{
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_queue_create(0, 0), ^{
//            dispatch_semaphore_signal(sema);
//        });
//
//        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [sessionConfiguration setRequestCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//        [[session dataTaskWithURL:[NSURL URLWithString:kFilePath] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
//
//            __block NSDictionary *resultDict = nil;
//
//            void (^HJsonConfigBlock)(void) = ^(void) {
//                if (resultDict && [resultDict isKindOfClass:NSDictionary.class] && resultDict.count > 0) {
//                    [[HUserDefaults defaults] setBaseLink:[[resultDict objectForKey:@"navture_url"] stringValue]];
//                    NSString *h5_url = [[resultDict objectForKey:@"app_url"] stringValue];
//                    NSString *urlStr = [h5_url stringByReplacingOccurrencesOfString:@"?app=true" withString:@""];
//                    [[HUserDefaults defaults] setH5Link:urlStr];
//                    [[HUserDefaults defaults] setPlatCodeLink:[[resultDict objectForKey:@"plat_code"] stringValue]];
//                    [[HUserDefaults defaults] setSrc1Link:[[resultDict objectForKey:@"src1"] stringValue]];
//                    // 保存客服联系方式
//                    [[HUserDefaults defaults] setContacts:[resultDict objectForKey:@"contacts"]];
//                }
//            };
//
//            if (data) {
//                resultDict = [data dictionary];
//                if ([resultDict isKindOfClass:NSDictionary.class] && resultDict.count > 0) {
//                    //缓存Json配置
//                    HJsonConfigBlock();
//
//                    //将信息保存在钥匙串中
//                    NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//                    if (bundleIdentifier) {
//                        HKeyChainStore *keyChainStore = [HKeyChainStore keyChainStoreWithService:bundleIdentifier];
//                        [keyChainStore setData:data forKey:bundleIdentifier];
//                        [keyChainStore synchronizable];
//                    }
//
//                    //版本更新
//                    [HUpdate share].version  = [resultDict objectForKey:@"versionname"];
//                    [HUpdate share].isUpdate = [resultDict objectForKey:@"update"];
//                    [HUpdate share].downUrl  = [resultDict objectForKey:@"ios_download"];
//                    [HUpdate share].content  = [resultDict objectForKey:@"content"];
//                    //                    [[HUpdate share] update];
//                }
//            }
//#if DEBUG
//            BOOL jsonSucccess = NO;
//            NSString *baselink = @"https://m.xht111.com/XHD/";
//            if (resultDict && [resultDict isKindOfClass:NSDictionary.class] && resultDict.count > 0) {
//                jsonSucccess = YES;
//            }
//            if (!jsonSucccess) {
//                [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请求json数据失败!" style:UIAlertControllerStyleAlert cancelButtonTitle:@"确定" otherButtonTitles:nil completion:nil];
//            }else if (![baselink isEqualToString:[HUserDefaults defaults].baseLink]) {
//                [UIAlertController showAlertWithTitle:@"温馨提示" message:@"json数据已改变，请及时修改硬编码，谢谢!" style:UIAlertControllerStyleAlert cancelButtonTitle:@"确定" otherButtonTitles:nil completion:nil];
//            }
//#endif
//            //此处为硬编码，发包的时候可适当关注对比一下与服务端的配置是否一致
//            [self loadLocalData];
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self checkLuckyDrawStatus];
//                [self loadData];
//                [self loadSowingMapData];
//            });
//
//            dispatch_semaphore_signal(sema);
//
//        }] resume];
//        //此处为硬编码，发包的时候可适当关注对比一下与服务端的配置是否一致
//        [self loadLocalData];
//    });
//
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)loadLocalData {
//    if (![HUserDefaults defaults].baseLink) {
//        NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//        if (bundleIdentifier) {
//            HKeyChainStore *keyChainStore = [HKeyChainStore keyChainStoreWithService:bundleIdentifier];
//            NSData *cachedData = [keyChainStore dataForKey:bundleIdentifier];
//            if (cachedData) {
//                NSDictionary *resultDict = [cachedData dictionary];
//                if (resultDict && [resultDict isKindOfClass:NSDictionary.class] && resultDict.count > 0) {
//                    [[HUserDefaults defaults] setBaseLink:[[resultDict objectForKey:@"navture_url"] stringValue]];
//                    NSString *h5_url = [[resultDict objectForKey:@"app_url"] stringValue];
//                    NSString *urlStr = [h5_url stringByReplacingOccurrencesOfString:@"?app=true" withString:@""];
//                    [[HUserDefaults defaults] setH5Link:urlStr];
//                    [[HUserDefaults defaults] setPlatCodeLink:[[resultDict objectForKey:@"plat_code"] stringValue]];
//                    [[HUserDefaults defaults] setSrc1Link:[[resultDict objectForKey:@"src1"] stringValue]];
//                    // 保存客服联系方式
//                    [[HUserDefaults defaults] setContacts:[resultDict objectForKey:@"contacts"]];
//                }
//            }
//
//            if ([HUserDefaults defaults].baseLink.length < 3 ) {
//                [[HUserDefaults defaults] setBaseLink:@"https://m.xht111.com/XHD/"];
//            }
//            if ([HUserDefaults defaults].h5Link.length < 3 ) {
//                [[HUserDefaults defaults] setH5Link:@"https://m.xht111.com/"];
//            }
//            if ([HUserDefaults defaults].platCodeLink.length < 3 ) {
//                [[HUserDefaults defaults] setPlatCodeLink:@"XHD"];
//            }
//            if ([HUserDefaults defaults].src1Link.length < 3 ) {
//                [[HUserDefaults defaults] setSrc1Link:@"XHD"];
//            }
//        }
//    }
    
//    if ([HUserDefaults defaults].contacts.count <= 0) {
//        [[HUserDefaults defaults] setDefaultCustomInfo];
//    }
//    //set base url
//    if (HEADBASEINURL.length > 0) {
//        [[YTKNetworkConfig sharedConfig] setBaseUrl:HEADBASEINURL];
//    }
}



//- (void)loginBtnClick:(HWebButtonView *)btn {
//    self.loginDict[@"cagent"] = kPlatCode;
//    self.loginDict[@"savelogin"] = @"1";
//    self.loginDict[@"isImgCode"] = @"0";
//    self.loginDict[@"isMobile"] = @"3";
//    [HProgressHUD showLoadingWithStatus:@"正在登录..."];
//    void (^HLoginBlock)(void) = ^(void) {
//        [[HUserDefaults defaults] setIsLogin:YES];
//        [HProgressHUD showSuccessWithStatus:@"登陆成功"];
//        [self back];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"KMenuSelectedIndexNotify" object:@(0)];
//    };
//    [[HNetworkManager shareManager] sendHTTPDataWithBaseURL:HEADBASEINURL andAppendURL:kLogin RequestWay:kPOST withParamters:self.loginDict withToken:nil success:^(BOOL isSuccess, id responseObject) {
//        //查询一次用户信息.补全登录返回用户信息不全的问题
//        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
//            [[HNetworkManager shareManager] queryUserInfo:^(NSString *error) {
//                if (!error) {
//                    HLoginBlock();
//                }else {
//                    NSString *userName = self.loginDict[@"tname"];
//                    if (userName.length > 3 && [[HUserDefaults defaults] LoadKeyChainDataWith:userName pwd:self.loginDict[@"tpwd"]]) {
//                        HLoginBlock();
//                    }else {
//                        [HProgressHUD showErrorWithStatus:@"登录失败!"];
//                    }
//                }
//                [btn.button setEnabled:YES];
//            }];
//        }else {
//            NSString *msg = responseObject[@"errmsg"];
//            if (!msg) msg = @"登录失败!";
//            [HProgressHUD showErrorWithStatus:msg];
//            [btn.button setEnabled:YES];
//        }
//    } failure:^(NSError *error) {
//        NSString *userName = self.loginDict[@"tname"];
//        if (userName.length > 3 && [[HUserDefaults defaults] LoadKeyChainDataWith:userName pwd:self.loginDict[@"tpwd"]]) {
//            //有网络才让登录
//            AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
//            if (status != AFNetworkReachabilityStatusUnknown && status != AFNetworkReachabilityStatusNotReachable) {
//                HLoginBlock();
//            }else {
//                [HProgressHUD showErrorWithStatus:@"当前无网络！"];
//            }
//        }else {
//            [HProgressHUD showErrorWithStatus:[HTool showErrorInfoWithStatusCode:error.code]];
//        }
//        [btn.button setEnabled:YES];
//    }];
//}

//- (void)request {
//    if (baseURL) {
//        HNetworkDAO *requestDAO = [[HNetworkDAO alloc] initWithUrl:url info:parameters];
//        [requestDAO startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
//            NSDictionary *responseDict = request.responseJSONObject;
//            success(YES, responseDict);
//        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
//            NSString *description = @"服务器离家出走中，请稍后再试!";
//            NSString *domain = @"HURLErrorDomain";
//            NSInteger code = -1000;
//            NSError *error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
//            failure(error);
//        }];
//    }else {
//        success(NO, nil);
//    }
//}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

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
//                return;
//            }
//        }
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

//- (void)addSpecialItem {
//    self.registerItem = [YPTabItem buttonWithType:UIButtonTypeCustom];
//    [RACObserve([HUserDefaults defaults], isLogin) subscribeNext:^(NSNumber *x) {
//        if (x.integerValue == 0) {
//            self.registerItem.title = @"注册";
//            self.registerItem.image = [UIImage imageNamed:@"di_zhuce"];
//            self.registerItem.selectedImage = [UIImage imageNamed:@"di_zhuce"];
//        }else {
//            self.registerItem.title = @"存款";
//            self.registerItem.image = [UIImage imageNamed:@"di_cunkuan"];
//            self.registerItem.selectedImage = [UIImage imageNamed:@"di_cunkuan"];
//        }
//    }];
//    self.registerItem.titleColor = [HSkinManager specialColor2];
//    self.registerItem.titleSelectedColor = [HSkinManager specialColor2];
//    self.registerItem.backgroundColor = [UIColor clearColor];
//    self.registerItem.titleFont = [UIFont systemFontOfSize:14];
//
//    [self.registerItem setContentHorizontalCenterWithVerticalOffset:13 spacing:10];
//    // 设置其size，如果不设置，则默认为与其他item一样
//    self.registerItem.size = CGSizeMake([UIScreen width]/5, 80);
//    // 高度大于tabBar，所以需要将此属性设置为NO
//    self.tabBar.clipsToBounds = NO;
//    //加间隔线
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.width, 1)];
//    [lineView setBackgroundColor:[HSkinManager lineColor]];
//    [self.tabBar addSubview:lineView];
//    [self.tabBar sendSubviewToBack:lineView];
//
//    @www
//    [self.tabBar setSpecialItem:self.registerItem
//             afterItemWithIndex:1
//                     tapHandler:^(YPTabItem *item) {
//                         @sss
//                         if (![HUserDefaults defaults].isLogin) {
//                             HNavigationController *registerVC = [[HNavigationController alloc] initWithRootViewController:HRegisterController.new];
//                             [self presentViewController:registerVC animated:YES completion:nil];
//                         }else {
//                             [self.navigationController pushViewController:HDepositVC.new animated:YES];
//                         }
//                     }];
//}

//#pragma mark - 崩溃日志收集
//
////获取当前控制器信息
//- (NSString *)currentVCInfo {
//
//    HViewController *visibleVC = (HViewController *)self.mainPage.visibleViewController;
//    HViewController *currentVC = nil;
//    Protocol *pro = NSProtocolFromString(@"YPTabContentViewDelegate");
//    NSString *selectIndex= nil;
//    if ([visibleVC conformsToProtocol:pro]) {
//
//        HMenuViewController *rootVC= (HMenuViewController *)visibleVC;
//        NSInteger index = rootVC.tabBar.selectedItemIndex;
//        HViewController *selectVC  = (HViewController *)rootVC.viewControllers[index];
//        if ([selectVC conformsToProtocol:pro]) {
//            HMenuViewController *rootVC2 = (HMenuViewController *)selectVC;
//            NSInteger  index = rootVC2.tabBar.selectedItemIndex;
//            HViewController *selectVC2 = (HViewController *)rootVC2.viewControllers[index];
//            if ([selectVC2 isKindOfClass:[UINavigationController class]]) {
//                UINavigationController *nav = (UINavigationController *)selectVC2;
//                currentVC = nav.viewControllers.firstObject;
//            }else {
//                currentVC = selectVC2;
//            }
//        }else {
//            currentVC = selectVC;
//        }
//        selectIndex = [NSString stringWithFormat:@"%lu",index];
//    }else {
//        currentVC = visibleVC;
//    }
//    return  [NSString stringWithFormat:@"__%@__%@__%@",currentVC.titleLabel.text,NSStringFromClass([currentVC class]),selectIndex];
//}
//
//+ (void)crashCollection {
//#if !DEBUG
//    //崩溃日志捕捉
//    InstallCrashExceptionHandler();
//    [[GHWEmailManager shareInstance] configWithFromEmail:@"txwinding@gmail.com"
//                                              andPasswod:@"a.000000"
//                                              andToEmail:@"txwinding@gmail.com"
//                                            andRelayHose:@"smtp.gmail.com"];
//    //真机发送崩溃记录
//    if (!TARGET_IPHONE_SIMULATOR) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
//                                   stringByAppendingPathComponent:@"crash"];
//            NSString *message = nil;
//            if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
//                message = [NSString stringWithContentsOfFile:cachePath encoding:NSUTF8StringEncoding error:nil];
//            }
//            if (message.length > 0) {
//                [[GHWEmailManager shareInstance] sendEmail:message];
//            }
//        });
//    }
//#endif
//}

//[self.sfvc performSelector:NSSelectorFromString(@"_setShowingLinkPreview:") withObject:[NSNumber numberWithBool:YES]];

//- (void)sendHTTPDataWithBaseURL:(NSString *)baseURL andAppendURL:(NSString *)url RequestWay:(NSString *)way
//                  withParamters:(NSDictionary *)parameters
//                      withToken:(NSString *)token
//                        success:(void(^)(BOOL isSuccess, id responseObject))success
//                        failure:(void(^)(NSError *error))failure {
//
//
//    AFHTTPSessionManager *sessionManager = [[YTKNetworkAgent sharedAgent] manager];
//    __block AFHTTPSessionManager *sessionManagerBlock = sessionManager;
//    [sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *_Nonnull(NSURLSession *_Nonnull session, NSURLSessionTask *_Nonnull task, NSURLResponse *_Nonnull response, NSURLRequest *_Nonnull request)
//     {
//         //这里可以重新修改重新向后的请求方式和参数。
//         if (request) {
//             NSString *platCode = [HUserDefaults defaults].platCodeLink;
//             NSString *baseLink = nil;
//             NSString *h5Link = nil;
//             if (platCode) {
//                 platCode = [platCode stringByAppendingString:@"/"];
//                 NSString *absoluteString = request.URL.absoluteString;
//                 if (absoluteString) {
//                     //set base link
//                     NSRange range = [absoluteString rangeOfString:platCode];
//                     if (range.location != NSNotFound) {
//                         if (absoluteString.length >= range.location+range.length) {
//                             baseLink = [absoluteString substringToIndex:range.location+range.length];
//                             [[HUserDefaults defaults] setBaseLink:baseLink];
//                             [[YTKNetworkConfig sharedConfig] setBaseUrl:baseLink];
//                         }
//                         //set h5 link
//                         if (absoluteString.length >= range.location) {
//                             h5Link = [absoluteString substringToIndex:range.location];
//                             [[HUserDefaults defaults] setH5Link:h5Link];
//                         }
//                     }
//                 }
//             }
//             //set h5 link
//             if (!h5Link) {
//                 h5Link = [HUserDefaults defaults].h5Link;
//             }
//             NSMutableURLRequest *mutRequest = [sessionManagerBlock.requestSerializer requestWithMethod:way URLString:request.URL.absoluteString parameters:parameters error:nil];
//             [mutRequest addValue:h5Link forHTTPHeaderField:@"referer"];
//
//             return mutRequest;
//         }
//         return nil;
//
//     }];
//
//    if (baseURL) {
//        HNetworkDAO *requestDAO = [[HNetworkDAO alloc] initWithUrl:url info:parameters];
//        [requestDAO startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
//            NSDictionary *responseDict = request.responseJSONObject;
//            success(YES, responseDict);
//        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
//            NSString *description = @"服务器离家出走中，请稍后再试!";
//            NSString *domain = @"HURLErrorDomain";
//            NSInteger code = -1000;
//            NSError *error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
//            failure(error);
//        }];
//
//    }else {
//        success(NO, nil);
//    }
//
//}

@end
