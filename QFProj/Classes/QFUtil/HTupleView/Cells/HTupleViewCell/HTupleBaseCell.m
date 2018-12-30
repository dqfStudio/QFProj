//
//  HTupleBaseCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"

@interface HTupleBaseCell ()
@property (nonatomic) UITapGestureRecognizer *baseTap;
@end

@implementation HTupleBaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initUI];
        if (self.initBlock) {
            self.initBlock();
        }
    }
    return self;
}

- (HTupleCellSignalBlock)signalBlock {
    return [self getAssociatedValueForKey:_cmd];
}
- (void)setSignalBlock:(HTupleCellSignalBlock)signalBlock {
    [self setAssociateValue:signalBlock withKey:@selector(signalBlock)];
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
