//
//  HRequestWaitingView.h
//  QFProj
//
//  Created by dqf on 2018/5/30.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HUtil.h"
#import "HShow+Protocol.h"
#import "HCommonDefine.h"

typedef NS_ENUM(NSInteger, MGWaitingViewStyle) {
    MGWaitingViewStyleWhite,
    MGWaitingViewStyleGray
};

@interface HRequestWaitingView : UIView <HWaitingProtocol>

@property (nonatomic) MGWaitingViewStyle style;
+ (instancetype)awakeView;

@end
