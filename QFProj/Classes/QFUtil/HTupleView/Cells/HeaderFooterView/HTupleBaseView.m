//
//  HTupleBaseView.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseView.h"
#import <objc/runtime.h>

@interface HTupleBaseView ()
@property (nonatomic) UITapGestureRecognizer *baseTap;
@property (nonatomic) UIView *separatorView;
@end

@implementation HTupleBaseView

@synthesize separatorColor=_separatorColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initUI];
    }
    return self;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = UIView.new;
    }
    CGRect frame = self.getSeparatorFrame;
    if (!CGRectEqualToRect(frame, _separatorView.frame)) {
        [_separatorView setFrame:frame];
    }
    [_separatorView setBackgroundColor:self.separatorColor];
    return _separatorView;
}
- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = UIColor.lightGrayColor;
    }
    return _separatorColor;
}
- (void)setSeparatorColor:(UIColor *)separatorColor {
    if (_separatorColor != separatorColor) {
        _separatorColor = nil;
        _separatorColor = separatorColor;
        [self.separatorView setBackgroundColor:_separatorColor];
    }
}
- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_separatorInset, separatorInset)) {
        _separatorInset = separatorInset;
        [_separatorView setFrame:self.getSeparatorFrame];
    }
}
- (CGRect)getSeparatorFrame {
    CGRect frame = CGRectMake(0, 0, CGRectGetHeight(self.frame) - 1, 1);
    frame.origin.x += self.separatorInset.left;
    frame.size.width -= self.separatorInset.left + self.separatorInset.right;
    return frame;
}
- (void)setShouldShowSeparator:(BOOL)shouldShowSeparator {
    if (_shouldShowSeparator != shouldShowSeparator) {
        _shouldShowSeparator = shouldShowSeparator;
        if (_shouldShowSeparator) {
            [self addSubview:self.separatorView];
            [self bringSubviewToFront:self.separatorView];
            [self.separatorView setHidden:NO];
        }else {
            [self.separatorView setHidden:YES];
        }
    }
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

@implementation UICollectionReusableView (HSignal)
- (HTupleCellSignalBlock)signalBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSignalBlock:(HTupleCellSignalBlock)signalBlock {
    objc_setAssociatedObject(self, @selector(signalBlock), signalBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
