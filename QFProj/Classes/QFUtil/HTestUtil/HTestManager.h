//
//  HTestManager.h
//  QFProj
//
//  Created by dqf on 2018/5/9.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HClassManager.h"

#define KTestRegKey  @"testRegKey"
//设置key为设备的uuid
#define HTestReg(key) HReg2(KTestRegKey, key)

@interface HTestManager : NSObject

+ (HTestManager *)share;
//跳转到测试界面还是正常显示界面
- (void)jump:(void(^)(void))jumpBlock;
- (void)jumpToTest:(void(^)(void))jumpBlock else:(void(^)(void))elseBlock;
//获取uuid
- (NSString *)getUUID;

@end
