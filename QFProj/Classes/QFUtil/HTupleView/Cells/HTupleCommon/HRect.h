//
//  HRect.h
//  QFProj
//
//  Created by Wind on 2021/5/20.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRect : NSObject

@property (nonatomic, readwrite) CGRect   frame;
@property (nonatomic, readonly)  CGRect   bounds;

@property (nonatomic, readwrite) CGFloat  x;
@property (nonatomic, readwrite) CGFloat  y;

@property (nonatomic, readwrite) CGFloat  width;
@property (nonatomic, readwrite) CGFloat  height;

@property (nonatomic, readwrite) CGPoint  origin;
@property (nonatomic, readwrite) CGSize   size;

@property (nonatomic, readonly)  CGFloat  minX;
@property (nonatomic, readonly)  CGFloat  minY;

@property (nonatomic, readonly)  CGFloat  midX;
@property (nonatomic, readonly)  CGFloat  midY;

@property (nonatomic, readonly)  CGFloat  maxX;
@property (nonatomic, readonly)  CGFloat  maxY;

- (HRect *)new;

HRect *HRectFor(CGRect rect);

CGRect HBoundsFor(CGRect rect);

@end

NS_ASSUME_NONNULL_END
