//
//  HTupleReusableView.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseView.h"
#import "HWebImageView.h"
#import "HWebButtonView.h"
#import "UILabel+HAttributeText.h"

@class HReusableButtonView, HReusableImageView, HReusableImageView2;

typedef void(^HReusableButtonViewBlock)(HWebButtonView *webButtonView, HReusableButtonView *buttonView);
typedef void(^HReusableImageViewBlock)(HWebImageView *webImageView, HReusableImageView *imageView);
typedef void(^HReusableImageViewBlock2)(HWebImageView *webImageView, HReusableImageView2 *imageView);

@interface HReusableView : HTupleBaseView
@property (nonatomic) UIView *view;
@end

@interface HReusableLabelView : HTupleBaseView
@property (nonatomic) UILabel *label;
@end

@interface HReusableTextView : HTupleBaseView
@property (nonatomic) UITextView *textView;
@end

@interface HReusableButtonView : HTupleBaseView
@property (nonatomic) HWebButtonView *buttonView;
@property (nonatomic, copy) HReusableButtonViewBlock reusableButtonViewBlock;
@end

@interface HReusableImageView : HTupleBaseView
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic, copy) HReusableImageViewBlock reusableImageViewBlock;
@end

@interface HReusableImageView2 : HTupleBaseView
@property (nonatomic) HWebImageView *imageView;//显示在顶部
@property (nonatomic) UILabel *label;//显示在底部
@property (nonatomic) NSInteger labelHeight;//显示在底部，默认高度为20
@property(nonatomic)  UIEdgeInsets imageEdgeInsets;// default is UIEdgeInsetsZero
@property(nonatomic)  UIEdgeInsets titleEdgeInsets;// default is UIEdgeInsetsZero
@property (nonatomic, copy) HReusableImageViewBlock2 reusableImageViewBlock;
@end

