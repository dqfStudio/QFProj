//
//  HTupleBaseApex.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseApex.h"
#import <objc/runtime.h>

@interface HTupleBaseApex ()
@property (nonatomic) UIView *separatorView;
@end

@implementation HTupleBaseApex

@synthesize separatorColor=_separatorColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColor.clearColor];
        [self initUI];
    }
    return self;
}

- (void)cellSkinEvent {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.skinBlock) {
            self.skinBlock(self, (HTupleView *)self.tuple);
        }
    });
}

- (void)setSkinBlock:(HTupleApexSkinBlock)skinBlock {
    if (_skinBlock != skinBlock) {
        _skinBlock = nil;
        _skinBlock = skinBlock;
        _skinBlock(self, (HTupleView *)self.tuple);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSkinEvent) name:KTupleSkinNotify object:nil];
    }
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = UIView.new;
        [_separatorView setHidden:YES];
        //#E2E2E2
        UIColor *color = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
        [_separatorView setBackgroundColor:color];
    }
    return _separatorView;
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
        [self.separatorView setFrame:self.getSeparatorFrame];
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
            if (!self.separatorView.superview) {
                [self addSubview:self.separatorView];
            }
            [self bringSubviewToFront:self.separatorView];
        }
        [self.separatorView setHidden:!_shouldShowSeparator];
    }
    //重设frame
    if (_shouldShowSeparator) {
        CGRect frame = self.getSeparatorFrame;
        if (!CGRectEqualToRect(frame, _separatorView.frame)) {
            [self.separatorView setFrame:frame];
        }
    }
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
- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}
- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}
- (CGSize)size {
    return self.frame.size;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

@implementation HTupleBaseApex (HSignal)
- (HTupleCellSignalBlock)signalBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSignalBlock:(HTupleCellSignalBlock)signalBlock {
    objc_setAssociatedObject(self, @selector(signalBlock), signalBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isHeader {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIsHeader:(BOOL)isHeader {
    objc_setAssociatedObject(self, @selector(isHeader), @(isHeader), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
