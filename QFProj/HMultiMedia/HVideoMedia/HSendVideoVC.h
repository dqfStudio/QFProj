//
//  HSendVideoVC.h
//  QFProj
//
//  Created by owner on 2023/2/22.
//  Copyright © 2023 dqfStudio. All rights reserved.
//

#import "HTupleController.h"
#import "HLRDefine.h"

#define KButtonHeight1 55
#define KButtonHeight2 65

typedef NS_OPTIONS(NSUInteger, HSendVideoStatus) {
    HSendVideoStatus1 = 0,
    HSendVideoStatus2,
    HSendVideoStatus3,
    HSendVideoStatus4,
    HSendVideoStatus5,
    HSendVideoStatus6
};

///视频去电
@interface HSendVideoVC : HViewController
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) HSendVideoStatus sendVideoStatus;
@end
