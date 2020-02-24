//
//  AppDelegate+DebugService.h
//  MGMobileMusic
//
//  Created by dqf on 2017/7/20.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "AppDelegate.h"
#import "HDebugView.h"

@interface AppDelegate (DebugService)
@property (nonatomic, readonly) HDebugView *debugView;
@end
