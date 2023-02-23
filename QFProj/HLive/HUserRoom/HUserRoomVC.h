//
//  HUserRoomVC.h
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDManager.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HLiveStatus) {
    HLiveStatusLoading = 0,
    HLiveStatusLiveing
};

@interface HUserRoomVC : HTupleController
@property (nonatomic) HTextField  *inputField;
@property (nonatomic) HLiveStatus liveStatus;
@end
