//
//  HWebButtonView.h
//  PCommunityKitDemo
//
//  Created by zhangchutian on 15/8/6.
//  Copyright (c) 2015年 vstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCommonDefine.h"
#import "HCommonBlock.h"
#import "NSError+HUtil.h"
#import "UIImageView+HFilletLayer.h"

@interface HWebButtonView : UIButton
@property (nonatomic) UIColor *renderColor; //父类那个tintColor有问题
@property (nonatomic) UIImage *placeHoderImage;
@property (nonatomic) id userInfo;

@property (nonatomic) callback pressed;
@property (nonatomic) callback didGetImage;
@property (nonatomic) callback didGetError;
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

/**
 *  直接设置图片
 *
 *  @param image 图片
 */
- (void)setImage:(UIImage *)image;
@end


@interface HWebButtonView (HFilletLayer)
@property (nonatomic) BOOL fillet;//是否圆角展示图片
@property (nonatomic) UIImageViewFilletStyle filletStyle;//默认居中显示
@end
