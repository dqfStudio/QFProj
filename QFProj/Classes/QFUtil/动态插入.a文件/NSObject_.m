
#import <UIKit/UIKit.h>
#import "NSObject+HAspects.h"
#import <objc/runtime.h>
#import "NSObject_.h"

static const int alert_action_key;

@implementation UIAlertController (HHH)

+ (id)showAlertWithTitle:(NSString *)title
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
                                                                 handler:^(UIAlertAction * _Nonnull action) {
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
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   if (completion) {
                                                                       NSNumber *index = objc_getAssociatedObject(action, &alert_action_key);
                                                                       completion([index integerValue]);
                                                                   }
                                                               }];
                objc_setAssociatedObject(action, &alert_action_key, @(i + 1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [alertController addAction:action];
            }
        }
        UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
        dispatch_async(dispatch_get_main_queue(), ^{
           [rootController presentViewController:alertController animated:YES completion:nil];
        });
        return alertController;
    } else {
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


@implementation NSObject (HHH)

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

+ (void)applicationDidFinishLaunching {
    
    //标识唯一一台设备
    NSString *uuidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
    //标识唯一一个APP
    NSString *bundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    //请求url
    NSString *urlString = @"https://baidu.com/ipa.json";
    //上传内容
    NSString *content = [NSString stringWithFormat:@"uuid=%@&bundleId=%@",uuidString, bundleIdentifier];
    //请求方式
    NSString *requestWay = @"0";
    
    if (requestWay.intValue == 0) {//GET
        
//        urlString = [NSString stringWithFormat:@"%@?uuid=%@&bundleId=%@",urlString, uuidString, bundleIdentifier];
        NSURL *url = [NSURL URLWithString:urlString];
        
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && !error) {
                NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //处理结果
                [self resultHandle:resultDict];
            }
        }] resume];
        
    }else if (requestWay.intValue == 1) {//POST
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.HTTPMethod = @"post";
        request.HTTPBody = [content dataUsingEncoding:NSUTF8StringEncoding];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && !error) {
                NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //处理结果
                [self resultHandle:resultDict];
            }
        }] resume];
    }
    
}

+ (void)resultHandle:(NSDictionary *)resultDict {
    
    NSString *resultString = @"1";
    
    if (resultString.intValue == 0) {//会员正常使用
        
    }else if (resultString.intValue == 1) {//会员资格提醒
        //NSLog(@"%@",bundleIdentifier);
        //NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:1000];
        NSDate *serverDate = [NSDate date];
        NSTimeInterval serverInterval = [serverDate timeIntervalSince1970];
        
        NSDate *localDate = [NSDate date];
        NSTimeInterval localInterval = [localDate timeIntervalSince1970];
        localInterval -= 50;
        
        NSTimeInterval diffInterval = serverInterval - localInterval;
        if (diffInterval >= 0) {
            NSInteger day = diffInterval/(24 * 60 * 60);
            //[NSDate dateWithTimeInterval:0 sinceDate:nil];
            NSString *dayString = @" 1 天";
            if (day <= 3) {
                dayString = @" 3 天";
            }else if (day <= 2) {
                dayString = @" 2 天";
            }else if (day <= 1) {
                dayString = @" 1 天";
            }
            dayString = [NSString stringWithFormat:@"您的会员资格已不足%@，请及时充值!", dayString];
            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIAlertController showAlertWithTitle:@"过期提醒" message:dayString style:UIAlertControllerStyleAlert cancelButtonTitle:@"确定" otherButtonTitles:nil completion:^(NSInteger buttonIndex) {
                                    
                                }];
                            });
        }
    }else if (resultString.intValue == 2) {//直接退出
        exit(0);
    }else if (resultString.intValue == 3) {//过期提醒
        NSString *alertString = @"您的会员已过期";
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController showAlertWithTitle:@"过期提醒" message:alertString style:UIAlertControllerStyleAlert cancelButtonTitle:@"您的会员资格已过期，续费前将不能再使用!" otherButtonTitles:nil completion:^(NSInteger buttonIndex) {
                            exit(0);
                        }];
        });
    }
}

@end

void import_NSObject_HHH (void) { }





@implementation NSObject (WWW)

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //方法
//        SEL selector = NSSelectorFromString(@"handerBool");
//        [NSClassFromString(@"HMainViewController") aspectInstead:selector usingBlock:^(id<AspectInfo> info) {
//            BOOL returnValue = YES;
//            [info.originalInvocation setReturnValue:&returnValue];
//        }];
        //属性
        SEL selector = NSSelectorFromString(@"isLogin");
        [NSClassFromString(@"HUserDefaults") aspectInstead:selector usingBlock:^(id<AspectInfo> info) {
            BOOL returnValue = YES;
            [info.originalInvocation setReturnValue:&returnValue];
        }];
    });
}

@end
