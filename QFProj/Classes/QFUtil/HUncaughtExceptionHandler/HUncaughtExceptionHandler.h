//
//  HUncaughtExceptionHandler.h
//  HProj
//
//  Created by dqf on 2018/7/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUncaughtExceptionHandler : NSObject

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);
