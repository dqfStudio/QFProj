//
//  HBaseHeaderFooterView.m
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HBaseHeaderFooterView.h"
#import <objc/runtime.h>

@implementation HBaseHeaderFooterView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

//子类覆盖
- (void)initUI {}

- (void)layoutContentView {};

- (CGRect)getContentFrame {
    return self.bounds;
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

@implementation UITableViewHeaderFooterView (HSignal)
- (HTableCellSignalBlock)signalBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSignalBlock:(HTableCellSignalBlock)signalBlock {
    objc_setAssociatedObject(self, @selector(signalBlock), signalBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isHeader {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIsHeader:(BOOL)isHeader {
    objc_setAssociatedObject(self, @selector(isHeader), @(isHeader), OBJC_ASSOCIATION_ASSIGN);
}
@end
