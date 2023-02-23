//
//  HAcceptVideoVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HViewController.h"
#import "HLRDefine.h"

#define KButtonHeight1 55
#define KButtonHeight2 65

typedef NS_OPTIONS(NSUInteger, HAcceptVideoStatus) {
    HAcceptVideoWaiting = 0,
    HAcceptVideoResult
};

///视频来电
@interface HAcceptVideoVC : HViewController
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) HAcceptVideoStatus acceptVideoStatus;
@end
