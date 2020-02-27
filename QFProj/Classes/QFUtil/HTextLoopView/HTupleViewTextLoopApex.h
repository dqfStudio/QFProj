//
//  HTupleViewTextLoopApex.h
//  QFProj
//
//  Created by dqf on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleBaseApex.h"
#import "HTextLoopView.h"

typedef void(^HTupleViewTextLoopApexBlock)(NSString *selectString, NSInteger index);

@interface HTupleViewTextLoopApex : HTupleBaseApex
@property (nonatomic) HTextLoopView *textLoopView;
@property (nonatomic, copy) NSArray *contentArr;
@property (nonatomic, copy) HTupleViewTextLoopApexBlock selectedBlock;
@end
