//
//  UIView+QFImage.h
//  TestProj
//
//  Created by dqf on 2017/11/6.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QFImage)
//根据view本身生一张图片
- (UIImage *)createOneImage;
//获取view所有子view生成图片
- (void)allImagesToFolder:(NSString *)folderPath;
@end
