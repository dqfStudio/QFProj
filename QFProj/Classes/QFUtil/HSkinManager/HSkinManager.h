//
//  HSkinManager.h
//  QFProj
//
//  Created by wind on 2020/1/9.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HUtil.h"

@interface HSkinManager : NSObject

#pragma --mark naviBar
//导航栏背景颜色
+ (UIColor *)naviBarColor;
+ (UIColor *)naviBarDetailColor;
+ (UIColor *)naviBarAccessoryColor;
+ (UIColor *)naviBarExtra1Color;
+ (UIColor *)naviBarExtra2Color;
//导航栏标题颜色
+ (UIColor *)naviBarTitleColor;
+ (UIColor *)naviBarTitleDetailColor;
+ (UIColor *)naviBarTitleAccessoryColor;
+ (UIColor *)naviBarTitleExtra1Color;
+ (UIColor *)naviBarTitleExtra2Color;
//导航栏左边控件背景颜色
+ (UIColor *)naviBarLeftColor;
+ (UIColor *)naviBarLeftDetailColor;
+ (UIColor *)naviBarLeftAccessoryColor;
+ (UIColor *)naviBarLeftExtra1Color;
+ (UIColor *)naviBarLeftExtra2Color;
//导航栏左边控件标题颜色
+ (UIColor *)naviBarLeftTitleColor;
+ (UIColor *)naviBarLeftTitleDetailColor;
+ (UIColor *)naviBarLeftTitleAccessoryColor;
+ (UIColor *)naviBarLeftTitleExtra1Color;
+ (UIColor *)naviBarLeftTitleExtra2Color;
//导航朗右边控件背景颜色
+ (UIColor *)naviBarRightColor;
+ (UIColor *)naviBarRightDetailColor;
+ (UIColor *)naviBarRightAccessoryColor;
+ (UIColor *)naviBarRightExtra1Color;
+ (UIColor *)naviBarRightExtra2Color;
//导航栏右边控件标题颜色
+ (UIColor *)naviBarRightTitleColor;
+ (UIColor *)naviBarRightTitleDetailColor;
+ (UIColor *)naviBarRightTitleAccessoryColor;
+ (UIColor *)naviBarRightTitleExtra1Color;
+ (UIColor *)naviBarRightTitleExtra2Color;
//导航栏间隔线颜色
+ (UIColor *)naviBarSeparatorColor;
+ (UIColor *)naviBarSeparatorDetailColor;
+ (UIColor *)naviBarSeparatorAccessoryColor;
+ (UIColor *)naviBarSeparatorExtra1Color;
+ (UIColor *)naviBarSeparatorExtra2Color;

#pragma --mark tabbar
//tabBar背景色
+ (UIColor *)tabBarColor;
+ (UIColor *)tabBarDetailColor;
+ (UIColor *)tabBarAccessoryColor;
+ (UIColor *)tabBarExtra1Color;
+ (UIColor *)tabBarExtra2Color;
//tabBar标题常规颜色
+ (UIColor *)tabBarTitleNormalColor;
+ (UIColor *)tabBarTitleNormalDetailColor;
+ (UIColor *)tabBarTitleNormalAccessoryColor;
+ (UIColor *)tabBarTitleNormalExtra1Color;
+ (UIColor *)tabBarTitleNormalExtra2Color;
//tabBar标题选中颜色
+ (UIColor *)tabBarTitleSelectedColor;
+ (UIColor *)tabBarTitleSelectedDetailColor;
+ (UIColor *)tabBarTitleSelectedAccessoryColor;
+ (UIColor *)tabBarTitleSelectedExtra1Color;
+ (UIColor *)tabBarTitleSelectedExtra2Color;

#pragma --mark view controller
//View controller背景颜色
+ (UIColor *)vcViewColor;
+ (UIColor *)vcViewDetailColor;
+ (UIColor *)vcViewAccessoryColor;
+ (UIColor *)vcViewExtra1Color;
+ (UIColor *)vcViewExtra2Color;

#pragma --mark view color
// view border color 颜色
+ (UIColor *)viewBorderColor;
+ (UIColor *)viewBorderDetailColor;
+ (UIColor *)viewBorderAccessoryColor;
+ (UIColor *)viewBorderExtra1Color;
+ (UIColor *)viewBorderExtra2Color;

