//
//  HOutVideoVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

typedef NS_OPTIONS(NSUInteger, HOutVideoStatus) {
    HOutVideoWaiting = 0,
    HOutVideoResult
};

///视频去电
@interface HOutVideoVC : HTupleController
@property (nonatomic) HOutVideoStatus outVideoStatus;
@end
