//
//  UILabel+HAttributeTextTapEvent.h
//  QFProj
//
//  Created by dqf on 2018/8/25.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HAttributeTapEventDelegate <NSObject>
@optional
/**
 *  HAttributeTapEventDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index;
@end

@interface YBAttributeModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic, assign) NSRange range;

@end





@interface UILabel (HAttributeTextTapEvent)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledTapEffect;

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)addAttributeTapEventWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)addAttributeTapEventWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <HAttributeTapEventDelegate> )delegate;

@end

