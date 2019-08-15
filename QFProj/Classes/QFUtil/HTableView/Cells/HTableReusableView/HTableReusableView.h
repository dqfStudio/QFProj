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

@interface HTableLabelView : HTableBaseView
@property (nonatomic) HLabel *label;
@end

@interface HTableTextView : HTableBaseView
@property (nonatomic) HTextView *textView;
@end

@interface HTableButtonView : HTableBaseView
@property (nonatomic) HWebButtonView *buttonView;
@end

@interface HTableImageView : HTableBaseView
@property (nonatomic) HWebImageView *imageView;
@end

@interface HTableTextFieldView : HTableBaseView
@property (nonatomic) HTextField *textField;
@end

@interface HTableVerticalView : HTableBaseView
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTableHorizontalView : HTableBaseView
@property (nonatomic) HTupleView *tupleView;
@end

@interface HTableUnionView : HTableBaseView
@property (nonatomic) HLabel *label;
@property (nonatomic) HLabel *detailLabel;
@property (nonatomic) HLabel *accessoryLabel;

@property (nonatomic) HTextView *textView;
@property (nonatomic) HTextView *detailTextView;
@property (nonatomic) HTextView *accessoryTextView;

@property (nonatomic) HWebButtonView *button;
@property (nonatomic) HWebButtonView *detailButton;
@property (nonatomic) HWebButtonView *accessoryButton;

@property (nonatomic) HWebImageView *imageView;
@property (nonatomic) HWebImageView *detailImageView;
@property (nonatomic) HWebImageView *accessoryImageView;

@property (nonatomic) HTextField *textField;
@property (nonatomic) HTextField *detailTextField;
@property (nonatomic) HTextField *accessoryTextField;
@end
