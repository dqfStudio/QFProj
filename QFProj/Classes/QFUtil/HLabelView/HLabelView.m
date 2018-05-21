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
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:_label];
    }
    return self;
}

- (void)setAccessoryView:(UIView *)accessoryView {
    if (_accessoryView != accessoryView) {
        if (_accessoryView) {
            [_accessoryView removeFromSuperview];
            _accessoryView = nil;
        }
        _accessoryView = accessoryView;
        [self addSubview:_accessoryView];
        [self layoutSubviews];
    }
}

- (void)setEdgeInsets:(HEdgeInsets)edgeInsets {
    if (!HEdgeEqualToEdge(_edgeInsets, edgeInsets)) {
        _edgeInsets = edgeInsets;
        [self layoutSubviews];
    }
}

- (void)setDirection:(HAccessoryDirection)direction {
    if (_direction != direction) {
        _direction = direction;
        [self layoutSubviews];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.accessoryView) {

        switch (self.direction) {
            case HAccessoryDirectionLeft: {
                CGRect frame = self.bounds;
                //计算label的Frame
                CGRect labelFrame = frame;
                labelFrame.origin.x = self.edgeInsets.width + self.edgeInsets.left + self.edgeInsets.right;
                labelFrame.size.width -= labelFrame.origin.x;
                self.label.frame = labelFrame;
                
                //计算accessoryView的Frame
                CGRect accessoryFrame = CGRectZero;
                accessoryFrame.origin.x = self.edgeInsets.left;
                accessoryFrame.origin.y = frame.size.height/2 - self.edgeInsets.height/2;
                accessoryFrame.size.width = self.edgeInsets.width;
                accessoryFrame.size.height = self.edgeInsets.height;
                self.accessoryView.frame = accessoryFrame;
            }
                break;
            case HAccessoryDirectionRight: {
                CGRect frame = self.bounds;
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
            }
                break;
            default:
                break;
        }
        
    }else {
        self.label.frame = self.bounds;
    }
}

@end
