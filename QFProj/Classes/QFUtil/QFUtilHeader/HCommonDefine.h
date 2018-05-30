//
//  HCommonDefine.h
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pthread.h>

#ifndef HCommonDefine_h
#define HCommonDefine_h

#define www weakify(self)
#define sss strongify(self)

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


#define isNil(ojc)       (ojc == nil ? YES : NO)
#define notNil(ojc)      (ojc != nil ? YES : NO)
#define isCls(ojc, OJC)  ([ojc isKindOfClass:[OJC class]] ? YES : NO)

//输出frame size point bool
#define LogRect(f)  NSLog(@"frame->%@",NSStringFromCGRect(f))
#define LogSize(s)  NSLog(@"size->%@",NSStringFromCGSize(s))
#define LogPoint(p) NSLog(@"point->%@",NSStringFromCGPoint(p))
#define LogBool(b)  NSLog(@"bool->%@",(b)?@"YES":@"NO");

//屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//判断是否是iPhone X
#define  iPhoneX ((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 812.f && SCREEN_HEIGHT == 375.f))

//Status bar height.
#define  KStatusBarHeight     (iPhoneX ? 44.f : 20.f)

//Navigation bar height.
#define  kNaviBarHeight       44.f

//Tabbar safe bottom margin.
#define  kBottomBarHeight     (iPhoneX ? 34.f : 0.f)

//Status bar & navigation bar height.
#define  kTopBarHeight        (iPhoneX ? 88.f : 64.f)

//中英状态下键盘的高度
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//A等于0
#define F_EQUAL_ZERO(A) ((fabs(A)) <= FLT_EPSILON)
//A不等于0
#define F_NOT_EQUAL_ZERO(A) (!(F_EQUAL_ZERO(A)))
//A == B
#define F_EQUAL(A, B) ((fabs((A) - (B))) < FLT_EPSILON)
//A != B
#define F_NOT_EQUAL(A, B) (!(F_EQUAL(A, B)))
//A > B
#define F_GREATER_THAN(A, B) ((A) - (B) > FLT_EPSILON && F_NOT_EQUAL(A, B))
//A >= B
#define F_GREATER_OR_EQUAL_THAN(A, B) (F_GREATER_THAN(A, B) || F_EQUAL(A,B))
//A < B
#define F_LESS_THAN(A, B) ((A) - (B) < FLT_EPSILON && F_NOT_EQUAL(A, B))
//A <= B
#define F_LESS_OR_EQUAL_THAN(A, B) (F_LESS_THAN(A, B) || F_EQUAL(A, B))

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#define HLog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#define HLog(...) nil
#endif

//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

//获取当前语言
#define HCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//应用程序的名字
#define AppDisplayName  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

#define AppCurVersion  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

//由角度获取弧度 有弧度获取角度
#define degreeToRadians(x) (M_PI *(x)/180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

#endif /* HCommonDefine_h */
