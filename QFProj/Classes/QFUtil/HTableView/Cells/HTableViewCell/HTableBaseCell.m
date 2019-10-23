//
//  HTableBaseCell.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableBaseCell.h"
#import <objc/runtime.h>

@interface HTableBaseCell ()
@property (nonatomic) UIView *separatorView;
@end

@implementation HTableBaseCell
@synthesize separatorInset = _separatorInset;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.style = style;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if (_separatorColor != separatorColor && ![separatorColor isKindOfClass:NSClassFromString(@"UIDynamicSystemColor")]) {
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)cellSkinEvent {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.skinBlock) {
            self.skinBlock(self, (HTableView *)self.table);
        }
    });
}
- (void)setSkinBlock:(HTableCellSkinBlock)skinBlock {
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

- (void)reloadData {
    if ([self.indexPath isKindOfClass:NSIndexPath.class]) {
        [self.table reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

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
