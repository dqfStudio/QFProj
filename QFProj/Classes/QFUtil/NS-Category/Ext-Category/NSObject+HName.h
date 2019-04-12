//
//  NSObject+HName.h
//  TestProject
//
//  Created by dqf on 2018/8/8.
//  Copyright © 2018年 socool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HName)
- (NSString *)nameOfIvar:(id)ivar;
+ (NSString *)nameOfIvar:(id)ivar;
@end
