//
//  UIAlertController+HUtil.h
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (HUtil)

// 显示title和一个“确定”按钮
+ (id)showAlertWithTitle:(NSString *)title;

// 显示title、message和一个“确定”按钮
+ (id)showAlertWithTitle:(NSString *)title
message:(NSString *)message;

// 显示title、message，按钮名称自定义
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle;

// 显示title和一个“确定”按钮，点击后有回调
+ (id)showAlertWithTitle:(NSString *)title
         okButtonClicked:(void (^)(void))okButtonClicked;

// 显示title和一个按钮，点击后有回调
+ (id)showAlertWithTitle:(NSString *)title
           okButtonTitle:(NSString *)okButtonTitle
         okButtonClicked:(void (^)(void))okButtonClicked;

// 显示title、message和一个“确定”按钮，点击后有回调
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
           okButtonTitle:(NSString *)okButtonTitle
         okButtonClicked:(void (^)(void))okButtonClicked;

// 完全自定义
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray *)otherButtonTitles
              completion:(void (^)(NSInteger buttonIndex))completion;

@end

