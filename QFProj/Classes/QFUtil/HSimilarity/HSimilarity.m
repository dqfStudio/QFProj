//
//  HSimilarity.m
//  QFProj
//
//  Created by dqf on 2018/5/18.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HSimilarity.h"

#define KImageSize1 10
#define KImageSize2 100

typedef enum HSimilarityType {
    HSimilaritySize1,
    HSimilaritySize2
}HSimilarityType;

@interface HSimilarity()
@property (nonatomic) UIImage *image1;
@property (nonatomic) UIImage *image2;
@end

@implementation HSimilarity

- (void)setCompareImage:(UIImage *)image1 image:(UIImage *)image2 {
    _image1 = image1;
    _image2 = image2;
}
- (Similarity)getSimilarityValue {
    return MAX([self getSimilarityValueWithType:HSimilaritySize1], [self getSimilarityValueWithType:HSimilaritySize2]);
}
- (Similarity)getSimilarityValueWithType:(HSimilarityType)type {
    int cursize = (type == HSimilaritySize1 ? KImageSize1 : KImageSize2);
    int ArrSize = cursize *cursize + 1,a[ArrSize],b[ArrSize],i,j,grey,sum = 0;
    CGSize size = {cursize,cursize};
    UIImage *image1 = [self reSizeImage:self.image1 toSize:size];
    UIImage *image2 = [self reSizeImage:self.image2 toSize:size];

    a[ArrSize] = 0;
    b[ArrSize] = 0;
    CGPoint point;
    for (i = 0; i < cursize; i++) {//计算a的灰度
        for (j = 0; j < cursize; j++) {
            point.x = i;
            point.y = j;
            grey = ToGrey([self UIcolorToRGB:[self colorAtPixel:point image:image1]]);
            a[cursize *i + j] = grey;
            a[ArrSize] += grey;
        }
    }
    a[ArrSize] /= (ArrSize - 1);//灰度平均值
    for (i = 0; i < cursize; i++) {//计算b的灰度
        for (j = 0; j < cursize; j++) {
            point.x = i;
            point.y = j;
            grey = ToGrey([self UIcolorToRGB:[self colorAtPixel:point image:image2]]);
            b[cursize *i + j] = grey;
            b[ArrSize] += grey;
        }
    }
    b[ArrSize] /= (ArrSize - 1);//灰度平均值
    for (i = 0; i < ArrSize; i++)//灰度分布计算
    {
        a[i] = (a[i] < a[ArrSize] ? 0 : 1);
        b[i] = (b[i] < b[ArrSize] ? 0 : 1);
    }
    ArrSize -= 1;
    for (i = 0; i < ArrSize; i++)
    {
        sum += (a[i] == b[i] ? 1 : 0);
    }
    
    return sum *1.0 / ArrSize;
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

unsigned int ToGrey(unsigned int rgb) {
    unsigned int blue   = (rgb & 0x000000FF) >> 0;
    unsigned int green  = (rgb & 0x0000FF00) >> 8;
    unsigned int red    = (rgb & 0x00FF0000) >> 16;
    return ( red *38 +  green *75 +  blue *15 )>>7;
}

- (unsigned int)UIcolorToRGB:(UIColor *)color {
    unsigned int RGB,R,G,B;
    RGB = R = G = B = 0x00000000;
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    R = r *256;
    G = g *256;
    B = b *256;
    RGB = (R << 16) | (G << 8) | B;
    return RGB;
}

- (UIColor *)colorAtPixel:(CGPoint)point image:(UIImage *)image {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    NSInteger   pointX  = trunc(point.x);
    NSInteger   pointY  = trunc(point.y);
    CGImageRef  cgImage = image.CGImage;
    NSUInteger  width   = image.size.width;
    NSUInteger  height  = image.size.height;
    int bytesPerPixel   = 4;
    int bytesPerRow     = bytesPerPixel *1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY- (CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    // Convert color values [0..255] to floats [0.0..1.0]
  
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
+ (Similarity)getSimilarityWithImage:(UIImage *)image1 image:(UIImage *)image2 {
    HSimilarity *similarity = [HSimilarity new];
    [similarity setCompareImage:image1 image:image2];
    return [similarity getSimilarityValue];
}
@end
