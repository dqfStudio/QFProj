//
//  HFormController.h
//  QFProj
//
//  Created by dqf on 2018/5/31.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleView.h"
#import "UIView+HUtil.h"
#import "UIButton+HUtil.h"

@class HFormController;

typedef void (^HFormButtonBlock)(NSInteger index);
typedef UIView *_Nullable(^HFormHeaderBlock)(HFormController * _Nullable formController);
typedef UIView *_Nullable(^HFormFooterBlock)(HFormController * _Nullable formController);

@interface HFormController : NSObject

+ (instancetype _Nonnull )formControllerWithTitles:( NSArray * _Nonnull )titles icons:(nullable NSArray *)icons lineItems:(NSInteger)lineItems pageLines:(NSInteger)pageLines edgeInsets:(UIEdgeInsets)edgeInsets buttonBlock:(HFormButtonBlock _Nullable )buttonBlock bgColor:(UIColor *_Nullable)bgColor itemBgColor:(UIColor *_Nullable)itemBgColor tupleClass:(Class _Nullable )cls;

+ (instancetype _Nonnull )formControllerWithTitles:(NSArray * _Nonnull )titles icons:(nullable NSArray *)icons lineItems:(NSInteger)lineItems pageLines:(NSInteger)pageLines edgeInsets:(UIEdgeInsets)edgeInsets buttonBlock:(HFormButtonBlock _Nullable )buttonBlock bgColor:(UIColor *_Nullable)bgColor itemBgColor:(UIColor *_Nullable)itemBgColor tupleClass:(Class _Nullable )cls headerBlock:(HFormHeaderBlock _Nullable )headerBlock;

+ (instancetype _Nonnull )formControllerWithTitles:(NSArray * _Nonnull )titles icons:(nullable NSArray *)icons lineItems:(NSInteger)lineItems pageLines:(NSInteger)pageLines edgeInsets:(UIEdgeInsets)edgeInsets buttonBlock:(HFormButtonBlock _Nullable )buttonBlock bgColor:(UIColor *_Nullable)bgColor itemBgColor:(UIColor *_Nullable)itemBgColor tupleClass:(Class _Nullable )cls headerBlock:(HFormHeaderBlock _Nullable )headerBlock footerBlock:(HFormFooterBlock _Nullable )footerBlock;

@end
