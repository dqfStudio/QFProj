//
//  HTableSignal.h
//  QFTableProject
//
//  Created by dqf on 2018/6/2.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define KTableSkinNotify @"tableSkinNotify"

@class HTableSignal;

typedef void(^HTableCellInitBlock)(id cell);
typedef void(^HTableCellSignalBlock)(id target, HTableSignal *signal);

@interface HTableSignal : NSObject
@property (nonatomic) id signal;
@property (nonatomic) NSInteger tag;
@property (nonatomic) NSString *name;
@end