// view stroke color 颜色
+ (UIColor *)viewStrokeColor;
+ (UIColor *)viewStrokeDetailColor;
+ (UIColor *)viewStrokeAccessoryColor;
+ (UIColor *)viewStrokeExtra1Color;
+ (UIColor *)viewStrokeExtra2Color;

// view line color 颜色
+ (UIColor *)viewLineColor;
+ (UIColor *)viewLineDetailColor;
+ (UIColor *)viewLineAccessoryColor;
+ (UIColor *)viewLineExtra1Color;
+ (UIColor *)viewLineExtra2Color;

#pragma --mark tuple view
//tuple view背景色
+ (UIColor *)tupleColor;
+ (UIColor *)tupleDetailColor;
+ (UIColor *)tupleAccessoryColor;
+ (UIColor *)tupleExtra1Color;
+ (UIColor *)tupleExtra2Color;
//tuple view section 背景色
+ (UIColor *)tupleSectionColor;
+ (UIColor *)tupleSectionDetailColor;
+ (UIColor *)tupleSectionAccessoryColor;
+ (UIColor *)tupleSectionExtra1Color;
+ (UIColor *)tupleSectionExtra2Color;
//tuple view header 背景色
+ (UIColor *)tupleHeaderColor;
+ (UIColor *)tupleHeaderDetailColor;
+ (UIColor *)tupleHeaderAccessoryColor;
+ (UIColor *)tupleHeaderExtra1Color;
+ (UIColor *)tupleHeaderExtra2Color;
//tuple view footer 背景色
+ (UIColor *)tupleFooterColor;
+ (UIColor *)tupleFooterDetailColor;
+ (UIColor *)tupleFooterAccessoryColor;
+ (UIColor *)tupleFooterExtra1Color;
+ (UIColor *)tupleFooterExtra2Color;
//tuple view cell 背景色
+ (UIColor *)tupleCellColor;
+ (UIColor *)tupleCellDetailColor;
+ (UIColor *)tupleCellAccessoryColor;
+ (UIColor *)tupleCellExtra1Color;
+ (UIColor *)tupleCellExtra2Color;
//tuple view cell 间隔线 颜色
+ (UIColor *)tupleCellSeparatorColor;
+ (UIColor *)tupleCellSeparatorDetailColor;
+ (UIColor *)tupleCellSeparatorAccessoryColor;
+ (UIColor *)tupleCellSeparatorExtra1Color;
+ (UIColor *)tupleCellSeparatorExtra2Color;

#pragma --mark table view
//table view背景色
+ (UIColor *)tableColor;
+ (UIColor *)tableDetailColor;
+ (UIColor *)tableAccessoryColor;
+ (UIColor *)tableExtra1Color;
+ (UIColor *)tableExtra2Color;
//table view section 背景色
+ (UIColor *)tableSectionColor;
+ (UIColor *)tableSectionDetailColor;
+ (UIColor *)tableSectionAccessoryColor;
+ (UIColor *)tableSectionExtra1Color;
+ (UIColor *)tableSectionExtra2Color;
//table view header 背景色
+ (UIColor *)tableHeaderColor;
+ (UIColor *)tableHeaderDetailColor;
+ (UIColor *)tableHeaderAccessoryColor;
+ (UIColor *)tableHeaderExtra1Color;
+ (UIColor *)tableHeaderExtra2Color;
//table view footer 背景色
+ (UIColor *)tableFooterColor;
+ (UIColor *)tableFooterDetailColor;
+ (UIColor *)tableFooterAccessoryColor;
+ (UIColor *)tableFooterExtra1Color;
+ (UIColor *)tableFooterExtra2Color;
//table view cell 背景色
+ (UIColor *)tableCellColor;
+ (UIColor *)tableCellDetailColor;
+ (UIColor *)tableCellAccessoryColor;
+ (UIColor *)tableCellExtra1Color;
+ (UIColor *)tableCellExtra2Color;
//table view cell 间隔线 颜色
+ (UIColor *)tableCellSeparatorColor;
+ (UIColor *)tableCellSeparatorDetailColor;
+ (UIColor *)tableCellSeparatorAccessoryColor;
+ (UIColor *)tableCellSeparatorExtra1Color;
+ (UIColor *)tableCellSeparatorExtra2Color;

#pragma --mark label
//label背景色
+ (UIColor *)labelColor;
+ (UIColor *)labelDetailColor;
+ (UIColor *)labelAccessoryColor;
+ (UIColor *)labelExtra1Color;
+ (UIColor *)labelExtra2Color;

