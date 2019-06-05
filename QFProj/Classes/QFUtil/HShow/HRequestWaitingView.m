//
//  HRequestWaitingView.m
//  QFProj
//
//  Created by dqf on 2018/5/30.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HRequestWaitingView.h"

#define KWhiteTag 12341234
#define KGrayTag  43214321

@interface HRequestWaitingView ()

@property (nonatomic) UIImageView *whiteLoadingImageView;

@property (nonatomic) UIView *grayLoadingView;
@property (nonatomic) UIImageView *grayLoadingImageView;
@property (nonatomic) UILabel *grayLoadingLabel;

@property (nonatomic, weak) UIView *waitingView;

@property (nonatomic) CGRect qFrame;
@property (nonatomic) CGFloat qMarginTop;
@property (nonatomic) CGFloat qMarginBottom;
@property (nonatomic) CGFloat qOffset;
@property (nonatomic) CGFloat qRatio;
@property (nonatomic) BOOL setting;

@end

@implementation HRequestWaitingView

- (UIImageView *)whiteLoadingImageView {
    if (!_whiteLoadingImageView) {
        _whiteLoadingImageView = [UIImageView new];
        [_whiteLoadingImageView setFrame:CGRectMake(self.h_width/2-130/2, 0, 130, 33)];
        [_whiteLoadingImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_whiteLoadingImageView setTag:KWhiteTag];
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i <= 16; i++) {
            NSString *imageName = [NSString stringWithFormat:@"mgf_loading_new_%d", i];
            [images addObject:[UIImage imageNamed:imageName]];
        }
        _whiteLoadingImageView.animationImages = images;
        _whiteLoadingImageView.animationDuration = 1.0f;
    }
    return _whiteLoadingImageView;
}

- (UIView *)grayLoadingView {
    if (!_grayLoadingView) {
        _grayLoadingView = [UIView new];
        [_grayLoadingView setFrame:CGRectMake(self.h_width/2-144/2, 0, 144, 57)];
        [_grayLoadingView setTag:KGrayTag];
        [_grayLoadingView addSubview:self.grayLoadingImageView];
        [_grayLoadingView addSubview:self.grayLoadingLabel];
    }
    return _grayLoadingView;
}

- (UIImageView *)grayLoadingImageView {
    if (!_grayLoadingImageView) {
        _grayLoadingImageView = [UIImageView new];
        [_grayLoadingImageView setFrame:CGRectMake(20, 18, 21, 21)];
        [_grayLoadingImageView setContentMode:UIViewContentModeScaleAspectFit];
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i <= 16; i++) {
            NSString *imageName = [NSString stringWithFormat:@"mgf_loading_new_%d", i];
            [images addObject:[UIImage imageNamed:imageName]];
        }
        _grayLoadingImageView.animationImages = images;
        _grayLoadingImageView.animationDuration = 1.0f;
    }
    return _grayLoadingImageView;
}

- (UILabel *)grayLoadingLabel {
    if (!_grayLoadingLabel) {
        _grayLoadingLabel = [UILabel new];
        [_grayLoadingLabel setFrame:CGRectMake(61, 19, _grayLoadingView.h_width-61, 20)];
        _grayLoadingLabel.text = @"请稍候...";
    }
    return _grayLoadingLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //默认居中
        self.qRatio = 0.5;
        //默认是白色的
        self.backgroundColor = [UIColor whiteColor];
        [self.whiteLoadingImageView startAnimating];
        [self addSubview:self.whiteLoadingImageView];
        [self bringSubviewToFront:self.whiteLoadingImageView];
        self.waitingView = self.whiteLoadingImageView;
    }
    return self;
}

+ (instancetype)awakeView {
    return [[HRequestWaitingView alloc] initWithFrame:[UIScreen bounds]];
}

#pragma mark - 协议方法

- (void)resetFrame:(CGRect)frame {
    self.qFrame = frame;
}
- (void)setScreenFrame {
    self.qFrame = [UIScreen bounds];
}

- (void)setBackgroudColor:(UIColor *)color {
    self.backgroundColor = color;
}

- (void)setGrayStyle {
    self.style = MGWaitingViewStyleGray;
}
- (void)setWhiteStyle {
    self.style = MGWaitingViewStyleWhite;
}

- (void)setDesc:(NSString *)desc {
    self.grayLoadingLabel.text = desc;
}
- (void)setDescFont:(UIFont *)font {
    self.grayLoadingLabel.font = font;
}
- (void)setDescColor:(UIColor *)color {
    self.grayLoadingLabel.textColor = color;
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
    
    //设置样式
    if (self.style == MGWaitingViewStyleGray) {
        if (self.waitingView.tag != KGrayTag) {
            [self.grayLoadingImageView startAnimating];
            [self addSubview:self.grayLoadingView];
            [self bringSubviewToFront:self.grayLoadingView];
            self.waitingView = self.grayLoadingView;
            if (self.whiteLoadingImageView.superview) {
                [self.whiteLoadingImageView stopAnimating];
                [self.whiteLoadingImageView removeFromSuperview];
            }
        }
    }else if (self.style == MGWaitingViewStyleWhite) {
        if (self.waitingView.tag != KWhiteTag) {
            [self.whiteLoadingImageView startAnimating];
            [self addSubview:self.whiteLoadingImageView];
            [self bringSubviewToFront:self.whiteLoadingImageView];
            self.waitingView = self.whiteLoadingImageView;
            if (self.grayLoadingView.superview) {
                [self.grayLoadingImageView stopAnimating];
                [self.grayLoadingView removeFromSuperview];
            }
        }
    }
    
    //设置resultView的frame
    CGRect secondFrame = self.waitingView.frame;
    if (self.qRatio > 0) {
        CGFloat height = firstFrame.size.height - secondFrame.size.height;
        secondFrame.origin.y = height*self.qRatio;
    }else {
        secondFrame.origin.y = self.qOffset;
    }
    self.waitingView.frame = secondFrame;
        
    //结束设置
    self.setting = NO;
}

@end
