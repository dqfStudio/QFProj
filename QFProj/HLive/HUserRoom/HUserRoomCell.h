//
//  HUserRoomCell.h
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"
#import "UIView+HAlert.h"
#import "HTupleView.h"
#import "HLRDManager.h"
#import "HLRDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HUserRoomBgCell : HTupleImageCell
@property (nonatomic) UIVisualEffectView *effectView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@interface HUserRoomCell : HUserRoomBgCell <HTupleViewDelegate>
@property (nonatomic) UIView *liveLeftView;
@property (nonatomic) HTupleView *liveRightView;
@end

NS_ASSUME_NONNULL_END
