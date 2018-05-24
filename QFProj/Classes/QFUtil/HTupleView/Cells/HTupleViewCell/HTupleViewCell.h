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

typedef void(^HButtonViewBlock)(HWebButtonView *webButtonView);
typedef void(^HImageViewBlock)(HWebImageView *webImageView);

@interface HViewCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

@interface HTextViewCell : HTupleBaseCell
@property (nonatomic) UILabel *label;
@end

@interface HButtonViewCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *button;
@property (nonatomic, copy) HButtonViewBlock buttonViewBlock;
@end

@interface HImageViewCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
- (void)setTapEnable:(BOOL)enabled;
@property (nonatomic, copy) HImageViewBlock imageViewBlock;
@end
