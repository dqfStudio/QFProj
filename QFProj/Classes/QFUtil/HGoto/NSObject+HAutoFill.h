//
//  NSObject+HAutoFill.h
//  QFProj
//
//  Created by dqf on 2018/5/14.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGotoRuntimeSupport.h"
#import "NSObject+HMessy.h"

@interface NSObject (HAutoFill)

//if exclusive为NO(默认为NO)，没有赋值的属性为：NSString为nil,NSNumber为nil，NSDate为nil
//if exclusive为YES，没有赋值的属性默为：NSString为@"",NSNumber为@(0)，NSDate为1970年

/**
 将data赋值给model
 */
- (void)autoFillWithData:(NSData *)data;
- (void)autoFillWithData:(NSData *)data map:(NSDictionary *)mapKeys;
- (void)autoFillWithData:(NSData *)data map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive;

/**
 将json string赋值给model
 */
- (void)autoFillWithString:(NSString *)aString;
- (void)autoFillWithString:(NSString *)aString map:(NSDictionary *)mapKeys;
- (void)autoFillWithString:(NSString *)aString map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive;

/**
 将dictionary赋值给model
 */
- (void)autoFillWithParams:(NSDictionary *)params;
- (void)autoFillWithParams:(NSDictionary *)params map:(NSDictionary *)mapKeys;
- (void)autoFillWithParams:(NSDictionary *)params map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive;

@end
