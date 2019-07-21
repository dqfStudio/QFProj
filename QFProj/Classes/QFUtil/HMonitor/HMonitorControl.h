//
//  HMonitorControl.h
//  HRunLoopMonitor
//
//  Created by Eleven on 2018/11/17.
//  Copyright © 2018 Eleven. All rights reserved.
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
