//
//  HSwitchCell.h
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HBaseCell.h"

typedef void(^Callback)(UISwitch *sender);

@interface HSwitchCell : HBaseCell
@property (nonatomic, strong) Callback callback;
@end
