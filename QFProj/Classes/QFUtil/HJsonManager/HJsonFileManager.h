//
//  HJsonFileManager.h
//  QFProj
//
//  Created by wind on 2019/12/13.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJsonFileManager : NSObject
+ (instancetype)share;
+ (nullable id)resourceWithName:(NSString *)name; //加载资源
- (nullable id)resourceWithName:(NSString *)name; //加载资源
- (void)releaseResource:(NSString *)name; //释放资源
@end

NS_ASSUME_NONNULL_END
