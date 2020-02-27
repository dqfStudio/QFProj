//
//  HTupleViewTextLoopCell.h
//  QFProj
//
//  Created by dqf on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"
#import "HTextLoopView.h"

typedef void(^HTupleViewTextLoopCellBlock)(NSString *selectString, NSInteger index);

@interface HTupleViewTextLoopCell : HTupleBaseCell
@property (nonatomic) HTextLoopView *textLoopView;
@property (nonatomic, copy) NSArray *contentArr;
@property (nonatomic, copy) HTupleViewTextLoopCellBlock selectedBlock;
@end
