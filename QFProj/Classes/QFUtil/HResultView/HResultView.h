//
//  HResultView.h
//  HProjectModel1
//
//  Created by wind on 2018/12/30.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HAlert+Protocol.h"

typedef NS_ENUM(NSInteger, HResultType) {
    HResultTypeNoData, // 没有数据
    HResultTypeLoadError, // 请求失败
    HResultTypeNoNetwork // 无网络
};

@interface HResultView : UIView <HResultProtocol>
- (void)wakeup;
@end
