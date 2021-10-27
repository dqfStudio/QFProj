//
//  HWebButtonView.h
//  QFProj
//
//  Created by dqf on 15/8/6.
//  Copyright (c) 2015年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCommonDefine.h"
#import "HCommonBlock.h"
#import "NSError+HUtil.h"
#import "NSObject+HBlockSEL.h"
#import "UIControl+HSafeUtil.h"
#import "UIImageView+HFilletLayer.h"
#import <SDWebImage/SDWebImageManager.h>

//此类用于全工程刷新HWebButtonView
@interface HWebButtonAppearance : NSObject
+ (instancetype)appearance;
- (void)enumerateButtons:(void (^)(void))completion;
@end

@interface HWebButtonView : UIButton
@property (nonatomic) SDWebImageOptions imageOptions;
@property (nonatomic) UIImage *placeHoderImage;
@property (nonatomic) UIColor *renderColor; //父类那个tintColor有问题
@property (nonatomic) id userInfo;

@property (nonatomic) callback pressed;
@property (nonatomic) callback didGetImage;
@property (nonatomic) callback didGetError;
@property (nonatomic) callback themeSkin; //主题换肤
/**
 *  设置图片链接
 *
 *  @param url 链接
 *
 */
- (void)setImageUrl:(NSURL *)url;

/**
 *  设置图片链接,如果有缓存同步读取缓存
 *
 *  @param url           链接
 *  @param syncLoadCache 是否同步读缓存
 *
 */
- (void)setImageUrl:(NSURL *)url syncLoadCache:(BOOL)syncLoadCache;

/**
 *  设置图片链接
 *
 *  @param urlString 链接字符串
 *
 */
- (void)setImageUrlString:(NSString *)urlString;

/**
 *  设置图片链接,如果有缓存同步读取缓存
 *
 *  @param urlString           链接字符串
 *  @param syncLoadCache 是否同步读缓存
 *
 */
- (void)setImageUrlString:(NSString *)urlString syncLoadCache:(BOOL)syncLoadCache;

/**
 *  设置图片名称，通过文件的方式加载
 *
 *  @param fileName 图片名称
 */
- (void)setImageWithFile:(NSString *)fileName;

/**
 *  设置图片名称，通过imageName的方式加载
 *
 *  @param fileName 图片名称
 */
- (void)setImageWithName:(NSString *)fileName;
@end


@interface HWebButtonView (HFilletLayer)
@property (nonatomic) BOOL fillet;//是否圆角展示图片
@property (nonatomic) UIImageViewFilletStyle filletStyle;//默认居中显示
@end


@interface UIButton (HUtil)
- (void)setTitle:(NSString *)title;
- (void)setTitle2:(NSString *)title;

- (void)setTitleColor:(UIColor *)color;
- (void)setTitleColorHex:(NSString *)color;

- (void)setFont:(UIFont *)font;
- (void)setSysFont:(CGFloat)font;
- (void)setBoldSysFont:(CGFloat)font;

- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)setImage:(UIImage *)image;

- (void)setBackgroundImage:(UIImage *)image;
- (void)setBackgroundImageWithName:(NSString *)fileName;

- (void)setBackgroundColorHex:(NSString *)color;

- (void)addTarget:(id)target action:(SEL)action;
- (void)addTarget:(id)target actionBlock:(void(^)(id button))action;

//图左文字右
- (void)imageAndTextWithSpacing:(CGFloat)spacing;
//图右文字左
- (void)textAndImageWithSpacing:(CGFloat)spacing;
//图上文字下
- (void)imageUpAndTextDownWithSpacing:(CGFloat)spacing;
@end
