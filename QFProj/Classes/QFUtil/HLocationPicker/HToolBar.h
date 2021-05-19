//
//  HToolBar.h
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HToolBar : UIView

/** 标题，default is nil */
@property(nullable, nonatomic, copy) NSString         *title;
/** 字体，default is nil (system font 17 plain) */
@property(null_resettable, nonatomic, strong) UIFont   *font;
/** 字体颜色，default is nil (text draws black) */
@property(null_resettable, nonatomic, strong) UIColor  *titleColor;
/** 4.按钮边框颜色颜色，default is RGB(205, 205, 205) */
//@property(null_resettable, nonatomic,strong) UIColor  *borderButtonColor;

- (instancetype)initWithTitle:(nullable NSString *)title
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
           confirmButtonTitle:(nullable NSString *)confirmButtonTitle
                    addTarget:(nullable id)target
                 cancelAction:(SEL)cancelAction
                confirmAction:(SEL)confirmAction;

@end

NS_ASSUME_NONNULL_END
