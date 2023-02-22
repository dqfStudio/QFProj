//
//  HMultiMediaVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HMultiMediaStatus) {
    HMultiMediaWaiting = 0,
    HMultiMediaResult
};

///多媒体音视频
@interface HMultiMediaVC : HTupleController
@property (nonatomic) HMultiMediaStatus multiMediaStatus;
@end
