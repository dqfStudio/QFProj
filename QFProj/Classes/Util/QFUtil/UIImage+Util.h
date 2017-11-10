//
//  UIImage+Util.h
//  TestProject
//
//  Created by dqf on 2017/11/8.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

+ (UIImage *(^)(NSString *name))fromName;
+ (UIImage *(^)(NSString *path))fromFile;
+ (UIImage *(^)(NSData *data))fromData;

@end
