//
//  MGVersionManager.m
//  MGMobileMusic
//
//  Created by zhaosheng on 2017/4/8.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "MGVersionManager.h"

static NSString *const HistoryVersionsKey = @"MiguMusicHistoryVersionsKey";


@interface MGVersionManager ()

@property (nonatomic) NSString *versionFirstLaunchKey;
@property (nonatomic) NSString *versionLaunchTimesKey;

@end

@implementation MGVersionManager

+ (instancetype)defaultManager
{
    static MGVersionManager *versionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        versionManager = [MGVersionManager new];
    });
    return versionManager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.versionFirstLaunchKey = [NSString stringWithFormat:@"%@_date",self.currentVersion];
        self.versionLaunchTimesKey = [NSString stringWithFormat:@"%@_times", self.currentVersion];
    }
    return self;
}

- (BOOL)isNewVersionFirstLaunch
{
    BOOL ret = NO;
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:self.versionFirstLaunchKey];
    if (!obj)
    {
        ret = YES;
    }
    return ret;
}

- (BOOL)isNewUser
{
    return self.lastVersion == nil;
}

- (void)afterVersionFirstLaunch
{
    NSDate *date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:self.versionFirstLaunchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)increaseLaunchTimes
{
    NSInteger launchTimes = [[NSUserDefaults standardUserDefaults] integerForKey:self.versionLaunchTimesKey];
    ++launchTimes;
    [[NSUserDefaults standardUserDefaults] setInteger:launchTimes forKey:self.versionLaunchTimesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)arrayForVersion:(NSString *)version
{
    NSArray *array = [version componentsSeparatedByString:@"."];
    return array;
}

- (NSArray *)historyVersion
{
    NSArray *historys = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryVersionsKey];
    if ([historys isKindOfClass:[NSArray class]])
    {
        return historys;
    }
    return nil;
}

- (NSString *)lastVersion
{
    NSArray *versionArray = self.historyVersion;
    NSString *version;
    if (versionArray.count)
    {
        if ([versionArray containsObject:self.currentVersion])
        {
            if (versionArray.count > 1)
            {
                NSInteger index = versionArray.count-2;
                version = versionArray[index];
            }
        }
        else
        {
            version = [versionArray lastObject];
        }
    }
    return version;
}

- (NSString *)currentVersion
{
    static NSString *version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    });
    return version;
}

- (NSString *)detailVersion
{
    return [NSString stringWithFormat:@"%@.%@", self.currentVersion, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

- (void)saveVersion
{
    NSMutableArray *historys = [self.historyVersion mutableCopy];
    if (!historys)
    {
        historys = [NSMutableArray array];
    }
    if (![historys containsObject:self.currentVersion])
    {
        [historys addObject:self.currentVersion];
        [[NSUserDefaults standardUserDefaults] setObject:historys forKey:HistoryVersionsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end

@implementation MGVersionManager (Compare)

- (BOOL)lessThan:(NSString *)version
{
    NSInteger output = [self compareWithVersion:version];
    BOOL result = (output == -1);
    return result;
}

- (BOOL)lessOrEqual:(NSString *)version
{
    NSInteger output = [self compareWithVersion:version];
    BOOL result = (output != 1);
    return result;
}

- (BOOL)higherThan:(NSString *)version
{
    NSInteger output = [self compareWithVersion:version];
    BOOL result = (output == 1);
    return result;
}

- (BOOL)higherOrEqual:(NSString *)version
{
    NSInteger output = [self compareWithVersion:version];
    BOOL result = (output != -1);
    return result;
}

- (BOOL)equalToVersion:(NSString *)version
{
    NSInteger output = [self compareWithVersion:version];
    BOOL result = (output != 0);
    return result;
}

- (MGVersionCompareResult)firstLaunchVersionCompareResult
{
    NSString *lastVersion = self.lastVersion;
    MGVersionCompareResult result = [self versionCompareResult:lastVersion];
    return result;
}

- (MGVersionCompareResult)versionCompareResult:(NSString *)version
{
    NSInteger diffindex = [self differentIndexWithVersion:version];
    MGVersionCompareResult result = MGVersionUnknownResult;
    switch (diffindex) {
        case 0:
            result = MGVersionDiffBigVersion;
            break;
        case 1:
            result = MGVersionDiffMiddleVersion;
            break;
        case 2:
            result = MGVersionDiffSmallVersion;
            break;
        case 3:
            result = MGVersionIdenticalSameVersion;
            break;
        default:
            result = MGVersionUnknownResult;
            break;
    }
    
    return result;
}

- (NSInteger)differentIndexWithVersion:(NSString *)version
{
    NSInteger diffIndex = 0;
    if (version.length)
    {
        NSMutableArray *currentVersions = [NSMutableArray arrayWithArray:[self arrayForVersion:self.currentVersion]];
        NSMutableArray *paramerVersions = [NSMutableArray arrayWithArray:[self arrayForVersion:version]];
        
        NSInteger minCount = MIN(currentVersions.count, paramerVersions.count);
        for (NSInteger index = minCount; index < paramerVersions.count; ++index) {
            [paramerVersions addObject:@"0"];
        }
        for (NSInteger index = minCount; index < currentVersions.count; ++index) {
            [currentVersions addObject:@"0"];
        }
        minCount = currentVersions.count;
        
        for (NSInteger index = 0; index < minCount; ++index)
        {
            NSInteger currentV = [currentVersions[index] integerValue];
            NSInteger parameterV = [paramerVersions[index] integerValue];
            
            if (currentV != parameterV)
            {
                diffIndex = index;
                break;
            }
        }
    }
    return diffIndex;
}


- (NSInteger)compareWithVersion:(NSString *)version
{
    //1 当前version > 参数version;
    //0  当前version = 参数version;
    //-1  当前version < 参数version;
    NSInteger output = 1;
    if (version.length)
    {
        NSArray *currentVersions = [self arrayForVersion:self.currentVersion];
        NSArray *paramerVersions = [self arrayForVersion:version];
        
        NSInteger minCount = MIN(currentVersions.count, paramerVersions.count);
        //有版本比较，就设置为YES，如果循环结束，还为NO，说明两个版本前部分一样；
        BOOL flag = NO;
        
        for (NSInteger index = 0; index < minCount; ++index)
        {
            NSInteger currentV = [currentVersions[index] integerValue];
            NSInteger parameterV = [paramerVersions[index] integerValue];
            
            if (currentV != parameterV)
            {
                if (currentV > parameterV){
                    output = 1;
                }
                else if (currentV < parameterV){
                    output = -1;
                }
                flag = YES;
                break;
            }
        }
        
        if (!flag)
        {
            if (minCount < paramerVersions.count){
                output = -1;
            }
            else if (minCount < currentVersions.count){
                output = 1;
            }
            else{
                output = 0;
            }
        }
    }
    return output;
}

@end
