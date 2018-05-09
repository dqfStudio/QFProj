//
//  HRequestResultView.m
//  MGFundation
//
//  Created by dqf on 2018/3/29.
//  Copyright © 2018年 migu. All rights reserved.
//

#import "HRequestResultView.h"
#import "NSObject+BlockSEL.h"

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface HRequestResultView ()
@property (nonatomic) BOOL needDisplayImage;
@property (nonatomic, weak) HResultView *resultView;
@end

@implementation HRequestResultView

- (HResultImageView *)resultImageView {
    if (!_resultImageView) {
        _resultImageView = [HResultImageView awakeView];
    }
    return _resultImageView;
}

- (HResultTextView *)resultTextView {
    if (!_resultTextView) {
        _resultTextView = [HResultTextView awakeView];
    }
    return _resultTextView;
}

+ (instancetype)awakeView {
    HRequestResultView *requestResultView = [[HRequestResultView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return requestResultView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setFitFrame:(CGRect)frame {
    self.frame = frame;
}

- (void)setDisplayImage:(BOOL)yn {
    [self setNeedDisplayImage:yn];
    if (yn) {
        if (![self.subviews containsObject:self.resultImageView]) {
            [self addSubview:self.resultImageView];
        }
        [self bringSubviewToFront:self.resultImageView];
        self.resultView = self.resultImageView;
        
        if ([self.subviews containsObject:self.resultTextView]) {
            [self.resultTextView removeFromSuperview];
        }
        
    }else {
        if (![self.subviews containsObject:self.resultTextView]) {
            [self addSubview:self.resultTextView];
        }
        [self bringSubviewToFront:self.resultTextView];
        self.resultView = self.resultTextView;
        
        if ([self.subviews containsObject:self.resultImageView]) {
            [self.resultImageView removeFromSuperview];
        }
    }
}

- (void)initData {
    self.qMarginTop = 0;
    self.qOffset = 0;
}

- (void)setType:(MGRequestResultViewType)type {
    _type = type;
    [self initData];
    if (self.needDisplayImage) {
        if (type == MGRequestResultViewTypeNoData) {
            self.resultImageView.activeImageView.image = [UIImage imageNamed:@"mgf_icon_load_nothing"];
        } else if (type == MGRequestResultViewTypeLoadError) {
            self.resultImageView.activeImageView.image = [UIImage imageNamed:@"mgf_icon_no_server"];
        }  else if (type == MGRequestResultViewTypeNoNetwork) {
            self.resultImageView.activeImageView.image = [UIImage imageNamed:@"mgf_icon_no_network"];
        }
    }    
    if (type == MGRequestResultViewTypeNoData) {
        self.resultView.titleLabel.text = @"这里好像什么都没有呢⋯";
        self.resultView.subTitleLabel.text = nil;
    } else if (type == MGRequestResultViewTypeLoadError) {
        self.resultView.titleLabel.text = @"服务器开小差了，请稍后再试~";
        self.resultView.subTitleLabel.text = nil;
    }  else if (type == MGRequestResultViewTypeNoNetwork) {
        self.resultView.titleLabel.text = @"网络已断开";
        self.resultView.subTitleLabel.text = @"点击重试";
    }
}

- (void)setDesc:(NSString *)desc {
    self.resultView.titleLabel.text = desc;
}

- (void)setDetlDesc:(NSString *)detlDesc {
    self.resultView.subTitleLabel.text = detlDesc;
}

- (void)setDetlDescColor:(UIColor *)color {
    self.resultView.subTitleLabel.textColor = color;
}

- (void)setMarginTop:(CGFloat)marginTop {
    self.qMarginTop = marginTop;
    CGRect frame = self.frame;
    frame.origin.y += marginTop;
    frame.size.height -= marginTop;
    self.frame = frame;
}

- (void)setYOffset:(CGFloat)yOffset {
    self.qOffset = yOffset;
}

- (void)setScreenFrame {
    [self setFitFrame:[UIScreen mainScreen].bounds];
}

- (void)setNaviMarginTop {
    CGFloat height = KIsiPhoneX ? 88.f : 64.f;
    [self setMarginTop:height];
}

- (void)setClickedBlock:(HShowClickedBlock)showClickedBlock {
    if (showClickedBlock) {
        self.clickedActionBlock  = showClickedBlock;
        __weak typeof(self) weakSelf = self;
        [self setSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
            weakSelf.clickedActionBlock();
        }];
    }
}

- (UITapGestureRecognizer *)setSingleTapGestureWithBlock:(void (^)(UITapGestureRecognizer *))block {
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:obj];
        }
    }];
    return [self addTapGestureWithNumberOfTapsRequired:1 block:block];
}

- (UITapGestureRecognizer *)addTapGestureWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                                                            block:(void (^)(UITapGestureRecognizer *))block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:[self selectorBlock:^(id weakSelf, id arg) {
        if (block) block(nil);
    }]];
    recognizer.numberOfTapsRequired = numberOfTapsRequired;
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

@end

@implementation HResultView

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
    }
    return _subTitleLabel;
}

+ (instancetype)awakeView {
    return [HResultView new];
}

@end

@implementation HResultImageView

- (UIImageView *)activeImageView {
    if (!_activeImageView) {
        _activeImageView = [UIImageView new];
    }
    return _activeImageView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.bgView setFrame:frame];
        [self.activeImageView setFrame:CGRectMake(240/2-164/2, 0, 164, 130)];
        [self.titleLabel setFrame:CGRectMake(240/2-200/2, 154, 200, 20)];
        [self.subTitleLabel setFrame:CGRectMake(240/2-200/2, 180, 200, 20)];
        
        [self.bgView addSubview:self.activeImageView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];
        [self addSubview:self.bgView];
    }
    return self;
}

+ (instancetype)awakeView {
    CGRect frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2-240/2, 0, 240, 200);
    HResultImageView *resultView = [[HResultImageView alloc] initWithFrame:frame];
    return resultView;
}

@end

@implementation HResultTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.bgView setFrame:frame];
        [self.titleLabel setFrame:CGRectMake(240/2-200/2, 0, 200, 20)];
        [self.subTitleLabel setFrame:CGRectMake(240/2-200/2, 26, 200, 20)];
        
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];
        [self addSubview:self.bgView];
    }
    return self;
}

+ (instancetype)awakeView {
    CGRect frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2-240/2, 0, 240, 46);
    HResultTextView *resultView = [[HResultTextView alloc] initWithFrame:frame];
    return resultView;
}

@end
