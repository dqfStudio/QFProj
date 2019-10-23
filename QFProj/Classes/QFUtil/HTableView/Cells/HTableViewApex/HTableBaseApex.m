//
//  HTableBaseApex.m
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTableBaseApex.h"
#import <objc/runtime.h>

@interface HTableBaseApex ()
@property (nonatomic) UIView *separatorView;
@end

@implementation HTableBaseApex

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
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
- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_separatorInset, separatorInset)) {
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
- (void)cellSkinEvent {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.skinBlock) {
            self.skinBlock(self, (HTableView *)self.table);
        }
    });
}
- (void)setSkinBlock:(HTableApexSkinBlock)skinBlock {
    if (_skinBlock != skinBlock) {
        _skinBlock = nil;
        _skinBlock = skinBlock;
        _skinBlock(self, (HTableView *)self.table);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSkinEvent) name:KTableSkinNotify object:nil];
    }
}
//子类覆盖
- (void)initUI {}

- (void)frameChanged {}

- (void)updateLayoutView {};

- (CGRect)layoutViewFrame {
    CGRect frame = self.bounds;
    frame.origin.x += self.edgeInsets.left;
    frame.origin.y += self.edgeInsets.top;
    frame.size.width -= self.edgeInsets.left + self.edgeInsets.right;
    frame.size.height -= self.edgeInsets.top + self.edgeInsets.bottom;
    return frame;
}
- (CGRect)layoutViewBounds {
    CGRect frame = self.layoutViewFrame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    return frame;
}
- (CGFloat)contentWidth {
    return CGRectGetWidth(self.layoutViewFrame);
}
- (CGFloat)contentHeight {
    return CGRectGetHeight(self.layoutViewFrame);
}
- (CGSize)contentSize {
    return self.layoutViewFrame.size;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
