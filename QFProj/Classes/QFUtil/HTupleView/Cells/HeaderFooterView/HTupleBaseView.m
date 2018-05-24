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
        [self.goDownSubject subscribeNext:^(HTupleSignal *signal) {
            if (HTupleSignalDeliver(signal)) {
                switch (signal.deliverSignalType) {
                    case HTupleSignalTypeItem:
                        if (HTupleSignalSelf(signal, self.indexPath)) {
                            [self selfSignal:signal];
                        }
                        break;
                    case HTupleSignalTypeSecton:
                        if (HTupleSignalSection(signal, self.indexPath)) {
                            [self sectionSignal:signal];
                        }
                        break;
                    case HTupleSignalTypeAllItem:
                        if (HTupleSignalAll(signal)) {
                            [self allItemSignal:signal];
                        }
                        break;
                    default:
                        break;
                }
            }else if (HTupleSignalSelf(signal, self.indexPath)) {
                [self selfSignal:signal];
            }else if (HTupleSignalSection(signal, self.indexPath)) {
                [self sectionSignal:signal];
            }else if (HTupleSignalAll(signal)) {
                [self allItemSignal:signal];
            }
        }];
        [self initUI];
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

- (void)initUI {}

- (void)selfSignal:(HTupleSignal *)signal {}

- (void)sectionSignal:(HTupleSignal *)signal {}

- (void)allItemSignal:(HTupleSignal *)signal {}

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
