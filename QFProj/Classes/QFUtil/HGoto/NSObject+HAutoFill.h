//
//  NSObject+HAutoFill.h
//  QFProj
//
//  Created by dqf on 2018/5/14.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGotoRuntimeSupport.h"

@interface NSObject (HAutoFill)

//if exclusive为NO(默认为NO)，没有赋值的属性为：NSString为nil,NSNumber为nil，NSDate为nil
//if exclusive为YES，没有赋值的属性默为：NSString为@"",NSNumber为@(0)，NSDate为1970年

/**
 将值赋给model，params支持data、string和dictionary
 */
+ (id)autoFill;
- (void)autoFill;
- (void)autoFill:(id)params;
- (void)autoFill:(id)params map:(NSDictionary *)mapKeys;
- (void)autoFill:(id)params map:(NSDictionary *)mapKeys exclusive:(BOOL)exclusive;

@end
