//
//  HSpeechUtil.m
//  TestSpeech
//
//  Created by dqf on 2017/10/9.
//  Copyright © 2017年 socool. All rights reserved.
//

#import "HSpeechUtil.h"
#import <AVFoundation/AVFoundation.h>

@interface HSpeechUtil ()
@property (nonatomic) AVSpeechSynthesizer *speechSynthesizer;
@end

@implementation HSpeechUtil
+ (instancetype)share {
    static HSpeechUtil *speechUtil = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        speechUtil = [[self alloc] init];
    });
    return speechUtil;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return self;
}
+ (void)speechWords:(NSString *)words {
    if (words.length > 0) {
        @synchronized(self) {
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:words];
            utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
            [[HSpeechUtil share].speechSynthesizer speakUtterance:utterance];
        }
    }
}
@end

@implementation NSString (HSpeechUtil)
- (void(^)(void))speech {
    return ^(void) {
        [HSpeechUtil speechWords:self];
    };
}
@end
