//
//  UIViewController+QFBackHandler.h
//  Vivi
//
//  Created by dqf on 5/27/15.
//  Copyright (c) 2015 socool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QFBackHandlerProtocol <NSObject>

@optional
// Override this method in UIViewController derived class to handle 'Back' button click
- (BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (QFBackHandler) <QFBackHandlerProtocol>

@end
