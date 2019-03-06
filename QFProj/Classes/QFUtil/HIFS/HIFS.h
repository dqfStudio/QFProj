//
//  HIFS.h
//  Pro
//
//  Created by wind on 2019/3/6.
//  Copyright © 2019年 wind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIFS : NSObject
//InterFace Specification， 接口规范
+ (void)interFace:(id)ifc parameter:(void *)firstParameter, ... NS_REQUIRES_NIL_TERMINATION;
@end
