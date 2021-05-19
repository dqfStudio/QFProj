//
//  HLocationPicker.h
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HSelectedLocation)(NSArray *locationArray);

@interface HLocationPicker : UIButton

@property (nonatomic, copy) HSelectedLocation selectedLocation;

//初始化回传
- (instancetype)initWithSlectedLocation:(HSelectedLocation)selectedLocation;
//显示
- (void)show;

@end
