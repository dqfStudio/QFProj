//
//  HOutAudioVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HOutAudioStatus) {
    HOutAudioWaiting = 0,
    HOutAudioResult
};

///音频去电
@interface HOutAudioVC : HTupleController
@property (nonatomic) HOutAudioStatus outAudioStatus;
@end
