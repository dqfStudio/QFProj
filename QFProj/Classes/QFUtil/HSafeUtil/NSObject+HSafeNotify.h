//
//  NSObject+HSafeNotify.h
//  TestProject
//
//  Created by dqf on 2017/9/30.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HSafeNotify)
- (void)registerNoti:(NSString *)name callback:(void(^)(NSNotification * note))callback;
- (void)postNoti:(NSString *)name;
- (void)postNoti:(NSString *)name object:(id)anObject;
@end
