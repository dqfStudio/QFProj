//
//  HLabelView.m
//  QFProj
//
//  Created by dqf on 2018/5/18.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HLabelView.h"

UIKIT_STATIC_INLINE CGFloat HEdgeWidth(HEdgeInsets edge) {
    return edge.left + edge.width + edge.right;
}

UIKIT_STATIC_INLINE CGFloat HSideEdgeHeight(HSideEdgeInsets edge) {
    return edge.top + edge.height + edge.bottom;
}

UIKIT_STATIC_INLINE CGFloat HEdgeRightWidth(HEdgeInsets edge) {
    return edge.right + edge.width;
}

UIKIT_STATIC_INLINE CGFloat HSideEdgeBottomHeight(HSideEdgeInsets edge) {
    return edge.height + edge.bottom;
}

@implementation HLabelView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:_label];
    }
    return self;
}

- (void)setLeftView:(UIView *)leftView {
    if (_leftView != leftView) {
        if (_leftView) {
            [_leftView removeFromSuperview];
            _leftView = nil;
        }
        _leftView = leftView;
        [self addSubview:_leftView];
        [self layoutSubviews];
    }
}

- (void)setRightView:(UIView *)rightView {
    if (_rightView != rightView) {
        if (_rightView) {
            [_rightView removeFromSuperview];
            _rightView = nil;
        }
        _rightView = rightView;
        [self addSubview:_rightView];
        [self layoutSubviews];
    }
}

- (void)setTopView:(UIView *)topView {
    if (_topView != topView) {
        if (_topView) {
            [_topView removeFromSuperview];
            _topView = nil;
        }
        _topView = topView;
        [self addSubview:_topView];
        [self layoutSubviews];
    }
}

- (void)setBottomView:(UIView *)bottomView {
    if (_bottomView != bottomView) {
        if (_bottomView) {
            [_bottomView removeFromSuperview];
            _bottomView = nil;
        }
        _bottomView = bottomView;
        [self addSubview:_bottomView];
        [self layoutSubviews];
    }
}

- (void)setLeftEdgeInsets:(HEdgeInsets)leftEdgeInsets {
    if (!HEdgeEqualToEdge(_leftEdgeInsets, leftEdgeInsets)) {
        _leftEdgeInsets = leftEdgeInsets;
        [self layoutSubviews];
    }
}

- (void)setRightEdgeInsets:(HEdgeInsets)rightEdgeInsets {
    if (!HEdgeEqualToEdge(_rightEdgeInsets, rightEdgeInsets)) {
        _rightEdgeInsets = rightEdgeInsets;
        [self layoutSubviews];
    }
}

- (void)setTopEdgeInsets:(HSideEdgeInsets)topEdgeInsets {
    if (!HSideEdgeEqualToEdge(_topEdgeInsets, topEdgeInsets)) {
        _topEdgeInsets = topEdgeInsets;
        [self layoutSubviews];
    }
}

- (void)setBottomEdgeInsets:(HSideEdgeInsets)bottomEdgeInsets {
    if (!HSideEdgeEqualToEdge(_bottomEdgeInsets, bottomEdgeInsets)) {
        _bottomEdgeInsets = bottomEdgeInsets;
        [self layoutSubviews];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;
    CGRect labelFrame = self.bounds;
    CGRect leftViewFrame = CGRectZero;
    CGRect rightViewFrame = CGRectZero;
    CGRect topViewFrame = CGRectZero;
    CGRect bottomViewFrame = CGRectZero;
    if (self.leftView) {
        //计算leftView的Frame
        leftViewFrame.origin.x = self.leftEdgeInsets.left;
        leftViewFrame.origin.y = frame.size.height/2 - self.leftEdgeInsets.height/2;
        leftViewFrame.size.width = self.leftEdgeInsets.width;
        leftViewFrame.size.height = self.leftEdgeInsets.height;
        if (!CGRectEqualToRect(self.leftView.frame, leftViewFrame)) {
            self.leftView.frame = leftViewFrame;
        }
    }
    if (self.rightView) {
        //计算rightView的Frame
        rightViewFrame.origin.x = frame.size.width - HEdgeRightWidth(self.rightEdgeInsets);
        rightViewFrame.origin.y = frame.size.height/2 - self.rightEdgeInsets.height/2;
        rightViewFrame.size.width = self.rightEdgeInsets.width;
        rightViewFrame.size.height = self.rightEdgeInsets.height;
        if (!CGRectEqualToRect(self.rightView.frame, rightViewFrame)) {
            self.rightView.frame = rightViewFrame;
        }
    }
    
    //计算label的Frame
    labelFrame.origin.x = HEdgeWidth(self.leftEdgeInsets);
    labelFrame.size.width -= HEdgeWidth(self.leftEdgeInsets) + HEdgeWidth(self.rightEdgeInsets);
    
    if (self.topView) {
        //计算topView的Frame
        topViewFrame.origin.x = labelFrame.origin.x;
        topViewFrame.origin.y = self.topEdgeInsets.top;
        topViewFrame.size.width = labelFrame.size.width;
        topViewFrame.size.height = self.topEdgeInsets.height;
        if (!CGRectEqualToRect(self.topView.frame, topViewFrame)) {
            self.topView.frame = topViewFrame;
        }
    }
    if (self.bottomView) {
        //计算bottomView的Frame
        bottomViewFrame.origin.x = labelFrame.origin.x;
        bottomViewFrame.origin.y = frame.size.height - HSideEdgeBottomHeight(self.bottomEdgeInsets);
        bottomViewFrame.size.width = labelFrame.size.width;
        bottomViewFrame.size.height = self.bottomEdgeInsets.height;
        if (!CGRectEqualToRect(self.bottomView.frame, bottomViewFrame)) {
            self.bottomView.frame = bottomViewFrame;
        }
    }
    //再次计算label的Frame
    labelFrame.origin.y = HSideEdgeHeight(self.topEdgeInsets);
    labelFrame.size.height -=  HSideEdgeHeight(self.topEdgeInsets) + HSideEdgeHeight(self.bottomEdgeInsets);
    if (!CGRectEqualToRect(self.label.frame, labelFrame)) {
        self.label.frame = labelFrame;
    }
}

@end
