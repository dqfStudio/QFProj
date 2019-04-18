//
//  HTupleBaseView.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseView.h"

@interface HTupleBaseView ()
@property (nonatomic) UITapGestureRecognizer *baseTap;
@end

@implementation HTupleBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initUI];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        [self addSubview:_lineView];
    }
    CGRect frame = self.getLineFrame;
    if (!CGRectEqualToRect(frame, _lineView.frame)) {
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }
    return _lineView;
}
- (CGRect)getLineFrame {
    CGRect frame = CGRectMake(0, 0, CGRectGetHeight(self.frame) - 1, 1);
    frame.origin.x += self.lineInsets.left;
    frame.size.width -= self.lineInsets.left + self.lineInsets.right;
    return frame;
}

- (UITapGestureRecognizer *)baseTap {
    if (!_baseTap) {
        _baseTap = [[UITapGestureRecognizer alloc] init];
        _baseTap.numberOfTapsRequired = 1;
        _baseTap.numberOfTouchesRequired = 1;
        [_baseTap addTarget:self action:@selector(baseTapAction)];
    }
    return _baseTap;
}

- (void)baseTapAction {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
}

- (void)initUI {}

- (void)layoutContentView {};

- (CGRect)getContentFrame {
    CGRect frame = self.bounds;
    frame.origin.x += self.edgeInsets.left;
    frame.origin.y += self.edgeInsets.top;
    frame.size.width -= self.edgeInsets.left + self.edgeInsets.right;
    frame.size.height -= self.edgeInsets.top + self.edgeInsets.bottom;
    return frame;
}
- (void)addReturnKeyBoard {
    [self addGestureRecognizer:self.baseTap];
}
- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}
- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}
- (CGSize)size {
    return self.frame.size;
}
@end
