//
//  HAuthorizeManager.h
//  QFProj
//
//  Created by dqf on 2018/8/16.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger){
    AuthorizationTypeCamera,   //相机
    AuthorizationTypeAudio,    //麦克风
    AuthorizationTypeLocation,  //位置
    AuthorizationTypePhotoLibrary,  //相册
    AuthorizationTypeContacts,     //通讯录
}AuthorizationType;

typedef NS_ENUM(NSInteger){
    AuthorizationStatusAuthorized,
    AuthorizationStatusDenied,
}AuthorizationStatus;

typedef void(^AuthorizationCompletionBlock)(AuthorizationStatus status);

#define KCHECK_AUTH_CAMERA        @"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“应用名称”打开相机访问权限"
#define KCHECK_AUTH_PHOTOLIB      @"请在iPhone的“设置”-“隐私”-“照片”功能中，找到“应用名称”打开相册访问权限"
#define KCHECK_AUTH_MICROPHONE    @"请在iPhone的“设置”-“隐私”-“麦克风”功能中，找到“应用名称”打开麦克风访问权限"
#define KCHECK_AUTH_CONTACT       @"请在iPhone的“设置”-“隐私”-“通讯录”功能中，找到“应用名称”打开通讯录访问权限"
#define KCHECK_AUTH_LOCATION      @"请在iPhone的“设置”-“隐私”-“位置”功能中，找到“应用名称”打开位置访问权限"

@interface HAuthorizeManager : NSObject

@property (nonatomic, copy) AuthorizationCompletionBlock authorizationCompletionBlock;

//获取权限的状态
+ (void)getAutorizationStatusWithType:(AuthorizationType)authorizationType completion:(AuthorizationCompletionBlock)completion;

//没有权限的提示
+ (void)showAlertWithAuthorizationType:(AuthorizationType)authorizationType;

@end
