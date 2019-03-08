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
//#import <YYLabel.h>

@class HButtonViewCell, HImageViewCell, HImageViewCell2;

typedef void(^HButtonViewBlock)(HWebButtonView *webButtonView, HButtonViewCell *buttonCell);
typedef void(^HImageViewBlock)(HWebImageView *webImageView, HImageViewCell *imageCell);
typedef void(^HImageViewBlock2)(HWebImageView *webImageView, HImageViewCell2 *imageCell);

@interface HViewCell : HTupleBaseCell
@property (nonatomic) UIView *view;
@end

@interface HLabelViewCell : HTupleBaseCell
@property (nonatomic) UILabel *label;
//@property (nonatomic) YYLabel *label;
@end

@interface HTextViewCell : HTupleBaseCell
@property (nonatomic) UITextView *textView;
@end

@interface HButtonViewCell : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@property (nonatomic, copy) HButtonViewBlock buttonViewBlock;
@end

@interface HImageViewCell : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic, copy) HImageViewBlock imageViewBlock;
@end

@interface HImageViewCell2 : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;//显示在顶部
@property (nonatomic) UILabel *label;//显示在底部
@property (nonatomic) NSInteger labelHeight;//显示在底部，默认高度为20
@property(nonatomic)  UIEdgeInsets imageEdgeInsets;// default is UIEdgeInsetsZero
@property(nonatomic)  UIEdgeInsets titleEdgeInsets;// default is UIEdgeInsetsZero
@property (nonatomic, copy) HImageViewBlock2 imageViewBlock;
@end

@interface HTextFieldCell : HTupleBaseCell
@property (nonatomic) UITextField *textField;
@property (nonatomic) NSInteger maxInput;//最大输入限制，小于等于0表示不限制，默认为0
@property (nonatomic) BOOL forbidPaste;//禁止粘贴，默认为NO
@end

