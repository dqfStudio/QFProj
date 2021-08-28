//
//  HLiveRoomBgCell.h
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"
#import "UIView+HAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLiveRoomBgCell : HTupleImageCell
@property (nonatomic) UIVisualEffectView *effectView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@end

NS_ASSUME_NONNULL_END
