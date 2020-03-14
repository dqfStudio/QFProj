//
//  AppDelegate+ConfigerService.m
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate+ConfigerService.h"
#import <AFNetworking/AFNetworking.h>
#import "UIAlertController+HUtil.h"
#import "HKBKeyboardManager.h"

//#import "GHWEmailManager.h"
//#import "GHWCrashHandler.h"
//#import "KSCrash.h"
//#import "KSCrashInstallation+Alert.h"
//#import "KSCrashInstallationStandard.h"
//#import "KSCrashInstallationQuincyHockey.h"
//#import "KSCrashInstallationEmail.h"
//#import "KSCrashInstallationVictory.h"
//#import "KSCrashReportFilterAppleFmt.h"

@implementation AppDelegate (ConfigerService)

//键盘管理
- (void)setupKeyboardManager {
    //键盘弹出时，点击背景，键盘收回
    [HKBKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    //屏幕隐藏键盘
    [HKBKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    // 控制整个功能是否启用
    [HKBKeyboardManager sharedManager].enable = YES;
}

//- (void)setupCrashCollection {
//    //崩溃日志捕捉
////    InstallCrashExceptionHandler(); //使用KSCrash 日志收集 + 静默邮件上传
//    [[GHWEmailManager shareInstance] configWithFromEmail:@"txwinding@gmail.com"
//                                              andPasswod:@"b@123000"
//                                              andToEmail:@"txwinding@gmail.com"
//                                            andRelayHose:@"smtp.gmail.com"];
//    KSCrashInstallation *installation = [KSCrashInstallationEmail sharedInstance];
//    [(KSCrashInstallationEmail *)installation setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
//
//    [installation install];
//    //[KSCrash sharedInstance].deleteBehaviorAfterSendAll = KSCDeleteOnSucess;
//    // TODO: Remove this 不用框架提供的发送策略、自己管理删除
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        AppDelegate *appl = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appl sendCrashToEmail];
//    });
//}
//- (void)sendCrashToEmail {
//    //真机发送崩溃记录
//    if (!TARGET_IPHONE_SIMULATOR) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            KSCrash *handler = [KSCrash sharedInstance];
//            NSArray *reports = [handler allReports];
//
//            KSCrashReportFilterAppleFmt *fileter = [[KSCrashReportFilterAppleFmt alloc] initWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide];
//
//            NSMutableString *message = [NSMutableString new];
//            for (NSDictionary *dic in reports) {
//                NSString *str = [fileter toAppleFormat:dic];
//                if (message.length == 0) {
//                    [message appendString:str];
//                }else {
//                    [message appendFormat:@"\n新的奔溃日志记录\n%@",str];
//                }
//            }
//
//            if (message.length > 0) {
//                [[GHWEmailManager shareInstance] sendEmail:message];
//
//                [[GHWEmailManager shareInstance] setSendEmailEndBlock:^(BOOL successed) {
//                    if (successed) {
//                         [[KSCrash sharedInstance] deleteAllReports];
//                    }
//                }];
//            }
//        });
//    }
//}

//网络状态监听
- (void)setupAFNReachability {
    //监听网络状态的改变
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [UIAlertController showAlertWithTitle:@"系统提示" message:@"当前为未知网络！" style:UIAlertControllerStyleAlert cancelButtonTitle:@"确定" otherButtonTitles:nil completion:nil];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [UIAlertController showAlertWithTitle:@"系统提示" message:@"当前无网络！" style:UIAlertControllerStyleAlert cancelButtonTitle:@"确定" otherButtonTitles:nil completion:nil];
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:K_NETWORK_CHANGE_NOTIFICATION object:@(status)];
    }];
    
    //3开始监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)downloadServiceCompletion:(void (^)(BOOL))completion {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
           [self loadConfigAction:completion];
        }];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperations:@[operation] waitUntilFinished:YES];
    
}

