//
//  HTupleSignal.h
//  QFProj
//
//  Created by dqf on 2018/5/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class HTupleSignal;

CG_EXTERN bool CGEdgeEqualToEdge(UIEdgeInsets edge1, UIEdgeInsets edge2);

typedef void(^HTupleCellInitBlock)(id cell);
typedef void(^HTupleCellSignalBlock)(id object, HTupleSignal *signal);

@interface HTupleSignal : NSObject
@property (nonatomic) id signal;
@property (nonatomic) NSInteger tag;
@property (nonatomic) NSString *name;
@end
