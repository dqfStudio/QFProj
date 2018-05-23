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
    HTupleSignalTypeNormal = 0, //不针对任何一个item
    HTupleSignalTypeTuple, //针对tupleView
    HTupleSignalTypeAll, //针对所有item
    HTupleSignalTypeSomeOne //针对某一个item
};

@interface HTupleSignal : NSObject
@property (nonatomic) id signal;
@property (nonatomic) HTupleSignalType signalType;
@property (nonatomic) NSIndexPath *indexPath;
@end

UIKIT_STATIC_INLINE bool HTupleSignalAll(HTupleSignal *signal) {
    bool equal = false;
    if ([signal isKindOfClass:HTupleSignal.class]) {
        if (signal.signalType == HTupleSignalTypeAll) {
            equal = true;
        }
    }
    return equal;
}

UIKIT_STATIC_INLINE bool HTupleSignalSelf(HTupleSignal *signal, NSIndexPath *index) {
    bool equal = true;
    if (![signal isKindOfClass:HTupleSignal.class]) equal = false;
    else if (signal.signalType == HTupleSignalTypeSomeOne) equal = false;
    else if (signal.indexPath.section != index.section) equal = false;
    else if (signal.indexPath.row != index.row) equal = false;
    return equal;
}
