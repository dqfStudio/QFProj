//
//  HTupleSignal.h
//  QFProj
//
//  Created by dqf on 2018/5/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define KTupleSkinNotify @"tupleSkinNotify"

@class HTupleSignal;

typedef void(^HTupleCellInitBlock)(id target);
typedef void(^HTupleCellSignalBlock)(id target, HTupleSignal *signal);

@interface HTupleSignal : NSObject
@property (nonatomic) id signal;
@property (nonatomic) NSInteger tag;
@property (nonatomic) NSString *name;
@end
