//
//  HTableReusableView.h
//  QFProj
//
//  Created by wind on 2019/4/12.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTableBaseView.h"
#import "HTupleView.h"
#import "HLabel.h"

@interface HTableReusableLabelView : HTableBaseView
@property (nonatomic) HLabel *label;
@end

@interface HTableReusableTextView : HTupleBaseCell
@property (nonatomic) HTextView *textView;
@end

@interface HTableReusableButtonView : HTupleBaseCell
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTableReusableImageView : HTupleBaseCell
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTableReusableTextField : HTupleBaseCell
@property (nonatomic) HTextField *textField;
@end

@interface HTableReusableVerticalView : HTableBaseView
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableReusableHorizontalView : HTableBaseView
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableReusableView : HTableBaseView
@property (nonatomic) HLabel *headerLabel;
@property (nonatomic) HLabel *sectionLabel;
@property (nonatomic) HLabel *footerLabel;

@property (nonatomic) HTextView *headerTextView;
@property (nonatomic) HTextView *sectionTextView;
@property (nonatomic) HTextView *footerTextView;

@property (nonatomic) HWebButtonView *headerButton;
@property (nonatomic) HWebButtonView *sectionButton;
@property (nonatomic) HWebButtonView *footerButton;

@property (nonatomic) HWebImageView *headerImageView;
@property (nonatomic) HWebImageView *sectionImageView;
@property (nonatomic) HWebImageView *footerImageView;

@property (nonatomic) HTextField *headerTextField;
@property (nonatomic) HTextField *sectionTextField;
@property (nonatomic) HTextField *footerTextField;
@end
