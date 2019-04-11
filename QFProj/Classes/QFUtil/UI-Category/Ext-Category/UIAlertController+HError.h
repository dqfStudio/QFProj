//
//  UIAlertController+HError.h
//  TestProject
//
//  Created by dqf on 2018/7/23.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (HError)
+ (void)showAlertWithMessage:(nullable NSString *)message cancel:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
