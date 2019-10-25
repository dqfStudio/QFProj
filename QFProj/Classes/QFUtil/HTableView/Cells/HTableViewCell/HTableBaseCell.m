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
//子类覆盖
- (void)initUI {}

- (void)relayoutSubviews {};

- (void)reloadData {
    if ([self.indexPath isKindOfClass:NSIndexPath.class]) {
        [self.table reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

@implementation HTableBaseCell (HAccessory)
- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        switch (accessoryType) {
            case UITableViewCellAccessoryNone: {
                self.accessoryView = nil;
            }
                break;
            case UITableViewCellAccessoryDisclosureIndicator: {
                UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 13)];
                arrowView.image = [UIImage imageNamed:@"icon_tuple_arrow_right"];
                self.accessoryView = arrowView;
            }
                break;
                
            default:
                break;
        }
    }
#endif
    [super setAccessoryType:accessoryType];
}
@end
