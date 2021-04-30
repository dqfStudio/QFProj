//
//  UIImage+HUtil.h
//  HProj
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HUtil)

+ (UIImage *)imageFromName:(NSString *)aName;
+ (UIImage *)imageFromFile:(NSString *)filePath;
+ (UIImage *)imageFromData:(NSData *)imageData;

+ (UIImage *)testImage;//默认200*200
+ (UIImage *)testImage:(CGSize)size;

+ (UIImage *)mergeImage:(UIImage *)imageSource tagertImage:(UIImage *)targetImage;
+ (UIImage *)mergeImage:(UIImage *)image text:(NSString *)text font:(UIFont *)textFont color:(UIColor *)textColor;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  拉伸图片:自定义比例
 */
+ (UIImage *)resizeWithImageName:(NSString *)name leftCap:(CGFloat)leftCap topCap:(CGFloat)topCap;

/**
 *  拉伸图片
 */
+ (UIImage *)resizeWithImageName:(NSString *)name;

/**
 *  圆形图片
 */
+ (UIImage *)clipCircleImage:(NSString *)name;

/**
 *  图片缩放
 */
- (UIImage *)scaleImage:(UIImage *)image size:(CGSize)size;

/**
 *  圆形图片
 */
- (UIImage *)clipCircleImage;

/**
 *  图片宽高比例
 */
- (CGFloat)getImageHightWidthScale;

/**
 *  图片正立
 *
 */
- (UIImage *)fixOrientation;

/**
 图片缩放
 */
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size;

/**
 *  保存相册
 *
 */
- (void)savedPhotosAlbum:(void(^)(void))completeBlock failBlock:(void(^)(void))failBlock;

+ (UIImage *)compressImage:(UIImage*)sourceImage toTargetWidth:(CGFloat)targetWidth;

@end
