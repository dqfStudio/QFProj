//
//  AppDelegate+UserService.m
//  QFProj
//
//  Created by wind on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate+UserService.h"

@implementation AppDelegate (UserService)

- (void)exitAccountAction:(void(^)(void))completion {
    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"是否继续退出账户？" style:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] completion:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            /*
            [HProgressHUD showLoadingWithStatus:@"正在退出..."];
            [[HNetworkManager shareManager] sendGetWithUrl:nil argument:nil success:^(id responseObject) {
                [self exitUserAction:^{
                    if (completion) {
                        completion();
                    }
                }];
            } failure:^(NSError *error) {
                [HProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            */
        }
    }];
}

- (void)exitUserAction:(void(^)(void))completion {
    /*
    [[HUserDefaults defaults] removeUser];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HProgressHUD dismiss];
        if (completion) {
            completion();
        }
    });
    */
}

@end
