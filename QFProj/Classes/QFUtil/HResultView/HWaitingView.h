//
//  HWaitingView.h
//  QFProj
//
//  Created by dqf on 2018/12/30.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HAlertFormatter.h"

typedef NS_ENUM(NSInteger, HWaitingType) {
    HWaitingTypeBlack,
    HWaitingTypeWhite,
    HWaitingTypeGray
};

@interface HWaitingView : UIView
@property (nonatomic) HWaitingTransition *make;
@end
