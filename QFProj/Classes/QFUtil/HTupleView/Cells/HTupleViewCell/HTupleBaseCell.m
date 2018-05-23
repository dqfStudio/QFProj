//
//  HTupleBaseCell.m
//  QFProj
//
//  Created by dqf on 2018/5/20.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleBaseCell.h"

@implementation HTupleBaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.goDownSubject subscribeNext:^(HTupleSignal *signal) {
            if (HTupleSignalAll(signal)) {
                [self allItemSignal:signal];
            }
            if (HTupleSignalSection(signal, self.indexPath)) {//发给section的信号
                [self sectionSignal:signal];
            }
            if (HTupleSignalSelf(signal, self.indexPath)) {//给自己发的信号
                [self selfSignal:signal];
            }
        }];
        [self initUI];
    }
    return self;
}

- (void)initUI {}

- (void)selfSignal:(HTupleSignal *)signal {}

- (void)sectionSignal:(HTupleSignal *)signal {}

- (void)allItemSignal:(HTupleSignal *)signal {}

- (CGRect)getContentFrame {
    CGRect frame = self.bounds;
    frame.origin.x += self.edgeInsets.left;
    frame.origin.y += self.edgeInsets.top;
    frame.size.width -= self.edgeInsets.left + self.edgeInsets.right;
    frame.size.height -= self.edgeInsets.top + self.edgeInsets.bottom;
    return frame;
}
- (void)layoutContentView {};
@end
