//
//  HAcceptVideoVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HAcceptVideoStatus) {
    HAcceptVideoWaiting = 0,
    HAcceptVideoResult
};

///视频去电
@interface HAcceptVideoVC : HTupleController
@property (nonatomic) HAcceptVideoStatus acceptVideoStatus;
@end
