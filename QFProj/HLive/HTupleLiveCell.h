//
//  HTupleLiveCell.h
//  QFProj
//
//  Created by Jovial on 2021/8/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLiveBackgroundCell.h"
#import "HTupleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTupleLiveCell : HLiveBackgroundCell <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) UIView *liveLeftView;
@end

NS_ASSUME_NONNULL_END
