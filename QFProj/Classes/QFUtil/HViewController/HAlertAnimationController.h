//
//  HAlertAnimationController.h
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HViewController.h"
#import "HTupleView.h"

@interface HAlertAnimationController : HViewController <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
//是否隐藏展示视觉效果的view，此处为毛玻璃效果，默认为NO
@property (nonatomic) BOOL hideVisualView;
@end
