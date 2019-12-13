//
//  HJsonManager.h
//  QFProj
//
//  Created by wind on 2019/12/13.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJsonManager : NSObject
@property (nonatomic, readonly) NSDictionary *dictionary;
- (instancetype)initWithResource:(NSString *)name;
+ (NSDictionary *)dictionaryWithResource:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
