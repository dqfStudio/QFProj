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

@class HReusableButtonView, HReusableImageView;

typedef void(^HReusableButtonViewBlock)(HWebButtonView *webButtonView, HReusableButtonView *buttonView);
typedef void(^HReusableImageViewBlock)(HWebImageView *webImageView, HReusableImageView *imageView);

@interface HReusableView : HTupleBaseView
@property (nonatomic) UIView *view;
@end

@interface HReusableTextView : HTupleBaseView
@property (nonatomic) UILabel *label;
@end

@interface HReusableButtonView : HTupleBaseView
@property (nonatomic) HWebButtonView *button;
@property (nonatomic, copy) HReusableButtonViewBlock reusableButtonViewBlock;
@end

@interface HReusableImageView : HTupleBaseView
@property (nonatomic) HWebImageView *imageView;
@property (nonatomic, copy) HReusableImageViewBlock reusableImageViewBlock;
@end

