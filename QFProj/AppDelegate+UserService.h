//
//  AppDelegate+UserService.h
//  QFProj
//
//  Created by wind on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "HNetworkManager.h"
#import "UIAlertController+HUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (UserService)
- (void)exitAccountAction:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
