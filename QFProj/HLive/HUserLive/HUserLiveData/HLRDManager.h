//
//  HLRDManager.h
//  QFProj
//
//  Created by Jovial on 2021/10/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// HUserLiveDataManager

/// 管理LiveRoom中的全局数据
@interface HLRDManager : NSObject

+ (HLRDManager *)defaults;

//清空属性值
- (void)clear;

@end

NS_ASSUME_NONNULL_END
