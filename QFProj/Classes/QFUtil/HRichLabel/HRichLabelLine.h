//
//  HRichLabelLine.h
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "HRichLabelAttribute.h"
#import "HRichLabelText.h"

NS_ASSUME_NONNULL_BEGIN

@interface HRichLabelLine : NSObject

+ (instancetype)lineWithCTLine:(CTLineRef)CTLine position:(CGPoint)position point:(CGPoint)point;

- (void)configTextInfoWithWholeText:(NSAttributedString *)wholeText;

@property (nonatomic, readonly) NSAttributedString *text;
@property (nonatomic, readonly) CGPoint point;
@property (nonatomic, readonly) CTLineRef CTLine;
@property (nonatomic) NSUInteger index;
@property (nonatomic, readonly) NSRange range;

@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat bottom;
@property (nonatomic, readonly) CGFloat left;
@property (nonatomic, readonly) CGFloat right;

@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGFloat ascent;
@property (nonatomic, readonly) CGFloat descent;
@property (nonatomic, readonly) CGFloat leading;
@property (nonatomic, readonly) CGFloat lineWidth;
@property (nonatomic, readonly) CGFloat trailingWhitespaceWidth;

@property (nonatomic, strong, readonly) HTextInfoContainer *infoContainer;

@end

NS_ASSUME_NONNULL_END

