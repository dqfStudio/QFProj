//
//  HIFS.m
//  Pro
//
//  Created by wind on 2019/3/6.
//  Copyright © 2019年 wind. All rights reserved.
//

#import "HIFS.h"

@implementation HIFS
+ (void)interFace:(id)ifc parameter:(void *)firstParameter, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, firstParameter);
    if (firstParameter) {
        void *parameter;//依次取得所有参数
        while ((parameter = va_arg(args, void *))) {
            if (parameter) {
                NSLog(@"%@",parameter);
            }
        }
    }
    va_end(args);
}
@end
