//
//  HNetSpeedMonitor.h
//  QFProj
//
//  Created by Wind on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 88kB/s
extern NSString *const HDownloadNetworkSpeedNotificationKey;
// 2MB/s
extern NSString *const HUploadNetworkSpeedNotificationKey;

@interface HNetSpeedMonitor : NSObject

@property(nonatomic) NSInteger speed;
@property(nonatomic, readonly) NSString *uploadNetworkSpeed;
@property(nonatomic, readonly) NSString *downloadNetworkSpeed;

+ (instancetype)sharedInstance;

- (void)startMonitor;
- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
