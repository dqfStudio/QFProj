//
//  HSendVideoVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HSendVideoStatus) {
    HSendVideoWaiting = 0,
    HSendVideoResult
};

///视频来电
@interface HSendVideoVC : HTupleController
@property (nonatomic) HSendVideoStatus sendVideoStatus;
@end
