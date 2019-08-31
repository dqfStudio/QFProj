//
//  HRequestResultView.m
//  MGFundation
//
//  Created by dqf on 2018/3/29.
//  Copyright © 2018年 migu. All rights reserved.
//

#import "HRequestResultView.h"

@interface HRequestResultView ()
@property (nonatomic, weak) HResultView2 *resultView;
@property (nonatomic) HResultImageView *resultImageView;
@property (nonatomic) HResultTextView  *resultTextView;

@property (nonatomic) BOOL needDisplayImage;
@property (nonatomic) CGRect qFrame;
@property (nonatomic) CGFloat qMarginTop;
@property (nonatomic) CGFloat qMarginBottom;
@property (nonatomic) CGFloat qOffset;
@property (nonatomic) CGFloat qRatio;
@property (nonatomic) BOOL setting;
@property (nonatomic, copy) HAlertClickedBlock clickedActionBlock;
@end

@implementation HRequestResultView

- (HResultImageView *)resultImageView {
    if (!_resultImageView) _resultImageView = [HResultImageView awakeView];
    return _resultImageView;
}
- (HResultTextView *)resultTextView {
    if (!_resultTextView) _resultTextView = [HResultTextView awakeView];
    return _resultTextView;
}
+ (instancetype)awakeView {
    return [[HRequestResultView alloc] initWithFrame:[UIScreen bounds]];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.qRatio = 0.5;
        self.qMarginTop = UIDevice.topBarHeight;
        self.qMarginBottom = UIDevice.topBarHeight;
        //默认是有图片的
        self.needDisplayImage = YES;
        [self addSubview:self.resultImageView];
        [self bringSubviewToFront:self.resultImageView];
        self.resultView = self.resultImageView;
    }
    return self;
}

#pragma mark - 协议方法

- (void)resetFrame:(CGRect)frame {
    self.qFrame = frame;
}
- (void)setScreenFrame {
    self.qFrame = [UIScreen bounds];
}

- (void)setDisplayImage:(BOOL)display {
    self.needDisplayImage = display;
}

- (void)setDesc:(NSString *)desc {
    self.resultView.titleLabel.text = desc;
}
- (void)setDescFont:(UIFont *)font {
    self.resultView.titleLabel.font = font;
}
- (void)setDescColor:(UIColor *)color {
    self.resultView.titleLabel.textColor = color;
}

- (void)setDetlDesc:(NSString *)detlDesc {
    self.resultView.subTitleLabel.text = detlDesc;
}
- (void)setDetlDescFont:(UIFont *)font {
    self.resultView.subTitleLabel.font = font;
}
- (void)setDetlDescColor:(UIColor *)color {
    self.resultView.subTitleLabel.textColor = color;
}

- (void)setMarginTop:(CGFloat)marginTop {
    self.qMarginTop = marginTop;
}
- (void)setNaviMarginTop {
    self.qMarginTop = UIDevice.topBarHeight;
}

- (void)setMarginBottom:(CGFloat)marginBottom {
    self.qMarginBottom = marginBottom;
}
- (void)setToolBarMarginBottom {
    self.qMarginBottom = UIDevice.bottomBarHeight;
}

- (void)setYOffset:(CGFloat)yOffset {
    self.qOffset = yOffset;
}
- (void)setYRatio:(CGFloat)ratio {
    self.qRatio = ratio;
}
- (void)setYCenter {
    self.qRatio = 0.5;
}

- (void)setClickedBlock:(HAlertClickedBlock)showClickedBlock {
    if (self.clickedActionBlock != showClickedBlock) {
        self.clickedActionBlock = nil;
        self.clickedActionBlock = showClickedBlock;
        if (showClickedBlock) {
            __weak typeof(self) weakSelf = self;
            [self addSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
                if (weakSelf.clickedActionBlock) weakSelf.clickedActionBlock();
            }];
        }
    }
}

- (BOOL)isLoading {
    //是否在设置中
    return self.setting;
}

- (void)start {
    //开始设置
    self.setting = YES;
}

- (void)end {
    
    //设置self的frame
    CGRect firstFrame = self.qFrame;
    if (CGRectEqualToRect(firstFrame, CGRectZero)) firstFrame = self.frame;
    firstFrame.origin.y += self.qMarginTop;
    firstFrame.size.height -= self.qMarginTop;
    firstFrame.size.height -= self.qMarginBottom;
    self.frame = firstFrame;
    
    //加载界面
    if (self.needDisplayImage) {
        if (![self.resultView isKindOfClass:HResultImageView.class]) {
            [self addSubview:self.resultImageView];
            [self bringSubviewToFront:self.resultImageView];
            self.resultView = self.resultImageView;
            if (self.resultTextView.superview) {
                [self.resultTextView removeFromSuperview];
            }
        }
    }else {
        if (![self.resultView isKindOfClass:HResultTextView.class]) {
            [self addSubview:self.resultTextView];
            [self bringSubviewToFront:self.resultTextView];
            self.resultView = self.resultTextView;
            if (self.resultImageView.superview) {
                [self.resultImageView removeFromSuperview];
            }
        }
    }
    
    //设置resultView的frame
    CGRect secondFrame = self.resultView.frame;
    if (self.qRatio > 0) {
        CGFloat height = firstFrame.size.height - secondFrame.size.height;
        secondFrame.origin.y = height*self.qRatio;
    }else {
        secondFrame.origin.y = self.qOffset;
    }
    self.resultView.frame = secondFrame;
    
    //设置图片
    if (self.needDisplayImage) {
        if (_type == MGRequestResultViewTypeNoData) {
            self.resultImageView.activeImageView.image = [UIImage imageNamed:@"mgf_icon_load_nothing"];
        }else if (_type == MGRequestResultViewTypeLoadError) {
            self.resultImageView.activeImageView.image = [UIImage imageNamed:@"mgf_icon_no_server"];
        }else if (_type == MGRequestResultViewTypeNoNetwork) {
            self.resultImageView.activeImageView.image = [UIImage imageNamed:@"mgf_icon_no_network"];
        }
    }
    
    //设置文字
    if (_type == MGRequestResultViewTypeNoData) {
        self.resultView.titleLabel.text = @"这里好像什么都没有呢⋯";
        self.resultView.subTitleLabel.text = nil;
    }else if (_type == MGRequestResultViewTypeLoadError) {
        self.resultView.titleLabel.text = @"服务器开小差了，请稍后再试~";
        self.resultView.subTitleLabel.text = nil;
    }else if (_type == MGRequestResultViewTypeNoNetwork) {
        self.resultView.titleLabel.text = @"网络已断开";
        self.resultView.subTitleLabel.text = @"点击重试";
    }
    
    //结束设置
    self.setting = NO;
}

@end

@implementation HResultView2
- (UIView *)bgView {
    if (!_bgView) _bgView = [UIView new];
    return _bgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor blackColor]];
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        [_subTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_subTitleLabel setTextColor:[UIColor blackColor]];
    }
    return _subTitleLabel;
}
+ (instancetype)awakeView {
    return [HResultView2 new];
}
@end

@implementation HResultImageView
- (UIImageView *)activeImageView {
    if (!_activeImageView) _activeImageView = [UIImageView new];
    return _activeImageView;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin = CGPointZero;
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
    CGRect frame = CGRectMake([UIScreen width]/2-240/2, 0, 240, 200);
    return [[HResultImageView alloc] initWithFrame:frame];
}
@end

@implementation HResultTextView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin = CGPointZero;
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
    CGRect frame = CGRectMake([UIScreen width]/2-240/2, 0, 240, 46);
    return [[HResultTextView alloc] initWithFrame:frame];
}
@end
