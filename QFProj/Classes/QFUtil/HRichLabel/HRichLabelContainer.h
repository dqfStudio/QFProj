//
//  HRichLabelContainer.h
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRichLabelText.h"

NS_ASSUME_NONNULL_BEGIN

@interface HRichLabelContainer : NSObject

@property (nullable, nonatomic, copy) UIBezierPath *path;

@property (nonatomic) CGSize size;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic, readonly) CGRect innerRect;

@property (nonatomic) NSUInteger maxNumberOfRows;
@property (nonatomic) NSLineBreakMode lineBreakMode;
@property (nonatomic) HTextVerticalAlignment verticalAlignment;

+ (instancetype)container;

@end

NS_ASSUME_NONNULL_END
