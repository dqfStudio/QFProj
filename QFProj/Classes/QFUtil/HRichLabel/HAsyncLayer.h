//
//  HAsyncLayer.h
//  HAsyncLayer
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HAsyncLayerDisplayTask : NSObject
@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);

@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL (^isCanceled)(void));

@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);
@end

@protocol HAsyncLayerDelegate <NSObject>
@required
- (HAsyncLayerDisplayTask *)newAsyncLayerDisplayTask;
@end

@interface HAsyncLayer : CALayer
// default is Yes
@property BOOL displaysAsynchronously;
@end

NS_ASSUME_NONNULL_END
