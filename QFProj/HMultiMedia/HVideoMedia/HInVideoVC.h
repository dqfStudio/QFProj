//
//  HInVideoVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HInVideoStatus) {
    HInVideoWaiting = 0,
    HInVideoResult
};

///视频来电
@interface HInVideoVC : HTupleController
@property (nonatomic) HInVideoStatus inVideoStatus;
@end
