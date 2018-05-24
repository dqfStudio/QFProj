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

typedef void(^HReusableButtonViewBlock)(HWebButtonView *webButtonView);
typedef void(^HReusableImageViewBlock)(HWebImageView *webImageView);

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
- (void)setTapEnable:(BOOL)enabled;
@property (nonatomic, copy) HReusableImageViewBlock reusableImageViewBlock;
@end

