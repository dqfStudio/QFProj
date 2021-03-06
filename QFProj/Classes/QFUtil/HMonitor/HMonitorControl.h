//
//  HMonitorControl.h
//  HRunLoopMonitor
//
//  Created by wind on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG

NS_ASSUME_NONNULL_BEGIN

@interface HMonitorControl : NSObject
+ (instancetype)sharedInstance;
- (void)startMonitor;
- (void)endMonitor;
- (void)printLogTrace;
@end

NS_ASSUME_NONNULL_END

#endif
