//
//  HRequestHUD.h
//  QFProj
//
//  Created by wind on 2019/3/29.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTupleView.h"

typedef NS_ENUM(NSInteger, HRequestHUDMode) {
    HRequestHUDMode1 = 0,
    HRequestHUDMode2,
    HRequestHUDMode3,
    HRequestHUDMode4,
    HRequestHUDMode5
};

@interface HRequestHUD : UIControl
@property (nonatomic) HRequestHUDMode mode;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic) BOOL displayCancelButton;

@property (nonatomic) CGSize tupleHeaderSize;
@property (nonatomic) CGSize tupleFooterSize;

@property (nonatomic) UIEdgeInsets imageEdgeInsets;
@property (nonatomic) CGSize imageSize;

@property (nonatomic) CGSize titleHeaderSize;
@property (nonatomic) CGSize titleSize;

@property (nonatomic) CGSize subTitleHeaderSize;
@property (nonatomic) CGSize subTitleSize;

@end
