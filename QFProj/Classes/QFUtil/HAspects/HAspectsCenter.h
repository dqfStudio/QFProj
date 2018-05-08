//
//  HAspectsCenter.h
//  QFProj
//
//  Created by dqf on 2018/5/8.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Aspects/Aspects.h>

@interface HAspectsCenter : NSObject

+ (HAspectsCenter *)defaultCenter;

- (void)setAspects:(id)anObject forKey:(NSString *)aKey;
- (void)setAspects:(id)aspects forClass:(Class)cls;

- (void)removeAspectsForKey:(NSString *)aKey;
- (void)removeAspectsForClass:(Class)cls;

@end
