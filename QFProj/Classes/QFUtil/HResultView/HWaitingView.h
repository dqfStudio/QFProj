//
//  HWaitingView.h
//  HProjectModel1
//
//  Created by wind on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HShow+Protocol.h"

typedef NS_ENUM(NSInteger, HWaitingType) {
    HWaitingTypeBlack,
    HWaitingTypeWhite,
    HWaitingTypeGray
};

@interface HWaitingView : UIView <HWaitingProtocol>

@end
