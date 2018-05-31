//
//  HFormController.m
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HFormController.h"

#define KTupleViewTag   1234

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
        _scrollView = [[UIScrollView alloc] init];
        //禁止弹簧效果
        _scrollView.bounces = NO;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen bounds]];
    if (self) {
        CGRect tmpFrame = frame;
        tmpFrame.origin.y += tmpFrame.size.height;
        [self.scrollView setFrame:tmpFrame];
        [self setup];
        [self performSelector:@selector(loadViewAnimation) withObject:nil afterDelay:1.5];
    }
    return self;
}

- (void)loadViewAnimation {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect tmpFrame = self.scrollView.frame;
        tmpFrame.origin.y -= tmpFrame.size.height;
        [self.scrollView setFrame:tmpFrame];
    }];
}

- (void)setup {
    self.lineItems = 5;
    self.pageLines = 1;
    self.bgColor = [UIColor whiteColor];
    self.itemBgColor = [UIColor grayColor];
    self.backgroundColor = [UIColor yellowColor];
}

- (void)finished {
    long totalLines = getTotalLines(self.titles.count, self.lineItems);
    long totalPages = getTotalPages(totalLines, self.pageLines);
    
    CGRect frame = self.bounds;
    [self.scrollView setBackgroundColor:self.bgColor];
    //[self.scrollView setContentSize:CGSizeMake(frame.size.width*totalPages, frame.size.height)];
    //以下写法是为了禁止上下拖动的效果
    [self.scrollView setContentSize:CGSizeMake(frame.size.width*totalPages, 0)];
    self.scrollView.alwaysBounceVertical = NO;
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
            [formView.tupleView setTag:i];
            [self.scrollView addSubview:formView];
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
    if (tupleView.tag == KTupleViewTag) {
        return self.formController.titles.count;
    }else {
        NSInteger tag = tupleView.tag;
        long pageItems = self.formController.lineItems*self.formController.pageLines;
        if (self.formController.titles.count > pageItems*(tag+1)) {
            return pageItems;
        }else {
            return self.formController.titles.count - pageItems*tag;
        }
    }
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
    if (tupleView.tag == KTupleViewTag) {
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
    }else {
        NSInteger tag = tupleView.tag;
        long pageItems = self.formController.lineItems*self.formController.pageLines;
        if (indexPath.row < self.formController.titles.count - pageItems*tag) {
            HButtonViewCell *cell = itemBlock(HButtonViewCell.class);
            [cell setBackgroundColor:self.formController.bgColor];
            [cell.button setBackgroundColor:self.formController.itemBgColor];
            [cell.button.button setTitle:self.formController.titles[indexPath.row+pageItems*tag]];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                if (self.formController.buttonBlock) self.formController.buttonBlock(indexPath.row+pageItems*tag);
            }];
        }else {
            HViewCell *cell = itemBlock(HViewCell.class);
            [cell setBackgroundColor:self.formController.bgColor];
        }
    }
}

@end
