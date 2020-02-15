//
//  NSObject+HSafeMessy.h
//  QFProj
//
//  Created by dqf on 2019/3/20.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (HSafeMessy)
+ (NSArray *)arrayValue;
- (NSArray *)arrayValue;
+ (NSString *)stringValue;
- (NSString *)stringValue;
+ (NSUInteger)length;
- (NSUInteger)length;
+ (BOOL)isEmpty;
- (BOOL)isEmpty;
@end

@interface NSNumber (HSafeMessy)
- (NSUInteger)length;
- (BOOL)isEmpty;
@end

@interface NSString (HSafeMessy)
- (NSString *)stringValue;
- (BOOL)isEmpty;
@end

@interface NSDictionary (HSafeMessy)
- (NSArray *)arrayValue;
@end

@interface NSArray (HSafeMessy)
- (NSArray *)arrayValue;
@end
