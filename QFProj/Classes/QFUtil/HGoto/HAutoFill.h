//
//  HAutoFill.h
//  QFProj
//
//  Created by dqf on 2018/5/7.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGotoRuntimeSupport.h"
#import "QFUtilHeader.h"

@interface HAutoFill : NSObject

+ (void)autoFill:(id)cls params:(NSDictionary *)params;
+ (void)autoFill:(id)cls params:(NSDictionary *)params map:(NSDictionary *)mapKeys;

@end
