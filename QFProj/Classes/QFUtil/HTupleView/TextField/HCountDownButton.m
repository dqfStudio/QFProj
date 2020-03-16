//
//  HCountDownButton.m
//  HCountDownButton
//
//  Created by dqf on 2019/3/23.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "HCountDownButton.h"

@interface HCountDownButton() {
    NSInteger _second;
    NSUInteger _totalSecond;
    
    NSTimer *_timer;
    NSDate *_startDate;
    
    HCountDownChanging _countDownChanging;
    HCountDownFinished _countDownFinished;
    HTouchedCountDownButtonHandler _touchedCountDownButtonHandler;
}
@end

@implementation HCountDownButton

#pragma -mark touche action
- (void)countDownButtonHandler:(HTouchedCountDownButtonHandler)touchedCountDownButtonHandler {
    _touchedCountDownButtonHandler = [touchedCountDownButtonHandler copy];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touched:(HCountDownButton *)sender {
    if (_touchedCountDownButtonHandler && (_second <= 0 || _second == _totalSecond)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_touchedCountDownButtonHandler(sender,sender.tag);
        });
    }
}

#pragma -mark count down method
- (void)startCountDownWithSecond:(NSUInteger)totalSecond {
    _totalSecond = totalSecond;
    _second = totalSecond;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    _startDate = [NSDate date];
    _timer.fireDate = [NSDate distantPast];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)timerStart:(NSTimer *)theTimer {
     double deltaTime = [[NSDate date] timeIntervalSinceDate:_startDate];
     _second = _totalSecond- (NSInteger)(deltaTime+0.5);
    
    if (_second <= 0.0) {
        [self stopCountDown];
    }else {
        if (_countDownChanging) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = self->_countDownChanging(self,self->_second);
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateDisabled];
            });
        }else {
            NSString *title = [NSString stringWithFormat:@"%zd秒",_second];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];
        }
    }
}
- (void)stopCountDown {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];
                _second = _totalSecond;
                if (_countDownFinished) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *title = self->_countDownFinished(self,self->_totalSecond);
                        [self setTitle:title forState:UIControlStateNormal];
                        [self setTitle:title forState:UIControlStateDisabled];
                    });
                }else {
                    [self setTitle:@"重新获取" forState:UIControlStateNormal];
                    [self setTitle:@"重新获取" forState:UIControlStateDisabled];
                }
            }
        }
    }
}

#pragma -mark block
- (void)countDownChanging:(HCountDownChanging)countDownChanging {
    _countDownChanging = [countDownChanging copy];
}
- (void)countDownFinished:(HCountDownFinished)countDownFinished {
    _countDownFinished = [countDownFinished copy];
}
@end
