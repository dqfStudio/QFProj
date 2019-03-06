//
//  MGVersionManager.h
//  MGMobileMusic
//
//  Created by zhaosheng on 2017/4/8.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGVersionManager : NSObject


//单例
+ (instancetype)defaultManager;


//保存当前版本号，不会重复保存
- (void)saveVersion;


//用户升级之前的版本号，新用户则返回nil
- (NSString *)lastVersion;


//当前版本号，没有build号，如5.0.3
- (NSString *)currentVersion;

//当前版本号，有build号，比如：5.0.3.008
- (NSString *)detailVersion;


//判断当前版本是否是第一次启动，主要用于播放引导页
- (BOOL)isNewVersionFirstLaunch;



//是否是新用户，YES表示新用户，NO表示升级用户
- (BOOL)isNewUser;



//增加当前版本的启动次数
- (void)increaseLaunchTimes;


//第一次启动之后，调用这个方法，会更改记录，如果没调用这个方法，那么下次还会认为当前版本是第一次启动
- (void)afterVersionFirstLaunch;


@end


//版本号：A.B.C，A是大版本，B是中版本，C是小版本，
typedef NS_ENUM(NSInteger, MGVersionCompareResult){
    MGVersionDiffBigVersion = 1,            //不是同一个大版本
    MGVersionDiffMiddleVersion,             //不是同一个中版本
    MGVersionDiffSmallVersion,              //不是同一个小版本
    MGVersionIdenticalSameVersion,          //两个版本号完全相同
    MGVersionUnknownResult
};

@interface MGVersionManager (Compare)

/*
 *当前版本 op version参数，如果参数为空，那么当前版本永远高于nil，version格式：x.x.x，不按照格式的，不能保证结果正确
 */
- (BOOL)lessThan:(NSString *)version;               //当前版本 < version
- (BOOL)lessOrEqual:(NSString *)version;            //当前版本 <= version
- (BOOL)higherThan:(NSString *)version;             //当前版本 > version
- (BOOL)higherOrEqual:(NSString *)version;          //当前版本 >= version
- (BOOL)equalToVersion:(NSString *)version;         //当前版本 == version

//第一次启动时，进行版本比较，根据比较结果展示不同的引导图
- (MGVersionCompareResult)firstLaunchVersionCompareResult;

@end
