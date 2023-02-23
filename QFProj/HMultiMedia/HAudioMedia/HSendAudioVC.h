//
//  HSendAudioVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HSendAudioStatus) {
    HSendAudioWaiting = 0,
    HSendAudioResult
};

///音频来电
@interface HSendAudioVC : HTupleController
@property (nonatomic) HSendAudioStatus sendAudioStatus;
@end
