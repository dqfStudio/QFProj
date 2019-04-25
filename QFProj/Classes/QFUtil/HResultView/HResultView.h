//
//  HResultView.h
//  HProjectModel1
//
//  Created by wind on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HTupleView.h"
#import "AFNetworkReachabilityManager.h"

typedef NS_ENUM(NSInteger, HResultType) {
    HResultTypeNoData, // 没有数据
    HResultTypeLoadError // 请求失败
};

typedef void (^HResultClickedBlock)(void);

@interface HResultView : UIView

+ (void)showInView:(UIView *)view withType:(HResultType)type;

+ (void)showInView:(UIView *)view
          withType:(HResultType)type
      clickedBlock:(HResultClickedBlock)clickedBlock;

+ (void)showInView:(UIView *)view
          withType:(HResultType)type
       imageHidden:(BOOL)hidden
      clickedBlock:(HResultClickedBlock)clickedBlock;

@end

@interface UIView (HResultView)
@property(nonatomic) HResultView *mgResultView;
@end
