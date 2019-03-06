//
//  UIAlertController+HError.m
//  TestProject
//
//  Created by dqf on 2018/7/23.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "UIAlertController+HError.h"

@implementation UIAlertController (HError)
+ (void)showAlertWithMessage:(nullable NSString *)message cancel:(void (^)(void))block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { if (block) block(); }];
    [alertController addAction:cancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
