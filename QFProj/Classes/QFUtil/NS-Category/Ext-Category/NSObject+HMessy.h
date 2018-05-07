//
//  NSObject+HMessy.h
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (HMessy)
+ (NSString *(^)(void))name;
@end

@interface NSString (HMessy)
- (BOOL)isEqualToArrayAny:(NSArray *)array;
@end

@interface NSArray (HMessy)
- (id)containsClass:(Class)cls;
@end

@interface NSNumber (HMessy)
//value需为数字型字符串
+ (NSNumber *)numberFrom:(id)value;
@end
