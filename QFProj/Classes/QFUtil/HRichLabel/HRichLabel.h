//
//  HRichLabel.h
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRichLabelText.h"
#import "HTransaction.h"
#import "HAsyncLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface HRichLabel : UIView

@property (nullable, nonatomic, copy) NSString *text;

@property (nullable, nonatomic, strong) UIFont *font;
@property (nullable, nonatomic, strong) UIColor *textColor;

@property (nullable, nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic, readonly) CGSize textSize;

// default is 0.5f
@property (nonatomic) CGFloat characterSpacing;
// default is 1.5f
@property (nonatomic) CGFloat lineSpacing;
// default is 0.f, means automatically changes according to maximum font size
@property (nonatomic) CGFloat lineHeight;
// default is 0.f
@property (nonatomic) CGFloat paragraphSpacing;

// default is NSLineBreakByTruncatingTail
// not supported :NSLineBreakByTruncatingHead, NSLineBreakByTruncatingMiddle
@property (nonatomic) NSLineBreakMode lineBreakMode;


// default value is 1 (single line), 0 means no limit
@property (nonatomic) NSUInteger numberOfLines;
// default is NSTextAlignmentNatural
@property (nonatomic) NSTextAlignment textAlignment;
// default is HTextVerticalAlignmentCenter
@property (nonatomic) HTextVerticalAlignment textVerticalAlignment;

// default is UIEdgeInsetsZero
@property (nonatomic) UIEdgeInsets textInsets;
@property (nullable, nonatomic, copy) UIBezierPath *textContainerPath;

@end

NS_ASSUME_NONNULL_END