//label text normal 颜色
+ (UIColor *)labelNormalColor;
+ (UIColor *)labelNormalDetailColor;
+ (UIColor *)labelNormalAccessoryColor;
+ (UIColor *)labelNormalExtra1Color;
+ (UIColor *)labelNormalExtra2Color;

//label text selected 颜色
+ (UIColor *)labelSelectedColor;
+ (UIColor *)labelSelectedDetailColor;
+ (UIColor *)labelSelectedAccessoryColor;
+ (UIColor *)labelSelectedExtra1Color;
+ (UIColor *)labelSelectedExtra2Color;

//label text highlighted 颜色
+ (UIColor *)labelHighlightedColor;
+ (UIColor *)labelHighlightedDetailColor;
+ (UIColor *)labelHighlightedAccessoryColor;
+ (UIColor *)labelHighlightedExtra1Color;
+ (UIColor *)labelHighlightedExtra2Color;

#pragma --mark button
//button背景色
+ (UIColor *)buttonColor;
+ (UIColor *)buttonDetailColor;
+ (UIColor *)buttonAccessoryColor;
+ (UIColor *)buttonExtra1Color;
+ (UIColor *)buttonExtra2Color;

// button render 颜色
+ (UIColor *)buttonRenderColor;
+ (UIColor *)buttonRenderDetailColor;
+ (UIColor *)buttonRenderAccessoryColor;
+ (UIColor *)buttonRenderExtra1Color;
+ (UIColor *)buttonRenderExtra2Color;

//button text normal 颜色
+ (UIColor *)buttonNormalColor;
+ (UIColor *)buttonNormalDetailColor;
+ (UIColor *)buttonNormalAccessoryColor;
+ (UIColor *)buttonNormalExtra1Color;
+ (UIColor *)buttonNormalExtra2Color;

//button text selected 颜色
+ (UIColor *)buttonSelectedColor;
+ (UIColor *)buttonSelectedDetailColor;
+ (UIColor *)buttonSelectedAccessoryColor;
+ (UIColor *)buttonSelectedExtra1Color;
+ (UIColor *)buttonSelectedExtra2Color;

//button text highlighted 颜色
+ (UIColor *)buttonHighlightedColor;
+ (UIColor *)buttonHighlightedDetailColor;
+ (UIColor *)buttonHighlightedAccessoryColor;
+ (UIColor *)buttonHighlightedExtra1Color;
+ (UIColor *)buttonHighlightedExtra2Color;

#pragma --mark textfield
//textField背景色
+ (UIColor *)textFieldColor;
+ (UIColor *)textFieldDetailColor;
+ (UIColor *)textFieldAccessoryColor;
+ (UIColor *)textFieldExtra1Color;
+ (UIColor *)textFieldExtra2Color;

//textField text 颜色
+ (UIColor *)textFieldTextColor;
+ (UIColor *)textFieldTextDetailColor;
+ (UIColor *)textFieldTextAccessoryColor;
+ (UIColor *)textFieldTextExtra1Color;
+ (UIColor *)textFieldTextExtra2Color;

//textFieldPlaceholder 颜色
+ (UIColor *)textFieldPlaceholderColor;
+ (UIColor *)textFieldPlaceholderDetailColor;
+ (UIColor *)textFieldPlaceholderAccessoryColor;
+ (UIColor *)textFieldPlaceholderExtra1Color;
+ (UIColor *)textFieldPlaceholderExtra2Color;

@end

@interface HSkinManager2 : NSObject

