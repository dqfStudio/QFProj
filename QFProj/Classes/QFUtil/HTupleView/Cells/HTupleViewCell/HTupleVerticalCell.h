//
//  HTupleVerticalCell.h
//  QFProj
//
//  Created by dqf on 2018/5/21.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleView.h"

@interface HTupleVerticalModel : NSObject
@property (nonatomic, copy) NSString *payload;
@end

@interface HTupleVerticalCell : HTupleBaseCell <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) HTupleVerticalModel *model;
@end
