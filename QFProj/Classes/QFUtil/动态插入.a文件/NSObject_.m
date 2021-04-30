
#import <UIKit/UIKit.h>
#import "NSObject+HAspects.h"
#import <objc/runtime.h>
#import "NSObject_.h"

static const int hAlert_action_key;

@implementation UIAlertController (HHH)

+ (id)hShowAlertWithTitle:(NSString *)title
                  message:(NSString *)message
                    style:(UIAlertControllerStyle)style
        cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitles:(NSArray *)otherButtonTitles
               completion:(void (^)(NSInteger buttonIndex))completion {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
        
        if (cancelButtonTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                                     if (completion) {
                                                                         completion(0);
                                                                     }
                                                                 }];
            [alertController addAction:cancelAction];
        }
        
        if (otherButtonTitles.count > 0) {
            for (int i = 0; i < otherButtonTitles.count; i++) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:otherButtonTitles[i]
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *_Nonnull action) {
                                                                   if (completion) {
                                                                       NSNumber *index = objc_getAssociatedObject(action, &hAlert_action_key);
                                                                       completion([index integerValue]);
                                                                   }
                                                               }];
                objc_setAssociatedObject(action, &hAlert_action_key, @(i + 1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [alertController addAction:action];
            }
        }
        UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([rootController isKindOfClass:UIViewController.class]) {
                [rootController presentViewController:alertController animated:YES completion:nil];
            }
        });
        return alertController;
    }else {
        /*
         UIAlertView *alert = [[UIAlertView alloc] init];
         alert.title = title;
         alert.message = message;
         if (cancelButtonTitle) {
         [alert addButtonWithTitle:cancelButtonTitle];
         }
         if (otherButtonTitles.count > 0) {
         for (int i = 0; i < otherButtonTitles.count; i++) {
         [alert addButtonWithTitle:otherButtonTitles[i]];
         }
         }
         [alert setCancelButtonIndex:0];
         [alert showWithCompletionBlock:completion];
         return alert;*/
        return nil;
    }
}

@end

@implementation NSObject (KKK)
//+ (BOOL)turnOnChargingFunction {
//    return NO;
//}
@end

@implementation NSObject (HHH)

+ (void)load {
//    SEL selector = NSSelectorFromString(@"turnOnChargingFunction");
//    if (![self respondsToSelector:selector]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];
//    }
}

//+ (BOOL)turnOnChargingFunction {
//    return YES;
//}

+ (void)applicationDidFinishLaunching {
    
    //标识唯一一台设备
    NSString *uuidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
    //标识唯一一个APP
//    NSString *bundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *bundleIdentifier = @"com.studio.proj";
    //APP Name
//    NSString *appName1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
//    NSString *appName2 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    NSString *appName = @"签名APP";
    
    appName = [appName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //请求url
    NSString *urlString = @"http://app.signstack.xyz:8888/file/sign";
    
    //上传内容
    NSString *content = [NSString stringWithFormat:@"uuid=%@&bid=%@&appname=%@",uuidString, bundleIdentifier, appName];
    //请求方式
    NSString *requestWay = @"0";
    
    NSMutableURLRequest *request = nil;
    
    if (requestWay.intValue == 0) {//GET
        
        urlString = [NSString stringWithFormat:@"%@?%@",urlString, content];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.HTTPMethod = @"get";
        
    }else if (requestWay.intValue == 1) {//POST
        
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.HTTPMethod = @"post";
        request.HTTPBody = [content dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (data && !error) {
            NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //处理结果
            if ([resultDict isKindOfClass:NSDictionary.class]) {
                [self resultHandle:resultDict];
            }
        }
    }] resume];
    
}

+ (void)resultHandle:(NSDictionary *)resultDict {
    
    NSNumber *resultString = resultDict[@"type"];
    
    if (resultString.intValue == 0) {//会员正常使用

    }else if (resultString.intValue == 1) {//直接退出
        exit(0);
    }else if (resultString.intValue == 2) {//过期提醒
        NSString *alertString = resultDict[@"msg"];
        if (!alertString) {
            alertString = @"APP签名已过期，续费前将不能再使用!";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController hShowAlertWithTitle:@"签名过期提醒" message:alertString style:UIAlertControllerStyleAlert cancelButtonTitle:@"确定" otherButtonTitles:nil completion:^(NSInteger buttonIndex) {
                exit(0);
            }];
        });
    }
}

@end

void import_NSObject_HHH (void) { }





@implementation NSObject (WWW)

+ (void)load {
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //方法
//        SEL selector = NSSelectorFromString(@"handerBool");
//        [NSClassFromString(@"HMainViewController") aspectInstead:selector usingBlock:^(id<AspectInfo> info) {
//            BOOL returnValue = YES;
//            [info.originalInvocation setReturnValue:&returnValue];
//        }];
        //属性
        SEL selector = NSSelectorFromString(@"isLogin");
        [NSClassFromString(@"HUserStore") aspectInstead:selector usingBlock:^(id<AspectInfo> info) {
            BOOL returnValue = YES;
            [info.originalInvocation setReturnValue:&returnValue];
        }];
    });
    */
}

@end
