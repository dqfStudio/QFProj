//
//  HTupleViewCell.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"
#import "HTupleView2.h"

typedef void(^HButtonViewBlock)(UIButton *btn);
typedef void(^HImageViewBlock)(UIImageView *imageView);

@interface HViewCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

@interface HTextViewCell : HTupleBaseCell
@property (nonatomic) UILabel *label;
@end

@interface HButtonViewCell : HTupleBaseCell
@property (nonatomic) UIButton *button;
@property (nonatomic, copy) HButtonViewBlock buttonViewBlock;
@end

@interface HImageViewCell : HTupleBaseCell
@property (nonatomic) UIImageView *imageView;
@property (nonatomic, copy) HImageViewBlock imageViewBlock;
@end

@interface HTupleViewCell : HTupleBaseCell
@property (nonatomic) HTupleView2 *tupleView2;
@end
