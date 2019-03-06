//
//  HWaitingView.h
//  HProjectModel1
//
//  Created by wind on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HTupleView.h"

typedef NS_ENUM(NSInteger, HWaitingType) {
    HWaitingTypeWhite,
    HWaitingTypeGray,
    HWaitingTypeBlack
};

@interface HWaitingView : UIView

+ (void)showInView:(UIView *)view withType:(HWaitingType)type;

@end


@interface UIView (HWaitingView)
@property(nonatomic) HWaitingView *mgWaitingView;
@end
