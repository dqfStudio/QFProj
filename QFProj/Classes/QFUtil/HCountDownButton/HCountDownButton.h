//
//  HCountDownButton.h
//  HCountDownButton
//
//  Created by wind on 2019/3/23.
//  Copyright © 2019年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCountDownButton;

typedef NSString *(^HCountDownChanging)(HCountDownButton *countDownButton, NSUInteger second);
typedef NSString *(^HCountDownFinished)(HCountDownButton *countDownButton, NSUInteger second);
typedef void (^HTouchedCountDownButtonHandler)(HCountDownButton *countDownButton, NSInteger tag);

@interface HCountDownButton : UIButton
@property(nonatomic,strong) id userInfo;
///倒计时按钮点击回调
- (void)countDownButtonHandler:(HTouchedCountDownButtonHandler)touchedCountDownButtonHandler;
//倒计时时间改变回调
- (void)countDownChanging:(HCountDownChanging)countDownChanging;
//倒计时结束回调
- (void)countDownFinished:(HCountDownFinished)countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
///停止倒计时
- (void)stopCountDown;
@end
