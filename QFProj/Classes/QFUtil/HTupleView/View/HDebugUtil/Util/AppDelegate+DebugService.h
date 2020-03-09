//
//  AppDelegate+DebugService.h
//  MGMobileMusic
//
//  Created by dqf on 2017/7/20.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "AppDelegate.h"
#import "HDebugView.h"
#import <JhtFloatingBall/JhtFloatingBall.h>

@interface AppDelegate (DebugService) <JhtFloatingBallDelegate>
@property (nonatomic, readonly) HDebugView *debugView;
@property (nonatomic, readonly) JhtFloatingBall *folatingball;
@end
