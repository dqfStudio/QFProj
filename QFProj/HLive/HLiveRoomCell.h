//
//  HLiveRoomCell.h
//  QFProj
//
//  Created by dqf on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveRoomBgCell.h"
#import "HTupleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLiveRoomCell : HLiveRoomBgCell <HTupleViewDelegate>
@property (nonatomic) UIView *liveLeftView;
@property (nonatomic) HTupleView *liveRightView;
@end

NS_ASSUME_NONNULL_END
