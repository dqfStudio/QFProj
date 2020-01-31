//
//  HTupleViewMarqueeCell.h
//  QFProj
//
//  Created by wind on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"

typedef void(^HTupleViewMarqueeCellBlock)(void);

@interface HTupleViewMarqueeCell : HTupleBaseCell
@property (nonatomic, copy) NSString *msg; //显示的文字
@property (nonatomic) UIColor *bgColor; //背景颜色
@property (nonatomic) UIColor *txtColor; //字体颜色
@property (nonatomic, copy) HTupleViewMarqueeCellBlock selectedBlock;
@end
