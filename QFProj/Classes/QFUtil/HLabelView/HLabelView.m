//
//  HLabelView.m
//  QFProj
//
//  Created by dqf on 2018/5/18.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HLabelView.h"

@implementation HLabelView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect tmpFrame = CGRectZero;
        tmpFrame.size = frame.size;
        _label = [[UILabel alloc] initWithFrame:tmpFrame];
        [self addSubview:_label];
    }
    return self;
}

- (void)setAccessoryView:(UIView *)accessoryView {
    if (_accessoryView) {
        [_accessoryView removeFromSuperview];
        _accessoryView = nil;
    }
    _accessoryView = accessoryView;
    [self addSubview:_accessoryView];
    [self layoutSubviews];
}

- (void)setEdgeInsets:(HEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.accessoryView) {
        
        CGRect frame = self.frame;
        frame.origin = CGPointZero;
        //计算label的Frame
        CGRect labelFrame = frame;
        labelFrame.size.width -= self.edgeInsets.width + self.edgeInsets.left + self.edgeInsets.right;
        self.label.frame = labelFrame;
        
        //计算accessoryView的Frame
        CGRect accessoryFrame = CGRectZero;
        accessoryFrame.origin.x = labelFrame.size.width + self.edgeInsets.left;
        accessoryFrame.origin.y = frame.size.height/2 - self.edgeInsets.height/2;
        accessoryFrame.size.width = self.edgeInsets.width;
        accessoryFrame.size.height = self.edgeInsets.height;
        self.accessoryView.frame = accessoryFrame;
        
    }else {
        CGRect frame = self.frame;
        frame.origin = CGPointZero;
        self.label.frame = frame;
    }
}

@end
