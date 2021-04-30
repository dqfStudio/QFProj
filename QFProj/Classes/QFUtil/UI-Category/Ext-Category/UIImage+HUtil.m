//
//  UIImage+HUtil.m
//  HProj
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIImage+HUtil.h"
#import <objc/runtime.h>

static const void *CompleteBlockKey = &CompleteBlockKey;
static const void *FailBlockKey    = &FailBlockKey;

@interface UIImage ()
@property(nonatomic, copy) void(^CompleteBlock)(void);
@property(nonatomic, copy) void(^FailBlock)(void);
@end

@implementation UIImage (HUtil)

+ (UIImage *)imageFromName:(NSString *)aName {
    return [UIImage imageNamed:aName];
}

+ (UIImage *)imageFromFile:(NSString *)filePath {
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)imageFromData:(NSData *)imageData {
    return [UIImage imageWithData:imageData];
}

+ (UIImage *)testImage {
    return [self testImage:CGSizeMake(200, 200)];
}

+ (UIImage *)testImage:(CGSize)size {
    NSString *imageString = @"🏄";
    UIFont *font = [UIFont fontWithName:@"Menlo" size:size.height];
    UIImage *image = [self imageWithString:imageString font:font width:size.width textAlignment:NSTextAlignmentLeft];
    return image;
}

+ (UIImage *)imageWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width textAlignment:(NSTextAlignment)textAlignment {
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 10000)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                    attributes:attributeDic
                                       context:nil].size;
    
    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)]) {
        if (UIScreen.mainScreen.scale == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
        }else {
            UIGraphicsBeginImageContext(size);
        }
    }else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    
    CGRect rect = CGRectMake(0, 0, size.width + 1, size.height + 1);
    
    CGContextFillRect(context, rect);
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = textAlignment;
    
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName:[UIColor blackColor],
        NSFontAttributeName:font,
        NSParagraphStyleAttributeName:paragraph
    };
    
    [string drawInRect:rect withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)mergeImage:(UIImage *)imageSource tagertImage:(UIImage *)targetImage {
    
    CGSize imageSourceSize = imageSource.size;
    CGSize targetImageSize = targetImage.size;
    
    //以imgSource的图大小为画布创建上下文
    UIGraphicsBeginImageContextWithOptions(imageSourceSize, NO, UIScreen.mainScreen.scale);
    [imageSource drawInRect:CGRectMake(0, 0, imageSourceSize.width, imageSourceSize.height)];
    
    //取小图都大小targetImage
    CGFloat mixImageWidth  = MIN(targetImageSize.width, imageSourceSize.width);
    CGFloat mixImageHeight = MIN(targetImageSize.height, imageSourceSize.height);
    
    CGRect rect = CGRectMake((imageSourceSize.width - mixImageWidth)/2.0f,
                             (imageSourceSize.height - mixImageHeight)/2.0f,
                             mixImageWidth,
                             mixImageHeight);
    
    [targetImage drawInRect:rect];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIImage *)mergeImage:(UIImage *)image text:(NSString *)text font:(UIFont *)textFont color:(UIColor *)textColor {
    
    if (text == nil || text.length == 0) return image;
    
    CGSize imageSize = image.size;
    
    //以image的图大小为画布创建上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, UIScreen.mainScreen.scale);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter; //文字剧中
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName:textColor,
        NSFontAttributeName:textFont,
        NSKernAttributeName: @(0.5f), //字间距
        NSParagraphStyleAttributeName:paragraph
    };
    
    //计算文本大小
    CGRect textRect = [text boundingRectWithSize:imageSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    
    CGFloat textWidth  = textRect.size.width;
    CGFloat textHeight = textRect.size.height;
    
    //取文本的与图片大小的最小值
    CGFloat mixTextWidth  = MIN(textWidth, imageSize.width);
    CGFloat mixTextHeight = MIN(textHeight, imageSize.height);
    
    CGRect rect = CGRectMake((imageSize.width - mixTextWidth)/2.0f,
                            (imageSize.height - mixTextHeight)/2.0f,
                             mixTextWidth,
                             mixTextHeight);
    
    [text drawInRect:rect withAttributes:attributes];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  拉伸图片
 */
#pragma mark  拉伸图片:自定义比例
+ (UIImage *)resizeWithImageName:(NSString *)name leftCap:(CGFloat)leftCap topCap:(CGFloat)topCap {
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftCap topCapHeight:image.size.height * topCap];
}


#pragma mark  拉伸图片
+ (UIImage *)resizeWithImageName:(NSString *)name {
    return [self resizeWithImageName:name leftCap:.5f topCap:.5f];
    
}

+ (UIImage *)clipCircleImage:(NSString *)name {
    return [[self imageNamed:name] clipCircleImage];
}

#pragma mark 图片缩放
- (UIImage *)scaleImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark 图片切圆
- (UIImage *)clipCircleImage {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.width);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 图片比例
- (CGFloat)getImageHightWidthScale {
    return self.size.height / self.size.width;
}

#pragma mark 图片防止倒立
- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:cgimage];
    CGContextRelease(ctx);
    CGImageRelease(cgimage);
    
    return image;
}

+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size {
    CGSize originalsize = [originalImage size];
    if (originalsize.width<size.width && originalsize.height<size.height) { //原图长宽均小于标准长宽的，不作处理返回原图
        return originalImage;
    }else if (originalsize.width>size.width && originalsize.height>size.height) { //原图长宽均大于标准长宽的，按比例缩小至最大适应值
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        rate = widthRate>heightRate?heightRate:widthRate;
        CGImageRef imageRef = nil;
        
        if (heightRate>widthRate) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }else {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();

        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);

        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    }
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if (originalsize.height>size.height || originalsize.width>size.width) {
        CGImageRef imageRef = nil;
        if (originalsize.height>size.height) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }else if (originalsize.width>size.width) {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }

        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);

        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        //NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);

        return standardImage;
    }
    //原图为标准长宽的，不做处理
    else {
        return originalImage;
    }
    
}

/**
 *  保存相册
 *
 *  @param completeBlock 成功回调
 *  @param failBlock 出错回调
 */
- (void)savedPhotosAlbum:(void(^)(void))completeBlock failBlock:(void(^)(void))failBlock {
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:),NULL);
    self.CompleteBlock = completeBlock;
    self.FailBlock = failBlock;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        if (self.CompleteBlock != nil) self.CompleteBlock();
    }else {
        if(self.FailBlock !=nil) self.FailBlock();
    }
}

+ (UIImage *)compressImage:(UIImage*)sourceImage toTargetWidth:(CGFloat)targetWidth {
    //获取原图片的大小尺寸
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    //根据目标图片的宽度计算目标图片的高度
    CGFloat targetHeight = (targetWidth / width) * height;
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight), NO, [UIScreen mainScreen].scale);
    //绘制图片
    [sourceImage drawInRect:CGRectMake(0,0, targetWidth, targetHeight)];
    //从上下文中获取绘制好的图片
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

/*
 *  模拟成员变量
 */
- (void (^)(void))FailBlock{
    return objc_getAssociatedObject(self, FailBlockKey);
}
- (void)setFailBlock:(void (^)(void))FailBlock{
    objc_setAssociatedObject(self, FailBlockKey, FailBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(void))CompleteBlock{
    return objc_getAssociatedObject(self, CompleteBlockKey);
}

- (void)setCompleteBlock:(void (^)(void))CompleteBlock{
    objc_setAssociatedObject(self, CompleteBlockKey, CompleteBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
