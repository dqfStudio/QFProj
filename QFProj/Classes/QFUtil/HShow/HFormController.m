//
//  HFormController.m
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HFormController.h"

#define KTupleViewTag   1234
#define KTupleViewTag1  2234
#define KTupleViewTag2  3234
#define KTupleViewTag3  4234

@interface HFormView : UIView <HTupleViewDelegate>
@property (nonatomic, weak) HFormController *formController;
@property (nonatomic) HTupleView *tupleView;
@end

@interface HFormController ()
@property (nonatomic) UIScrollView *scrollView;
@end

@implementation HFormController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        //禁止弹簧效果
        _scrollView.bounces = NO;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.lineItems = 5;
    self.pageLines = 1;
    self.bgColor = [UIColor whiteColor];
    self.itemBgColor = [UIColor grayColor];
}

- (void)finished {
    long totalLines = getTotalLines(self.titles.count, self.lineItems);
    long totalPages = getTotalPages(totalLines, self.pageLines);
    
    CGRect frame = self.bounds;
    [self.scrollView setBackgroundColor:self.bgColor];
    [self.scrollView setContentSize:CGSizeMake(frame.size.width*totalPages, frame.size.height)];
    if (totalPages == 1) {
        HFormView *formView = [[HFormView alloc] initWithFrame:frame];
        formView.formController = self;
        [formView.tupleView setTag:KTupleViewTag];
        [self.scrollView addSubview:formView];
    }else {
        for (int i=0; i<totalPages; i++) {
            frame.origin.x = i*frame.size.width;
            HFormView *formView = [[HFormView alloc] initWithFrame:frame];
            formView.formController = self;
            [self.scrollView addSubview:formView];
            if (i==0) [formView.tupleView setTag:KTupleViewTag1];
            else if (i==1) [formView.tupleView setTag:KTupleViewTag2];
            else if (i==2) [formView.tupleView setTag:KTupleViewTag3];
        }
    }
}

@end

@implementation HFormView

- (HTupleView *)tupleView {
    if (!_tupleView) {
        _tupleView = [[HTupleView alloc] initWithFrame:self.bounds];
        _tupleView.bounces = NO;
        [_tupleView setPagingEnabled:YES];
        [_tupleView setTupleDelegate:self];
    }
    return _tupleView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tupleView];
    }
    return self;
}

- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    switch (tupleView.tag) {
        case KTupleViewTag:
            return self.formController.titles.count;
            break;
        case KTupleViewTag1:
            return self.formController.lineItems*self.formController.pageLines;
            break;
        case KTupleViewTag2: {
            long pageItems = self.formController.lineItems*self.formController.pageLines;
            if (self.formController.titles.count > pageItems*2) {
                return pageItems;
            }else {
                return self.formController.titles.count - pageItems;
            }
        }
            break;
        case KTupleViewTag3: {
            long pageItems = self.formController.lineItems*self.formController.pageLines;
            if (self.formController.titles.count > pageItems*3) {
                return pageItems;
            }else {
                return self.formController.titles.count - pageItems*2;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tupleWidth = CGRectGetWidth(tupleView.frame);
    CGFloat width  = tupleWidth/self.formController.lineItems;
    CGFloat height = width;
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.formController.edgeInsets;
}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (tupleView.tag) {
        case KTupleViewTag: {
            if (indexPath.row < self.formController.titles.count) {
                HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
                [cell setBackgroundColor:self.formController.bgColor];
                [cell.button setBackgroundColor:self.formController.itemBgColor];
                [cell.button.button setTitle:self.formController.titles[indexPath.row]];
                [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                    if (self.formController.buttonBlock) self.formController.buttonBlock(indexPath.row);
                }];
            }else {
                HViewCell *cell = itemBlock(HViewCell.class);
                [cell setBackgroundColor:self.formController.bgColor];
            }
        }
            break;
        case KTupleViewTag1: {
            if (indexPath.row < self.formController.titles.count) {
                HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
                [cell setBackgroundColor:self.formController.bgColor];
                [cell.button setBackgroundColor:self.formController.itemBgColor];
                [cell.button.button setTitle:self.formController.titles[indexPath.row]];
                [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                    if (self.formController.buttonBlock) self.formController.buttonBlock(indexPath.row);
                }];
            }else {
                HViewCell *cell = itemBlock(HViewCell.class);
                [cell setBackgroundColor:self.formController.bgColor];
            }
        }
            break;
        case KTupleViewTag2: {
            long pageItems = self.formController.lineItems*self.formController.pageLines;
            if (indexPath.row < self.formController.titles.count - pageItems) {
                HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
                [cell setBackgroundColor:self.formController.bgColor];
                [cell.button setBackgroundColor:self.formController.itemBgColor];
                [cell.button.button setTitle:self.formController.titles[indexPath.row+pageItems]];
                [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                    if (self.formController.buttonBlock) self.formController.buttonBlock(indexPath.row+pageItems);
                }];
            }else {
                HViewCell *cell = itemBlock(HViewCell.class);
                [cell setBackgroundColor:self.formController.bgColor];
            }
        }
            break;
        case KTupleViewTag3: {
            long pageItems = self.formController.lineItems*self.formController.pageLines;
            if (indexPath.row < self.formController.titles.count - pageItems*2) {
                HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
                [cell setBackgroundColor:self.formController.bgColor];
                [cell.button setBackgroundColor:self.formController.itemBgColor];
                [cell.button.button setTitle:self.formController.titles[indexPath.row+pageItems*2]];
                [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                    if (self.formController.buttonBlock) self.formController.buttonBlock(indexPath.row+pageItems*2);
                }];
            }else {
                HViewCell *cell = itemBlock(HViewCell.class);
                [cell setBackgroundColor:self.formController.bgColor];
            }
        }
            break;
        default:
            break;
    }
}

@end