- (void)loadConfigAction:(void (^)(BOOL finished))block {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_queue_create(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_queue_create(0, 0), ^{
            dispatch_semaphore_signal(sema);
        });
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            [sessionConfiguration setRequestCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        NSString *urlStr = @"";
        NSURLSession *session;
        session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue currentQueue]];
        [[session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
//            __block NSDictionary *resultDict = nil;
//
//            void (^HJsonConfigBlock)(void) = ^(void) {
//                if (resultDict && [resultDict isKindOfClass:NSDictionary.class] && resultDict.count > 0) {
//                    [[HUserDefault defaults] setBaseLink:[[resultDict objectForKey:@"navture_url"] stringValue]];
//                    NSString *h5_url = [[resultDict objectForKey:@"app_url"] stringValue];
//                    NSString *urlStr = [h5_url stringByReplacingOccurrencesOfString:@"?app=true" withString:@""];
//                    [[HUserDefault defaults] setH5Link:urlStr];
//                    [[HUserDefault defaults] setPlatCodeLink:[[resultDict objectForKey:@"plat_code"] stringValue]];
//                    [[HUserDefault defaults] setSrc1Link:[[resultDict objectForKey:@"src1"] stringValue]];
//                    [[HUserDefault defaults] setJsonVersion:
//                     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//                }
//            };

            if (data) {
//                resultDict = [data dictionary];
//                if ([resultDict isKindOfClass:NSDictionary.class] && resultDict.count > 0) {
//                    //缓存Json配置
//                    HJsonConfigBlock();
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
//                    [[HUpdate share] update];
//                }
            }

            //此处为硬编码，发包的时候可适当关注对比一下与服务端的配置是否一致
            [self loadLocalData];
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (block) {
                    block(YES);
                }
            });
            dispatch_semaphore_signal(sema);

        }] resume];
        //此处为硬编码，发包的时候可适当关注对比一下与服务端的配置是否一致
        [self loadLocalData];
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
- (void)loadLocalData {
//    NSString *jsonVersion = [[HUserDefault defaults] jsonVersion];
//    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    // jsonVersion与本地版本不一致,则使用本地硬编码
//    if (![jsonVersion isEqualToString:localVersion]) {
//        [[HUserDefault defaults] setBaseLink:[NSString stringWithFormat:@"%@%@/", KStaticH5Link, KStaticPlatCode]];
//        [[HUserDefault defaults] setH5Link:KStaticH5Link];
//        [[HUserDefault defaults] setPlatCodeLink:KStaticPlatCode];
//        [[HUserDefault defaults] setSrc1Link:KStaticSrc1];
//    } else if (![HUserDefault defaults].baseLink) {
//        NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//        if (bundleIdentifier) {
//            HKeyChainStore *keyChainStore = [HKeyChainStore keyChainStoreWithService:bundleIdentifier];
//            NSData *cachedData = [keyChainStore dataForKey:bundleIdentifier];
//            if (cachedData) {
//                NSDictionary *resultDict = [cachedData dictionary];
//                //缓存Json配置
//                if (resultDict && [resultDict isKindOfClass:NSDictionary.class] && resultDict.count > 0) {
//                    [[HUserDefault defaults] setBaseLink:[[resultDict objectForKey:@"navture_url"] stringValue]];
//                    NSString *h5_url = [[resultDict objectForKey:@"app_url"] stringValue];
//                    NSString *urlStr = [h5_url stringByReplacingOccurrencesOfString:@"?app=true" withString:@""];
//                    [[HUserDefault defaults] setH5Link:urlStr];
//                    [[HUserDefault defaults] setPlatCodeLink:[[resultDict objectForKey:@"plat_code"] stringValue]];
//                    [[HUserDefault defaults] setSrc1Link:[[resultDict objectForKey:@"src1"] stringValue]];
//                }
//            }
//
//            if ([HUserDefault defaults].baseLink.length < 3 ) {
//                [[HUserDefault defaults] setBaseLink:[NSString stringWithFormat:@"%@%@/",KStaticH5Link,KStaticPlatCode]];
//            }
//            if ([HUserDefault defaults].h5Link.length < 3 ) {
//                [[HUserDefault defaults] setH5Link:KStaticH5Link];
//            }
//            if ([HUserDefault defaults].platCodeLink.length < 3 ) {
//                [[HUserDefault defaults] setPlatCodeLink:KStaticPlatCode];
//            }
//            if ([HUserDefault defaults].src1Link.length < 3 ) {
//                [[HUserDefault defaults] setSrc1Link:KStaticSrc1];
//            }
//        }
//    }
//    if ([HUserDefault defaults].baseLink.length > 0) {
//        [[YTKNetworkConfig sharedConfig] setBaseUrl:HEADBASEINURL];
//    }
}

@end

