//
//  HAcceptAudioVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HAcceptAudioStatus) {
    HAcceptAudioWaiting = 0,
    HAcceptAudioResult
};

///音频去电
@interface HAcceptAudioVC : HTupleController
@property (nonatomic) HAcceptAudioStatus acceptAudioStatus;
@end
