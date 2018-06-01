//
//  HRequestResultView.h
//  MGFundation
//
//  Created by dqf on 2018/3/29.
//  Copyright © 2018年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HUtil.h"
#import "HShow+Protocol.h"
#import "HCommonDefine.h"

typedef NS_ENUM(NSInteger, MGRequestResultViewType) {
    MGRequestResultViewTypeNoData, // 没有数据
    MGRequestResultViewTypeLoadError, // 请求失败
    MGRequestResultViewTypeNoNetwork  // 没有网络
};

@class HResultView,HResultImageView,HResultTextView;

@interface HRequestResultView : UIView
<HNoDataProtocol,
HNoNetworkProtocol,
HLoadErrorProtocol>

@property (nonatomic) MGRequestResultViewType type;
+ (instancetype)awakeView;

@end

@interface HResultView : UIView
@property (nonatomic) UIView  *bgView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;
+ (instancetype)awakeView;
@end

@interface HResultImageView : HResultView
@property (nonatomic) UIImageView *activeImageView;
@end

@interface HResultTextView : HResultView
@end