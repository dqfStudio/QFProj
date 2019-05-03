//
//  HRichLabelLayout.h
//  HRichLabel
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRichLabelContainer.h"
#import "HRichLabelLine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HRichLabelLayout : NSObject

@property (nonatomic, strong, readonly) HRichLabelContainer *container;
@property (nonatomic, strong, readonly) NSAttributedString *text;
@property (nonatomic, readonly) NSRange range;

@property (nonatomic, strong, readonly) HTextInfoContainer *infoContainer;

@property (nullable, nonatomic, strong, readonly) NSArray<UIView *> *attachmentViews;
@property (nullable, nonatomic, strong, readonly) NSArray<CALayer *> *attachmentLayers;

@property (nonatomic, readonly) NSRange visibleRange;
@property (nonatomic, readonly) CGRect textBoundingRect;
@property (nonatomic, readonly) CGSize textBoundingSize;
// default is NO
@property (nonatomic) BOOL isHighlight;

+ (instancetype)layoutWithContainer:(HRichLabelContainer *)container atrributedString:(NSAttributedString *)text;

+ (instancetype)layoutWithContainer:(HRichLabelContainer *)container atrributedString:(NSAttributedString *)text range:(NSRange)range;

- (void)drawInContext:(nullable CGContextRef)context targetLayer:(CALayer *)targetLayer targetView:(UIView *)targetView cancel:(BOOL (^)(void))cancel;
@end

NS_ASSUME_NONNULL_END
