//
//  HSkinManager.h
//  QFProj
//
//  Created by wind on 2019/12/31.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSkinManager : NSObject

#pragma --mark navigation
//导航栏背景颜色
+ (UIColor *)naviBarColor;
//导航栏标题颜色
+ (UIColor *)naviBarTitleColor;
//导航栏左边控件背景颜色
+ (UIColor *)naviBarLeftColor;
//导航栏左边控件标题颜色
+ (UIColor *)naviBarLeftTitleColor;
//导航朗右边控件背景颜色
+ (UIColor *)naviBarRightColor;
//导航栏右边控件标题颜色
+ (UIColor *)naviBarRightTitleColor;
//导航栏间隔线颜色
+ (UIColor *)naviBarSeparatorColor;


#pragma --mark tabbar
//tabBar背景色
+ (UIColor *)tabBarColor;
//tabBar标题常规颜色
+ (UIColor *)tabBarTitleNormalColor;
//tabBar标题选中颜色
+ (UIColor *)tabBarTitleSelectedColor;


#pragma --mark view controller
//View controller背景颜色
+ (UIColor *)vcViewColor;


#pragma --mark tuple view
//tuple view背景色
+ (UIColor *)tupleViewColor;
//tuple view section 背景色
+ (UIColor *)tupleSectionColor;
//tuple view header 背景色
+ (UIColor *)tupleHeaderColor;
//tuple view footer 背景色
+ (UIColor *)tuplefooterColor;
//tuple view cell 背景色
+ (UIColor *)tupleCellColor;
//tuple view cell 间隔线 颜色
+ (UIColor *)tupleCellSeparatorColor;


#pragma --mark table view
//table view背景色
+ (UIColor *)tableViewColor;
//table view section 背景色
+ (UIColor *)tableSectionColor;
//table view header 背景色
+ (UIColor *)tableHeaderColor;
//table view footer 背景色
+ (UIColor *)tablefooterColor;
//table view cell 背景色
+ (UIColor *)tableCellColor;
//table view 间隔线 颜色
+ (UIColor *)tableCellSeparatorColor;


#pragma --mark label
//label背景色
+ (UIColor *)labelColor;
//label text 颜色
+ (UIColor *)labelTextColor;
//label text detail 颜色
+ (UIColor *)labelTextDetailColor;
//label text accessory 颜色
+ (UIColor *)labelTextAccessoryColor;


#pragma --mark button
//button背景色
+ (UIColor *)buttonColor;
//button text 颜色
+ (UIColor *)buttonTextColor;
//button text detail 颜色
+ (UIColor *)buttonTextDetailColor;
//button text accessory 颜色
+ (UIColor *)buttonTextAccessoryColor;


#pragma --mark textfield
//textField背景色
+ (UIColor *)textFieldColor;
//textField text 颜色
+ (UIColor *)textFieldTextColor;
//textField detail 颜色
+ (UIColor *)textFieldTextDetailColor;
//textField accessory 颜色
+ (UIColor *)textFieldTextAccessoryColor;

//textFieldPlaceholder 颜色
+ (UIColor *)textFieldPlaceholderColor;
//textFieldPlaceholder detail 颜色
+ (UIColor *)textFieldPlaceholderDetailColor;
//textFieldPlaceholder accessory 颜色
+ (UIColor *)textFieldPlaceholderAccessoryColor;

@end

NS_ASSUME_NONNULL_END
