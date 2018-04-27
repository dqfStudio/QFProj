//
//  HDebugUtil.h
//  TestProject
//
//  Created by dqf on 2017/7/19.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDebugUtil : NSObject

+ (HDebugUtil *)share;
- (void)showDebugView;
- (void)hideDebugView;

@end
