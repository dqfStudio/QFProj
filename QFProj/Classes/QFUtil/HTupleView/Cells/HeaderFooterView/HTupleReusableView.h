//
//  HTupleReusableView.h
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseView.h"

typedef void(^HReusableButtonViewBlock)(UIButton *btn);
typedef void(^HReusableImageViewBlock)(UIImageView *imageView);

@interface HReusableView : HTupleBaseView
@property (nonatomic) UIView *view;
@end

@interface HReusableTextView : HTupleBaseView
@property (nonatomic) UILabel *label;
@end

@interface HReusableButtonView : HTupleBaseView
@property (nonatomic) UIButton *button;
@property (nonatomic, copy) HReusableButtonViewBlock reusableButtonViewBlock;
@end

@interface HReusableImageView : HTupleBaseView
@property (nonatomic) UIImageView *imageView;
@property (nonatomic, copy) HReusableImageViewBlock reusableImageViewBlock;
@end

