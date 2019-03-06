//
//  HSimilarity.h
//  QFProj
//
//  Created by dqf on 2018/5/18.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef double Similarity;

@interface HSimilarity : NSObject
+ (Similarity)getSimilarityWithImage:(UIImage *)image1 image:(UIImage *)image2;
@end
