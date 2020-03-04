//
//  UIImage+QRCode.h
//  QFProj
//
//  Created by dqf on 2020/3/4.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface UIImage (QRCode)
/**
 *  生成二维码
 *
 *  @param data    二维码数据
 *  @param size    二维码大小
 */
+ (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size;
/**
 *  生成二维码
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param color    二维码颜色
 *  @param backgroundColor    二维码背景颜色
 */
+ (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;
/**
 *  生成带 logo 的二维码（推荐使用）
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param logoImage    logo
 *  @param ratio        logo 相对二维码的比例
 */
+ (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio;
/**
 *  生成带 logo 的二维码（拓展）
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param logoImage    logo
 *  @param ratio        logo 相对二维码的比例
 *  @param logoImageCornerRadius    logo 外边框圆角
 *  @param logoImageBorderWidth     logo 外边框宽度
 *  @param logoImageBorderColor     logo 外边框颜色
 */
+ (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio logoImageCornerRadius:(CGFloat)logoImageCornerRadius logoImageBorderWidth:(CGFloat)logoImageBorderWidth logoImageBorderColor:(UIColor *)logoImageBorderColor;

/**
 *  给图片绘制颜色
 *
 *  @param color   颜色值
 *  return 绘制颜色后的图片
 */
- (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  图片新的大小
 *
 *  @param width   固定宽带值
 *  return 图片新的大小
 */
- (CGSize)imageWithWidth:(CGFloat)width;
@end