#pragma --mark navi bar
//导航栏背景颜色
+ (UIColor *)naviBarColor;
+ (UIColor *)naviBarDetailColor;
+ (UIColor *)naviBarAccessoryColor;
+ (UIColor *)naviBarExtra1Color;
+ (UIColor *)naviBarExtra2Color;
//导航栏标题颜色
+ (UIColor *)naviBarTitleColor;
+ (UIColor *)naviBarTitleDetailColor;
+ (UIColor *)naviBarTitleAccessoryColor;
+ (UIColor *)naviBarTitleExtra1Color;
+ (UIColor *)naviBarTitleExtra2Color;
//导航栏左边控件背景颜色
+ (UIColor *)naviBarLeftColor;
+ (UIColor *)naviBarLeftDetailColor;
+ (UIColor *)naviBarLeftAccessoryColor;
+ (UIColor *)naviBarLeftExtra1Color;
+ (UIColor *)naviBarLeftExtra2Color;
//导航栏左边控件标题颜色
+ (UIColor *)naviBarLeftTitleColor;
+ (UIColor *)naviBarLeftTitleDetailColor;
+ (UIColor *)naviBarLeftTitleAccessoryColor;
+ (UIColor *)naviBarLeftTitleExtra1Color;
+ (UIColor *)naviBarLeftTitleExtra2Color;
//导航朗右边控件背景颜色
+ (UIColor *)naviBarRightColor;
+ (UIColor *)naviBarRightDetailColor;
+ (UIColor *)naviBarRightAccessoryColor;
+ (UIColor *)naviBarRightExtra1Color;
+ (UIColor *)naviBarRightExtra2Color;
//导航栏右边控件标题颜色
+ (UIColor *)naviBarRightTitleColor;
+ (UIColor *)naviBarRightTitleDetailColor;
+ (UIColor *)naviBarRightTitleAccessoryColor;
+ (UIColor *)naviBarRightTitleExtra1Color;
+ (UIColor *)naviBarRightTitleExtra2Color;
//导航栏间隔线颜色
+ (UIColor *)naviBarSeparatorColor;
+ (UIColor *)naviBarSeparatorDetailColor;
+ (UIColor *)naviBarSeparatorAccessoryColor;
+ (UIColor *)naviBarSeparatorExtra1Color;
+ (UIColor *)naviBarSeparatorExtra2Color;

#pragma --mark tab bar
//tabBar背景色
+ (UIColor *)tabBarColor;
+ (UIColor *)tabBarDetailColor;
+ (UIColor *)tabBarAccessoryColor;
+ (UIColor *)tabBarExtra1Color;
+ (UIColor *)tabBarExtra2Color;
//tabBar标题常规颜色
+ (UIColor *)tabBarTitleNormalColor;
+ (UIColor *)tabBarTitleNormalDetailColor;
+ (UIColor *)tabBarTitleNormalAccessoryColor;
+ (UIColor *)tabBarTitleNormalExtra1Color;
+ (UIColor *)tabBarTitleNormalExtra2Color;
//tabBar标题选中颜色
+ (UIColor *)tabBarTitleSelectedColor;
+ (UIColor *)tabBarTitleSelectedDetailColor;
+ (UIColor *)tabBarTitleSelectedAccessoryColor;
+ (UIColor *)tabBarTitleSelectedExtra1Color;
+ (UIColor *)tabBarTitleSelectedExtra2Color;

#pragma --mark view color
//View背景颜色
+ (UIColor *)viewColor;
+ (UIColor *)viewDetailColor;
+ (UIColor *)viewAccessoryColor;
+ (UIColor *)viewExtra1Color;
+ (UIColor *)viewExtra2Color;

// view border color 颜色
+ (UIColor *)viewBorderColor;
+ (UIColor *)viewBorderDetailColor;
+ (UIColor *)viewBorderAccessoryColor;
+ (UIColor *)viewBorderExtra1Color;
+ (UIColor *)viewBorderExtra2Color;

// view stroke color 颜色
+ (UIColor *)viewStrokeColor;
+ (UIColor *)viewStrokeDetailColor;
+ (UIColor *)viewStrokeAccessoryColor;
+ (UIColor *)viewStrokeExtra1Color;
+ (UIColor *)viewStrokeExtra2Color;

// view line color 颜色
+ (UIColor *)viewLineColor;
+ (UIColor *)viewLineDetailColor;
+ (UIColor *)viewLineAccessoryColor;
+ (UIColor *)viewLineExtra1Color;
+ (UIColor *)viewLineExtra2Color;

#pragma --mark text color
//text normal 颜色
+ (UIColor *)textNormalColor;
+ (UIColor *)textNormalDetailColor;
+ (UIColor *)textNormalAccessoryColor;
+ (UIColor *)textNormalExtra1Color;
+ (UIColor *)textNormalExtra2Color;

//text selected 颜色
+ (UIColor *)textSelectedColor;
+ (UIColor *)textSelectedDetailColor;
+ (UIColor *)textSelectedAccessoryColor;
+ (UIColor *)textSelectedExtra1Color;
+ (UIColor *)textSelectedExtra2Color;

//text highlighted 颜色
+ (UIColor *)textHighlightedColor;
+ (UIColor *)textHighlightedDetailColor;
+ (UIColor *)textHighlightedAccessoryColor;
+ (UIColor *)textHighlightedExtra1Color;
+ (UIColor *)textHighlightedExtra2Color;

@end
