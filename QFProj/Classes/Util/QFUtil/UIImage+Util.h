//
//  UIImage+Util.h
//  TestProject
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

+ (UIImage *(^)(NSString *name))imageName;
+ (UIImage *(^)(NSString *path))imageFile;
+ (UIImage *(^)(NSData *data))imageData;

@end
