//
//  HTupleHorizontalCell.h
//  QFProj
//
//  Created by dqf on 2018/5/21.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"
#import "HTupleReusableView.h"
#import "HTupleView.h"

@interface HTupleHorizontalCell : HTupleBaseCell <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end
