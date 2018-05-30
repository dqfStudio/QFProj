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

- (void)autoFillWithParams:(NSDictionary *)params;
- (void)autoFillWithParams:(NSDictionary *)params map:(NSDictionary *)mapKeys;

@end
