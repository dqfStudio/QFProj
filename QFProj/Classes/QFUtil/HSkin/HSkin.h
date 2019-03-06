//
//  HSkin.h
//  TestProject
//
//  Created by dqf on 2018/6/9.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIColor+HUtil.h"

#define KSkinBase   @"Base"  //默认皮肤主题
#define KSkinDark   @"dark"  //黑色皮肤主题

#define KSKinFont   @"font"  //字体皮肤
#define KSKinColor  @"color" //颜色皮肤
#define KSKinImage  @"image" //图片皮肤

@interface HSkin : NSObject
//获取当前皮肤主题
+ (NSString *)userSubject;
//设置皮肤主题
+ (void)setUserSubject:(NSString *)suject;
@end

@interface UIView (UISkin)
- (void)skin_setBackgroundColor:(NSString *)color;
@end

@interface UILabel (UISkin)
- (void)skin_setFont:(NSString *)font;
- (void)skin_setBoldFont:(NSString *)font;
- (void)skin_setTextColor:(NSString *)color;
@end

@interface UIButton (UISkin)
- (void)skin_setFont:(NSString *)font;
- (void)skin_setBoldFont:(NSString *)font;
- (void)skin_setNormalTextColor:(NSString *)color;
- (void)skin_setSelectedTextColor:(NSString *)color;
- (void)skin_setNormalImage:(NSString *)image;
- (void)skin_setSelectedImage:(NSString *)image;
@end

@interface UITextView (UISkin)
- (void)skin_setFont:(NSString *)font;
- (void)skin_setBoldFont:(NSString *)font;
- (void)skin_setTextColor:(NSString *)color;
@end

@interface UIImageView (UISkin)
- (void)skin_setImage:(NSString *)image;
@end
