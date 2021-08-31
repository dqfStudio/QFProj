//
//  HLiveRoomVC.h
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HTupleController.h"

typedef NS_OPTIONS(NSUInteger, HLiveStatus) {
    HLiveStatusLoading = 0,
    HLiveStatusLiveing
};

NS_ASSUME_NONNULL_BEGIN

@interface HLiveRoomVC : HTupleController
@property (nonatomic) HTextField  *textField;
@property (nonatomic) HLiveStatus liveStatus;
@end

NS_ASSUME_NONNULL_END
