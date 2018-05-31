//
//  HTupleViewCell.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"
#import "HWebImageView.h"
#import "HWebButtonView.h"
#import "Masonry.h"

@class HButtonViewCell, HImageViewCell;

typedef void(^HButtonViewBlock)(HWebButtonView *webButtonView, HButtonViewCell *buttonCell);
typedef void(^HImageViewBlock)(HWebImageView *webImageView, HImageViewCell *imageCell);

@interface HViewCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

@interface HScrollViewCell : HTupleBaseCell
@property (nonatomic) UIScrollView *scrollView;
@end

@interface HTextViewCell : HTupleBaseCell
@property (nonatomic) UILabel *label;
@end

@interface HTextViewCell2 : HTupleBaseCell
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *rightLabel;
@end

@interface HButtonViewCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *button;
@property (nonatomic, copy) HButtonViewBlock buttonViewBlock;
@end

@interface HImageViewCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic, copy) HImageViewBlock imageViewBlock;
@end
