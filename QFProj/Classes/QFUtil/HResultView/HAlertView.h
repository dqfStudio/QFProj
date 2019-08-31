//
//  HAlertView.h
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HNaviToastView.h"
#import "HProgressHUD.h"
#import "UIAlertController+HUtil.h"
#import "HFormController.h"
#import "HAlert+Protocol.h"

@interface HToast : NSObject <HToastProtocol>
- (void)wakeup;
@end

@interface HNaviToast : NSObject <HNaviToastProtocol>
- (void)wakeup;
@end

@interface HAlert : NSObject <HAlertProtocol>
- (void)wakeup;
@end

@interface HSheet : NSObject <HSheetProtocol>
- (void)wakeup;
@end

@interface HForm : NSObject <HFormProtocol>
- (void)wakeup;
@end

