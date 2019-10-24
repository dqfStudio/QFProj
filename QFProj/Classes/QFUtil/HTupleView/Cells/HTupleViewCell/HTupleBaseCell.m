//
//  HTupleBaseCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"
#import <objc/runtime.h>

@interface HTupleBaseCell ()
@property (nonatomic) UIView *separatorView;
@end

@implementation HTupleBaseCell
@synthesize separatorColor=_separatorColor;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColor.clearColor];
        [self initUI];
    }
    return self;
}

- (UIView *)layoutView {
    if (!_layoutView) {
        _layoutView = UIView.new;
        [self.contentView addSubview:_layoutView];
    }
    return _layoutView;
}

- (void)cellSkinEvent {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.skinBlock) {
            self.skinBlock(self, (HTupleView *)self.tuple);
        }
    });
}
- (void)setSkinBlock:(HTupleCellSkinBlock)skinBlock {
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
        UIColor *color = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
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
- (void)setSeparatorInset:(UILREdgeInsets)separatorInset {
    if (!UILREdgeInsetsEqualToEdgeInsets(_separatorInset, separatorInset)) {
        _separatorInset = separatorInset;
        [self.separatorView setFrame:self.getSeparatorFrame];
    }
}
- (CGRect)getSeparatorFrame {
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
    frame.origin.x += self.separatorInset.left;
    frame.size.width -= self.separatorInset.left + self.separatorInset.right;
    return frame;
}
- (void)setShouldShowSeparator:(BOOL)shouldShowSeparator {
    if (_shouldShowSeparator != shouldShowSeparator) {
        _shouldShowSeparator = shouldShowSeparator;
        if (_shouldShowSeparator) {
            if (!self.separatorView.superview) {
                [self.contentView addSubview:self.separatorView];
            }
            [self.contentView bringSubviewToFront:self.separatorView];
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

- (void)relayoutSubviews {}

- (void)reloadData {
    if ([self.indexPath isKindOfClass:NSIndexPath.class]) {
        [self.tuple reloadItemsAtIndexPaths:@[self.indexPath]];
    }
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    //更新layoutView的frame
    CGRect frame = [self layoutViewFrame];
    if(!CGRectEqualToRect(self.layoutView.frame, frame)) {
        [self.layoutView setFrame:frame];
    }
}

- (CGRect)layoutViewFrame {
    CGRect frame = self.bounds;
    frame.origin.x += _edgeInsets.left;
    frame.origin.y += _edgeInsets.top;
    frame.size.width -= _edgeInsets.left + _edgeInsets.right;
    frame.size.height -= _edgeInsets.top + _edgeInsets.bottom;
    return frame;
}
- (CGRect)layoutViewBounds {
    CGRect frame = self.layoutViewFrame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    return frame;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
