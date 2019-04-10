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
#import "HTupleView.h"
//#import <YYLabel.h>

@class HButtonViewCell, HImageViewCell, HTupleView;

typedef void(^HButtonViewBlock)(HWebButtonView *webButtonView, HButtonViewCell *buttonCell);
typedef void(^HImageViewBlock)(HWebImageView *webImageView, HImageViewCell *imageCell);

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

@interface HTextFieldCell : HTupleBaseCell
@property (nonatomic) UITextField *textField;
@property (nonatomic) NSInteger maxInput;//最大输入限制，小于等于0表示不限制，默认为0
@property (nonatomic) BOOL forbidPaste;//禁止粘贴，默认为NO
@end

@interface HTupleViewCell : HTupleBaseCell

@property (nonatomic) CGFloat lineSpace;
@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic) NSString *image;
@property (nonatomic) UIEdgeInsets imageInsets;

@property (nonatomic, copy) NSString *title;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIFont *titleFont;

@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic) UIColor *detailTitleColor;
@property (nonatomic) UIFont *detailTitleFont;

@property (nonatomic) UIEdgeInsets accessoryInsets;

- (void)synchronize;
@end

