//
//  UIScrollView+HEmptyDataSetExa.m
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIScrollView+HEmptyDataSetExa.h"
#import <objc/runtime.h>

static const void *KHClickBlock = @"hClickBlock";
static const void *KHEmptyText = @"hEmptyText";
static const void *KHOffSet = @"hOffset";
static const void *KHimage = @"hEmptyImage";

@implementation UIScrollView (HEmptyDataSetExa)

#pragma mark - Getter Setter

- (HEmptyClickBlock)hClickBlock {
    return objc_getAssociatedObject(self, &KHClickBlock);
}
- (void)setHClickBlock:(HEmptyClickBlock)clickBlock {
    objc_setAssociatedObject(self, &KHClickBlock, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)hEmptyText {
    return objc_getAssociatedObject(self, &KHEmptyText);
}
- (void)setHEmptyText:(NSString *)emptyText {
    objc_setAssociatedObject(self, &KHEmptyText, emptyText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)hOffset {
    NSNumber *number = objc_getAssociatedObject(self, &KHOffSet);
    return number.floatValue;
}
- (void)setHOffset:(CGFloat)offset {
    NSNumber *number = [NSNumber numberWithDouble:offset];
    objc_setAssociatedObject(self, &KHOffSet, number, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (UIImage *)hEmptyImage {
    return objc_getAssociatedObject(self, &KHimage);
}
- (void)setHEmptyImage:(UIImage *)emptyImage {
    objc_setAssociatedObject(self, &KHimage, emptyImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setupHEmptyData:(HEmptyClickBlock)clickBlock {
    self.hClickBlock = clickBlock;
    self.hEmptyDataSetSource = self;
    if (clickBlock) {
        self.hEmptyDataSetDelegate = self;
    }
}

- (void)setupHEmptyDataText:(NSString *)text tapBlock:(HEmptyClickBlock)clickBlock {
    
    self.hClickBlock = clickBlock;
    self.hEmptyText = text;
    
    self.hEmptyDataSetSource = self;
    if (clickBlock) {
        self.hEmptyDataSetDelegate = self;
    }
}

- (void)setupHEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset tapBlock:(HEmptyClickBlock)clickBlock {
    
    self.hEmptyText = text;
    self.hOffset = offset;
    self.hClickBlock = clickBlock;
    
    self.hEmptyDataSetSource = self;
    if (clickBlock) {
        self.hEmptyDataSetDelegate = self;
    }
}

- (void)setupHEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(HEmptyClickBlock)clickBlock {

    self.hEmptyText = text;
    self.hOffset = offset;
    self.hEmptyImage = image;
    self.hClickBlock = clickBlock;
    
    self.hEmptyDataSetSource = self;
    if (clickBlock) {
        self.hEmptyDataSetDelegate = self;
    }
}


#pragma mark - HEmptyDataSetSource

// 空白界面的标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = self.hEmptyText?:@"没有找到任何数据";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 5;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 空白页的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.hEmptyImage?:[UIImage imageNamed:@"icon_tuple_nodata"];
}

//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}

// 垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.hOffset;
}


#pragma mark - HEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (self.hClickBlock) {
        self.hClickBlock();
    }
}

@end
