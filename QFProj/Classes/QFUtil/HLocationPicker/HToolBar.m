//
//  HToolBar.m
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HToolBar.h"
#import "Masonry/Masonry.h"

@interface HToolBar ()
@property (nonatomic, strong, nullable) UIButton *cancleButton;
@property (nonatomic, strong, nullable) UILabel  *titleLabel;
@property (nonatomic, strong, nullable) UIButton *confirmButton;
@end

@implementation HToolBar

- (instancetype)initWithTitle:(nullable NSString *)title
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                confirmButtonTitle:(nullable NSString *)confirmButtonTitle
                    addTarget:(nullable id)target
                 cancelAction:(SEL)cancelAction
                     confirmAction:(SEL)confirmAction {
    self = [super init];
    if (self) {
        [self.titleLabel setText:title];
        
        [self.cancleButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [self.cancleButton addTarget:target action:cancelAction forControlEvents:UIControlEventTouchUpInside];
        
        [self.confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
        [self.confirmButton addTarget:target action:confirmAction forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _title = nil;
    _font = [UIFont systemFontOfSize:15];
    _titleColor = [UIColor blackColor];
    
    self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    [self setBackgroundColor:[UIColor whiteColor]];
    
    //创建
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleLabel = [[UILabel alloc] init];
    
    //添加
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancleButton];
    [self addSubview:self.confirmButton];
    
    //配置
    [self.cancleButton setTitleColor:self.titleColor forState:UIControlStateNormal];
    [self.cancleButton.titleLabel setFont:self.font];
    
    [self.confirmButton setTitleColor:self.titleColor forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:self.font];
    
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:self.titleColor];
    [self.titleLabel setFont:self.font];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //autoLayout
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(80);
        
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.right.mas_equalTo(0);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.cancleButton.mas_height);
        make.width.equalTo(self.cancleButton.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancleButton.mas_right).offset(10);
        make.right.equalTo(self.confirmButton.mas_left).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.cancleButton.mas_height);
    }];
    
}

#pragma mark - --- setters 属性 ---

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = nil;
        _title = title;
        [self.titleLabel setText:title];
    }
}

- (void)setFont:(UIFont *)font {
    if (_font != font) {
        _font = nil;
        _font = font;
        [self.cancleButton.titleLabel setFont:font];
        [self.confirmButton.titleLabel setFont:font];
        [self.titleLabel setFont:font];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (_titleColor != titleColor) {
        _titleColor = nil;
        _titleColor = titleColor;
        [self.titleLabel setTextColor:titleColor];
        [self.cancleButton setTitleColor:titleColor forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

@end
