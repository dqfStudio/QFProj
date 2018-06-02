//
//  HFormController.m
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HFormController.h"

#define KTupleViewTag   1234

UIKIT_STATIC_INLINE long getTotalLines(long items, long lineItems);
UIKIT_STATIC_INLINE long getTotalPages(long totalLines, long pageLines);

@interface HFormView : UIView <HTupleViewDelegate>
@property (nonatomic, weak) HFormController *formController;
@property (nonatomic) HTupleView *tupleView;
@end

@interface HFormController ()

@property (nonatomic) Class tupleCellClass;

@property (nonatomic) UIView *bgView;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) NSArray *titles;
@property (nonatomic) NSArray *icons;
@property (nonatomic) NSInteger lineItems; //一行显示几个
@property (nonatomic) NSInteger pageLines; //一页显示几行
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic, copy) HFormButtonBlock buttonBlock;

@property (nonatomic) UIColor *bgColor;
@property (nonatomic) UIColor *itemBgColor;

@property (nonatomic) UIView *headerView;
@property (nonatomic) UIView *footerView;
@end

@implementation HFormController

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen bounds]];
    }
    return _bgView;
}
- (UIView *)contentView {
    if (!_contentView) _contentView = [UIView new];
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        //禁止弹簧效果
        _scrollView.bounces = NO;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
    }
    return _scrollView;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.lineItems = 5;
    self.pageLines = 0;
    self.bgColor = [UIColor whiteColor];
    self.itemBgColor = [UIColor grayColor];
    self.bgView.backgroundColor = [UIColor whiteColor];
}

- (void)finished {
    [self loadUI];
}

- (CGSize)getScrollViewSize {
    
    long totalLines = getTotalLines(self.titles.count, self.lineItems);
    long countLines = totalLines;
    
    if (self.pageLines == 0) self.pageLines = totalLines;
    if (totalLines > self.pageLines) countLines = self.pageLines;
    
    long height = countLines*(self.bgView.frame.size.width/self.lineItems);
    return CGSizeMake(self.bgView.frame.size.width, height);
}

- (void)resetViewFrame {
    
    CGFloat headerHeight = 0, footerHeight = 0;
    if (self.footerView) footerHeight = self.footerView.frame.size.height;
    if (self.headerView) headerHeight = self.headerView.frame.size.height;
    CGSize scrollViewSize = [self getScrollViewSize];
    CGFloat scrollViewHeight = scrollViewSize.height;
    
    //重写设置contentView的frame
    CGRect contentViewFrame = self.bgView.bounds;
    CGFloat contentViewHeight = scrollViewHeight + footerHeight + headerHeight;
    contentViewFrame.origin.y = self.bgView.bounds.size.height;
    contentViewFrame.size.height = contentViewHeight;
    [self.contentView setFrame:contentViewFrame];
    
    //重写设置headerView的frame
    if (self.headerView) {
        CGRect headerFrame = self.bgView.bounds;;
        headerFrame.size.height = headerHeight;
        [self.headerView setFrame:headerFrame];
    }
    
    //重写设置scrollView的frame
    CGRect scrollViewFrame = self.bgView.bounds;
    scrollViewFrame.origin.y = headerHeight;
    scrollViewFrame.size.height = scrollViewHeight;
    [self.scrollView setFrame:scrollViewFrame];
    
    //重写设置footerView的frame
    if (self.footerView) {
        CGRect footerFrame = self.bgView.bounds;;
        footerFrame.origin.y = headerHeight + scrollViewHeight;
        footerFrame.size.height = footerHeight;
        [self.footerView setFrame:footerFrame];
    }
}

- (void)loadUI {
    long totalLines = getTotalLines(self.titles.count, self.lineItems);
    long totalPages = getTotalPages(totalLines, self.pageLines);
    
    //重写设置frame
    [self resetViewFrame];
    
    CGRect frame = self.scrollView.bounds;
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
    
    [self.bgView addSubview:self.contentView];
    [self.contentView addSubview:self.scrollView];
    if (self.headerView) [self.contentView addSubview:self.headerView];
    if (self.footerView) [self.contentView addSubview:self.footerView];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.bgView];
    
    [self.bgView setAlpha:0];
    [self.bgView setHidden:YES];
    [self performSelector:@selector(show) withObject:nil afterDelay:0.25];
}

- (void)show {
    [self.bgView setAlpha:1];
    [self.bgView setHidden:NO];
    [UIView animateWithDuration:0.25 animations:^{
        //重写设置bgView的frame
        if (self.contentView.frame.origin.y == self.bgView.bounds.size.height) {
            CGRect bgViewFrame = self.contentView.frame;
            bgViewFrame.origin.y -= bgViewFrame.size.height;
            [self.contentView setFrame:bgViewFrame];
        }
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        //重写设置bgView的frame
        if (self.contentView.frame.origin.y < self.bgView.bounds.size.height) {
            CGRect bgViewFrame = self.contentView.frame;
            bgViewFrame.origin.y += bgViewFrame.size.height;
            [self.contentView setFrame:bgViewFrame];
        }
    } completion:^(BOOL finished) {
        [self.bgView setAlpha:0];
        [self.bgView setHidden:YES];
    }];
}

