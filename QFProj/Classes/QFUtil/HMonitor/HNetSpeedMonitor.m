//
//  HNetSpeedMonitor.m
//  QFProj
//
//  Created by dqf on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HNetSpeedMonitor.h"
#include <arpa/inet.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <net/if.h>

NSString *const HDownloadNetworkSpeedNotificationKey = @"HDownloadNetworkSpeedNotificationKey";
NSString *const HUploadNetworkSpeedNotificationKey   = @"HUploadNetworkSpeedNotificationKey";

@interface HNetSpeedMonitor () {
    //总网速
    uint32_t _iBytes;
    uint32_t _oBytes;
    uint32_t _allFlow;

    //wifi网速
    uint32_t _wifiIBytes;
    uint32_t _wifiOBytes;
    uint32_t _wifiFlow;

    //3G网速
    uint32_t _wwanIBytes;
    uint32_t _wwanOBytes;
    uint32_t _wwanFlow;
}

@property(nonatomic) NSTimer *timer;

@end

@implementation HNetSpeedMonitor

static HNetSpeedMonitor *instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _iBytes = _oBytes = _allFlow = _wifiIBytes = _wifiOBytes = _wifiFlow = _wwanIBytes = _wwanOBytes = _wwanFlow = 0;
    }
    return self;
}

#pragma mark - 开始监听网速

//开始监听网速
- (void)startMonitor {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkNetworkSpeed) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

//停止监听网速
- (void)endMonitor {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (NSString *)stringWithbytes:(int)bytes {
    if (bytes < 1024) { // B
        return [NSString stringWithFormat:@"%dB", bytes];
    }else if (bytes >= 1024 && bytes < 1024 * 1024) { // KB
        return [NSString stringWithFormat:@"%.0fK", (double)bytes / 1024];
    }else if (bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) { // MB
        return [NSString stringWithFormat:@"%.0fM", (double)bytes / (1024 * 1024)];
    }else { // GB
        return [NSString stringWithFormat:@"%.0fG", (double)bytes / (1024 * 1024 * 1024)];
    }
}

- (void)checkNetworkSpeed {
    
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return;
    }

    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow = 0;

    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow = 0;

    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow = 0;

    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family) {
            continue;
        }

        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
            continue;
        }

        if (ifa->ifa_data == 0) {
            continue;
        }

        // network
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }

        //wifi
        if (!strcmp(ifa->ifa_name, "en0")) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow = wifiIBytes + wifiOBytes;
        }

        //3G or gprs
        if (!strcmp(ifa->ifa_name, "pdp_ip0")) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow = wwanIBytes + wwanOBytes;
        }
    }

    freeifaddrs(ifa_list);

    if (_iBytes != 0) {
        _speed = iBytes - _iBytes;
        _downloadNetworkSpeed = [[self stringWithbytes:iBytes - _iBytes] stringByAppendingString:@"/s"];
        [[NSNotificationCenter defaultCenter] postNotificationName:HDownloadNetworkSpeedNotificationKey object:_downloadNetworkSpeed];
    }

    _iBytes = iBytes;

    if (_oBytes != 0) {
        _uploadNetworkSpeed = [[self stringWithbytes:oBytes - _oBytes] stringByAppendingString:@"/s"];
        [[NSNotificationCenter defaultCenter] postNotificationName:HUploadNetworkSpeedNotificationKey object:_uploadNetworkSpeed];
    }

    _oBytes = oBytes;
}

@end