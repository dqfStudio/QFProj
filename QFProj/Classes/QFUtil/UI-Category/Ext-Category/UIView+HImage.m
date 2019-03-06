//
//  UIView+HImage.m
//  TestProj
//
//  Created by dqf on 2017/11/6.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "UIView+HImage.h"
#import <objc/runtime.h>

@interface NSString (HImage)
- (NSString *(^)(id))append;
@end

@implementation NSString (HImage)
- (NSString *(^)(id))append {
    return ^NSString *(id obj) {
        return [NSString stringWithFormat:@"%@%@", self,obj];
    };
}
@end

@interface UIImage (HImage)
- (void)toPath:(NSString *)path;
@end

@implementation UIImage (HImage)
- (void)toPath:(NSString *)path {
    [self createFileAtPath:path contents:UIImagePNGRepresentation(self) attributes:nil];
}
- (void)createFileAtPath:(NSString *)path contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr {
    
    NSArray *arr = [path pathComponents];
    //跳过lastPathComponent
    if (arr.count >= 2) {
        //循环创建文件夹
        for (NSInteger i=0; i<arr.count-1; i++) {
            NSRange range = NSMakeRange(0, i+1);
            NSArray *tmpArr = [arr subarrayWithRange:range];
            NSString *tmpPath = [NSString pathWithComponents:tmpArr];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
        }
    }
    
    //创建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:attr];
    }
    
}

@end

@implementation UIView (HImage)
- (UIImage *)createOneImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext: context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)allImagesToFolder:(NSString *)folderPath {
    NSString *subString = [folderPath substringFromIndex:folderPath.length-1];
    if (![subString isEqualToString:@"/"]) folderPath.append(@"/");

    [self allSubViews:folderPath];
}
- (void)allSubViews:(NSString *)folderPath {
    for (int i=0; i<self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        NSString *string = [NSString stringWithFormat:@"%p.png", view];
        string = folderPath.append(string);
        UIImage *image = [view createOneImage];
        [image toPath:string];
        [view allSubViews:folderPath];
    }
}
@end
