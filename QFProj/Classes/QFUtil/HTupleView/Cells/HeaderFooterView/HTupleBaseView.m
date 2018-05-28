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
        [self initUI];
        [self.goDownSubject subscribeNext:^(HTupleSignal *signal) {
            if (HTupleSignalSelf(signal, self.indexPath)) {
                if (self.signalBlock) {
                    self.signalBlock(signal);
                }
            }else if (HTupleSignalSection(signal, self.indexPath)) {
                if (self.signalBlock) {
                    self.signalBlock(signal);
                }
            }else if (HTupleSignalAll(signal)) {
                if (self.signalBlock) {
                    self.signalBlock(signal);
                }
            }
        }];
        if (self.initBlock) {
            self.initBlock();
        }
    }
    return self;
}

- (UITapGestureRecognizer *)baseTap {
    if (!_baseTap) {
        _baseTap = [[UITapGestureRecognizer alloc] init];
        _baseTap.numberOfTapsRequired = 1;
        _baseTap.numberOfTouchesRequired = 1;
        [_baseTap.rac_gestureSignal subscribeNext:^(id x) {
            [[UIApplication sharedApplication].delegate.window endEditing:YES];
        }];
    }
    return _baseTap;
}

- (void)setInitBlock:(HTupleCellInitBlock)initBlock {
    if (_initBlock != initBlock) {
        _initBlock = nil;
        _initBlock = initBlock;
    }
}

- (void)setSignalBlock:(HTupleCellSignalBlock)signalBlock {
    if (_signalBlock != signalBlock) {
        _signalBlock = nil;
        _signalBlock = signalBlock;
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
- (void)addReturnKeyBoard {
    [self addGestureRecognizer:self.baseTap];
}
@end
