//
//  AppDelegate+SoundService.m
//  QFProj
//
//  Created by wind on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "AppDelegate+SoundService.h"
#import <objc/runtime.h>

@implementation AppDelegate (SoundService)

- (AVAudioPlayer *)audioPlayer {
    AVAudioPlayer *audioPlayer = objc_getAssociatedObject(self, _cmd);
    if (!audioPlayer) {
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"music.mp3" withExtension:nil] error:&error];
         if (error == nil) {
             audioPlayer.numberOfLoops = -1;
             [audioPlayer prepareToPlay];
         }
        self.audioPlayer = audioPlayer;
    }
    return audioPlayer;
}
- (void)setAudioPlayer:(AVAudioPlayer *)audioPlayer {
    objc_setAssociatedObject(self, @selector(audioPlayer), audioPlayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)musicVolume {
   return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setMusicVolume:(CGFloat)musicVolume {
    objc_setAssociatedObject(self, @selector(musicVolume), [NSNumber numberWithFloat:musicVolume], OBJC_ASSOCIATION_ASSIGN);
}


//播放音效
- (void)startPlayMusic {
    self.audioPlayer.volume = self.musicVolume;
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
}

//暂停播放背景音乐
- (void)pausePlayMusic {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
    }
}

//停止播放背景音乐
- (void)stopPlayMusic {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
}

@end
