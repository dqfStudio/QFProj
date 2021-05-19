//
//  HRect.h
//  QFProj
//
//  Created by Wind on 2021/5/19.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRect : NSObject

@property (nonatomic, readwrite) CGFloat x;
@property (nonatomic, readwrite) CGFloat y;
@property (nonatomic, readwrite) CGFloat width;
@property (nonatomic, readwrite) CGFloat height;


@property (nonatomic, readwrite) CGPoint origin;
@property (nonatomic, readwrite) CGSize  size;


@property (nonatomic, readonly)  CGFloat  minX;
@property (nonatomic, readonly)  CGFloat  minY;


@property (nonatomic, readonly)  CGFloat  midX;
@property (nonatomic, readonly)  CGFloat  midY;


@property (nonatomic, readonly)  CGFloat  maxX;
@property (nonatomic, readonly)  CGFloat  maxY;

HRect *HRectFor(CGRect rect);
HRect *HRect2For(CGRect rect1, CGRect rect2);
HRect *HRect3For(CGRect rect1, CGRect rect2, CGRect rect3);
HRect *HRect4For(CGRect rect1, CGRect rect2, CGRect rect3, CGRect rect4);

- (CGRect)makeRect:(void(^)(HRect *make))block;
- (CGRect)makeRect2:(void(^)(HRect *make1, HRect *make2))block;
- (CGRect)makeRect3:(void(^)(HRect *make1, HRect *make2, HRect *make3))block;
- (CGRect)makeRect4:(void(^)(HRect *make1, HRect *make2, HRect *make3, HRect *make4))block;

@end
