//
//  UIButton+QFUtil.h
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (QFUtil)
- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;
- (void)setFont:(UIFont *)font;
- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)setImage:(UIImage *)image;
- (void)setBackgroundImage:(UIImage *)image;
- (void)addTarget:(id)target action:(SEL)action;

//图左文字右
- (void)imageAndTextWithSpacing:(CGFloat)spacing;
//图右文字左
- (void)textAndImageWithSpacing:(CGFloat)spacing;
@end