+ (instancetype)formControllerWithTitles:( NSArray * _Nonnull )titles icons:(nullable NSArray *)icons lineItems:(NSInteger)lineItems pageLines:(NSInteger)pageLines edgeInsets:(UIEdgeInsets)edgeInsets buttonBlock:(HFormButtonBlock)buttonBlock bgColor:(UIColor *)bgColor itemBgColor:(UIColor *)itemBgColor tupleClass:(Class)cls {
    HFormController *formController = [HFormController formControllerWithTitles:titles icons:icons lineItems:lineItems pageLines:pageLines edgeInsets:edgeInsets buttonBlock:buttonBlock bgColor:bgColor itemBgColor:itemBgColor tupleClass:cls headerBlock:^UIView * _Nullable(HFormController *formController) {
        return nil;
    } footerBlock:^UIView * _Nullable(HFormController *formController) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        [btn setTitle:@"取 消"];
        [btn setTitleColor:[UIColor blackColor]];
        //[btn addTarget:formController action:@selector(hide)];
        [btn addSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
            UIView *btnView = recognizer.view;
            UIView *contentView = btnView.superview;
            UIView *bgView = contentView.superview;
            [UIView animateWithDuration:0.25 animations:^{
                //重写设置bgView的frame
                if (contentView.frame.origin.y < bgView.bounds.size.height) {
                    CGRect bgViewFrame = contentView.frame;
                    bgViewFrame.origin.y += bgViewFrame.size.height;
                    [contentView setFrame:bgViewFrame];
                }
            } completion:^(BOOL finished) {
                [bgView setAlpha:0];
                [bgView setHidden:YES];
            }];
        }];
        return btn;
    }];
    return formController;
}

+ (instancetype)formControllerWithTitles:( NSArray * _Nonnull )titles icons:(nullable NSArray *)icons lineItems:(NSInteger)lineItems pageLines:(NSInteger)pageLines edgeInsets:(UIEdgeInsets)edgeInsets buttonBlock:(HFormButtonBlock)buttonBlock bgColor:(UIColor *)bgColor itemBgColor:(UIColor *)itemBgColor tupleClass:(Class)cls headerBlock:(HFormHeaderBlock)headerBlock {
    HFormController *formController = [HFormController formControllerWithTitles:titles icons:icons lineItems:lineItems pageLines:pageLines edgeInsets:edgeInsets buttonBlock:buttonBlock bgColor:bgColor itemBgColor:itemBgColor tupleClass:cls headerBlock:headerBlock footerBlock:^UIView * _Nullable(HFormController *formController) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        [btn setTitle:@"取 消"];
        [btn setTitleColor:[UIColor blackColor]];
        [btn addTarget:formController action:@selector(hide)];
        return btn;
    }];
    return formController;
}

+ (instancetype)formControllerWithTitles:(NSArray * _Nonnull )titles icons:(nullable NSArray *)icons lineItems:(NSInteger)lineItems pageLines:(NSInteger)pageLines edgeInsets:(UIEdgeInsets)edgeInsets buttonBlock:(HFormButtonBlock)buttonBlock bgColor:(UIColor *)bgColor itemBgColor:(UIColor *)itemBgColor tupleClass:(Class)cls headerBlock:(HFormHeaderBlock)headerBlock footerBlock:(HFormFooterBlock)footerBlock {
    if (!titles || titles.count == 0) return nil;
    HFormController *formController = [[HFormController alloc] init];
    formController.tupleCellClass = cls;
    formController.titles = titles;
    formController.icons = icons;
    if (lineItems > 0) formController.lineItems = lineItems;
    if (pageLines > 0) formController.pageLines = pageLines;
    if (bgColor) formController.bgColor = bgColor;
    if (itemBgColor > 0) formController.itemBgColor = itemBgColor;
    formController.edgeInsets = edgeInsets;
    formController.buttonBlock = buttonBlock;
    formController.headerView = headerBlock(formController);
    formController.footerView = footerBlock(formController);
    [formController finished];
    
    return formController;
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
            Class class = HButtonViewCell.class;
            if (self.formController.tupleCellClass) {
                class = self.formController.tupleCellClass;
            }
            HButtonViewCell *cell = itemBlock(class);
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
            Class class = HButtonViewCell.class;
            if (self.formController.tupleCellClass) {
                class = self.formController.tupleCellClass;
            }
            HButtonViewCell *cell = itemBlock(class);
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
