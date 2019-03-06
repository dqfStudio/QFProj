//
//  HUpImageCell.h
//  QFProj
//
//  Created by dqf on 2018/5/22.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HBaseCell.h"
#import "HTupleView.h"

@interface HUpImageCell : HBaseCell <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end
