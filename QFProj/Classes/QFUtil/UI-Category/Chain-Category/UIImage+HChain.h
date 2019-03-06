//
//  UIImage+HChain.h
//  TestProject
//
//  Created by dqf on 2018/4/24.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HChain)

+ (UIImage *(^)(NSString *name))fromName;
+ (UIImage *(^)(NSString *path))fromFile;
+ (UIImage *(^)(NSData *data))fromData;

@end

