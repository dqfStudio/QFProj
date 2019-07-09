//
//  HTableBaseView.m
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTableBaseView.h"
#import <objc/runtime.h>

@implementation HTableBaseView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)cellSkinEvent {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.skinBlock) {
            self.skinBlock(self, (HTableView *)self.table);
        }
    });
}
- (void)setSkinBlock:(HTableViewSkinBlock)skinBlock {
    if (_skinBlock != skinBlock) {
        _skinBlock = nil;
        _skinBlock = skinBlock;
        _skinBlock(self, (HTableView *)self.table);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSkinEvent) name:KTableSkinNotify object:nil];
    }
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
    objc_setAssociatedObject(self, @selector(isHeader), @(isHeader), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
