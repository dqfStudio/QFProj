//
//  HAuthorizeManager.m
//  QFProj
//
//  Created by dqf on 2018/8/16.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAuthorizeManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
}else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}

@interface HAuthorizeManager()<CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation HAuthorizeManager

+ (instancetype)sharemanager {
    static HAuthorizeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.locationManager = [[CLLocationManager alloc] init];
        manager.locationManager.delegate = manager;
        [manager.locationManager requestWhenInUseAuthorization];
    });
    return manager;
}

+ (void)authorizeAll {
    //定位权限
    [[self class] sharemanager];
    //相机权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {}];
    //麦克风权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {}];
    //相册权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {}];
    //通讯录
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
}

+ (void)getAutorizationStatusWithType:(AuthorizationType)authorizationType completion:(AuthorizationCompletionBlock)completion {
    switch (authorizationType) {
        case AuthorizationTypeCamera: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    completion(AuthorizationStatusAuthorized);
                }else {
                    completion(AuthorizationStatusDenied);
                }
            }];
        }
            break;
        case AuthorizationTypeAudio: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    completion(AuthorizationStatusAuthorized);
                }else {
                    completion(AuthorizationStatusDenied);
                }
            }];
        }
            break;
        case AuthorizationTypeLocation: {
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusNotDetermined) {
                [HAuthorizeManager sharemanager].authorizationCompletionBlock = completion;
            }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways){
                completion(AuthorizationStatusAuthorized);
            }else {
                completion(AuthorizationStatusDenied);
            }
        }
            break;
        case AuthorizationTypePhotoLibrary: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    completion(AuthorizationStatusAuthorized);
                }else {
                    completion(AuthorizationStatusDenied);
                }
            }];
        }
            break;
        case AuthorizationTypeContacts: {//通讯录
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    completion(AuthorizationStatusAuthorized);
                }else {
                    completion(AuthorizationStatusDenied);
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

+ (void)showAlertWithAuthorizationType:(AuthorizationType)authorizationType {
    NSString *title;
    NSString *message;
    NSString *confirmTitle = @"设置";
    NSString *cancelTitle = @"取消";
    dispatch_block_t gosetting = ^{
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            }];
        } else {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            #pragma clang diagnostic pop
        }
    };
    switch (authorizationType) {
        case AuthorizationTypePhotoLibrary: {//没有相册权限
            title = @"没有相册权限";
            message = KCHECK_AUTH_PHOTOLIB;
        }
            break;
        case AuthorizationTypeCamera: {//没有相机权限
            title = @"没有相机权限";
            message = KCHECK_AUTH_CAMERA;
        }
            break;
        case AuthorizationTypeAudio: {//没有麦克风权限
            title = @"没有麦克风权限";
            message = KCHECK_AUTH_MICROPHONE;
        }
            break;
        case AuthorizationTypeContacts: {//没有通讯录权限
            title = @"没有通讯录权限";
            message = KCHECK_AUTH_CONTACT;
        }
            break;
        case AuthorizationTypeLocation: {//没有定位权限
            title = @"没有位置权限";
            message = KCHECK_AUTH_LOCATION;
        }
            break;
        default:
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        gosetting();
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    
    dispatch_main_async_safe(^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusNotDetermined) {
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
            if (self.authorizationCompletionBlock) {
                self.authorizationCompletionBlock(AuthorizationStatusAuthorized);
            }
        }else {
            if (self.authorizationCompletionBlock) {
                self.authorizationCompletionBlock(AuthorizationStatusDenied);
            }
        }
        self.authorizationCompletionBlock = nil;
        self.locationManager.delegate = self;
    }
}

@end
