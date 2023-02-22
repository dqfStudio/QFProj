//
//  HInAudioVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HInAudioStatus) {
    HInAudioWaiting = 0,
    HInAudioResult
};

///音频来电
@interface HInAudioVC : HTupleController
@property (nonatomic) HInAudioStatus inAudioStatus;
@end
