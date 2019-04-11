//
//  UILabel+HState.h
//  QFProj
//
//  Created by dqf on 2018/5/18.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UILabelState) {
    UILabelStateNormal = 0,
    UILabelStateSelected
};

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (HState)

@property(nonatomic, getter=isSelected) BOOL selected; // default is NO

- (void)setText:(NSString *)text forState:(UILabelState)state;
- (void)setTextColor:(nullable UIColor *)color forState:(UILabelState)state;
- (void)setFont:(nullable UIFont *)font forState:(UILabelState)state;
//如果attributedText有值，则优先级高于text
- (void)setAttributedText:(NSAttributedString *)attributedText forState:(UILabelState)state;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UILabelState)state;

@end

NS_ASSUME_NONNULL_END
