//
//  HFormController.h
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleView.h"

UIKIT_STATIC_INLINE long getTotalLines(long items, long lineItems) {
    long totalLines = 0;
    if (items%lineItems != 0) {
        totalLines = items/lineItems+1;
    }else {
        totalLines = items/lineItems;
    }
    return totalLines;
}

UIKIT_STATIC_INLINE long getTotalPages(long totalLines, long pageLines) {
    long pages = 0;
    if (totalLines%pageLines != 0) {
        pages = totalLines/pageLines+1;
    }else {
        pages = totalLines/pageLines;
    }
    return pages;
}

typedef void (^ButtonBlock)(NSInteger index);

@interface HFormController : UIView
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *icons;
@property (nonatomic) NSInteger lineItems; //一行显示几个
@property (nonatomic) NSInteger pageLines; //一页显示几行
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic, copy) ButtonBlock buttonBlock;

@property (nonatomic) UIColor *bgColor;
@property (nonatomic) UIColor *itemBgColor;

- (void)finished;

@end
