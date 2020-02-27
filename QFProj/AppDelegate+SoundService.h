//
//  AppDelegate+SoundService.h
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (SoundService)
@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) CGFloat musicVolume;

//播放音效
- (void)startPlayMusic;

//暂停播放背景音乐
- (void)pausePlayMusic;

//停止播放背景音乐
- (void)stopPlayMusic;

@end

NS_ASSUME_NONNULL_END
