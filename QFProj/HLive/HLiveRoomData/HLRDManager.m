//
//  HLRDManager.m
//  QFProj
//
//  Created by Jovial on 2021/10/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HLRDManager.h"

/// HLiveRoomDataManager
@implementation HLRDManager

+ (HLRDManager *)defaults {
    static HLRDManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = HLRDManager.new;
    });
    return manager;
}

@end
