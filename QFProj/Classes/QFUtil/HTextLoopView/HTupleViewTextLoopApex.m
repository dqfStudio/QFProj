//
//  HTupleViewTextLoopApex.m
//  QFProj
//
//  Created by wind on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleViewTextLoopApex.h"

@implementation HTupleViewTextLoopApex
- (HTextLoopView *)textLoopView {
    if (!_textLoopView) {
        _textLoopView = [HTextLoopView textLoopViewWithFrame:self.bounds dataSource:self.contentArr interval:2.0 selectBlock:^(NSString *selectString, NSInteger index) {
            if (self.selectedBlock) {
                self.selectedBlock([selectString copy], index);
            }
        }];
    }
    return _textLoopView;
}
- (void)setContentArr:(NSArray *)contentArr {
    if (_contentArr != contentArr) {
        _contentArr = nil;
        _contentArr = contentArr;
        if (_contentArr.count > 0) {
            [self.layoutView addSubview:self.textLoopView];
        }
    }
}
- (void)relayoutSubviews {
    if (self.contentArr.count > 0) {
        HLayoutTupleApex(self.textLoopView)
    }
}
@end
