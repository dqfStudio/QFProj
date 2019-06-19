//
//  UIScrollView+HEmptyDataSetExa.h
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+HEmptyDataSet.h"

typedef void(^HEmptyClickBlock)(void);

@interface UIScrollView (HEmptyDataSetExa) <HEmptyDataSetSource, HEmptyDataSetDelegate>

@property (nonatomic) HEmptyClickBlock hClickBlock;          // 点击事件
@property (nonatomic, assign) CGFloat hOffset;               // 垂直偏移量
@property (nonatomic, strong) NSString *hEmptyText;          // 空数据显示内容
@property (nonatomic, strong) UIImage *hEmptyImage;          // 空数据的图片

- (void)setupHEmptyData:(HEmptyClickBlock)clickBlock;
- (void)setupHEmptyDataText:(NSString *)text tapBlock:(HEmptyClickBlock)clickBlock;
- (void)setupHEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset tapBlock:(HEmptyClickBlock)clickBlock;
- (void)setupHEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(HEmptyClickBlock)clickBlock;

@end
