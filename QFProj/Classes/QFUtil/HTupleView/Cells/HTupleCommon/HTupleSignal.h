//
//  HTupleSignal.h
//  QFProj
//
//  Created by dqf on 2018/5/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_OPTIONS(NSUInteger, HTupleSignalType) {
    HTupleSignalTypeNormal = 0, //不针对任何一个
    HTupleSignalTypeTuple, //针对tupleView
    HTupleSignalTypeAllItem, //针对所有item
    HTupleSignalTypeSecton, //针对某个section中的item
    HTupleSignalTypeItem, //针对某一个item
    HTupleSignalTypeDeliver  //一个item传递给另一个item
};

@interface HTupleSignal : NSObject
@property (nonatomic) id signal;
@property (nonatomic) NSInteger signalTag;
@property (nonatomic) NSString *signalName;
@property (nonatomic) HTupleSignalType signalType;
//deliverSignalType，只有当signalType == HTupleSignalTypeDeliver时需要设置此值
@property (nonatomic) HTupleSignalType deliverSignalType;
@property (nonatomic) NSIndexPath *indexPath;
@end

UIKIT_STATIC_INLINE bool HTupleSignalTuple(HTupleSignal *signal) {
    bool equal = false;
    if ([signal isKindOfClass:HTupleSignal.class]) {
        if (signal.signalType == HTupleSignalTypeTuple) {
            equal = true;
        }
    }
    return equal;
}

UIKIT_STATIC_INLINE bool HTupleSignalAll(HTupleSignal *signal) {
    bool equal = false;
    if ([signal isKindOfClass:HTupleSignal.class]) {
        if (signal.signalType == HTupleSignalTypeAllItem) {
            equal = true;
        }
    }
    return equal;
}

UIKIT_STATIC_INLINE bool HTupleSignalSection(HTupleSignal *signal, NSIndexPath *index) {
    bool equal = true;
    if (![signal isKindOfClass:HTupleSignal.class]) equal = false;
    else if (signal.signalType != HTupleSignalTypeSecton) equal = false;
    else if (signal.indexPath.section != index.section) equal = false;
    else if (signal.indexPath.row == index.row) equal = false;
    return equal;
}

UIKIT_STATIC_INLINE bool HTupleSignalSelf(HTupleSignal *signal, NSIndexPath *index) {
    bool equal = true;
    if (![signal isKindOfClass:HTupleSignal.class]) equal = false;
    else if (signal.signalType != HTupleSignalTypeItem) equal = false;
    else if (signal.indexPath.section != index.section) equal = false;
    else if (signal.indexPath.row != index.row) equal = false;
    return equal;
}

UIKIT_STATIC_INLINE bool HTupleSignalDeliver(HTupleSignal *signal) {
    bool equal = true;
    if (![signal isKindOfClass:HTupleSignal.class]) equal = false;
    else if (signal.signalType != HTupleSignalTypeDeliver) equal = false;
    return equal;
}
