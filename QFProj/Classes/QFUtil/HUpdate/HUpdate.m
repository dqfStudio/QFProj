//
//  HUpdate.m
//  HProj
//
//  Created by dqf on 2018/11/5.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HUpdate.h"
#import "NSString+HChain.h"

#define KDefaultPrompt @"\n修复部分BUG， 优化了部分功能"

@interface HUpdate ()
@property (nonatomic) BOOL appear;
@end

@implementation HUpdate

+ (instancetype)share {
    static HUpdate *update = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        update = [[self alloc] init];
    });
    return update;
}

- (void)update {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActionNow) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self updateAction];
}

- (void)updateAction {
    if ([self needUpdate]) {
        if (self.isUpdate.length > 0) {
            if ([self.isUpdate isEqualToString:@"0"]) {
                [self updateNow];
            }else {
                [self updateLater];
            }
        }
    }
}

- (void)updateActionNow {
    if ([self needUpdate]) {
        if (self.isUpdate.length > 0) {
            if ([self.isUpdate isEqualToString:@"0"]) {
                [self updateNow];
            }
        }
    }
}

- (void)updateActionLater {
    if ([self needUpdate]) {
        if (self.isUpdate.length > 0) {
            if (![self.isUpdate isEqualToString:@"0"]) {
                [self updateLater];
            }
        }
    }
}

//强制更新
- (void)updateNow {
    if (!self.appear) {
        self.appear = YES;
        
        if (!self.content || ![self.content isKindOfClass:NSString.class]) {
            self.content = KDefaultPrompt;
        }else {
            self.content = self.content ? :KDefaultPrompt;
            NSString *tmpString = [self.content mutableCopy];
            tmpString = tmpString ? :KDefaultPrompt;
            tmpString = [tmpString replace:@" " _:@""];
            if (tmpString.length == 0) {
                self.content = KDefaultPrompt;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController showAlertWithTitle:@"版本更新提示" message:self.content style:UIAlertControllerStyleAlert cancelButtonTitle:@"确定" otherButtonTitles:nil completion:^(NSInteger buttonIndex) {
                self.appear = NO;
                self.downUrl = self.downUrl ? :@"";
                [UIApplication openURLString:self.downUrl];
            }];
            
            UIView *subView1 = alertVC.view.subviews[0];
            UIView *subView2 = subView1.subviews[0];
            UIView *subView3 = subView2.subviews[0];
            UIView *subView4 = subView3.subviews[0];
            UIView *subView5 = subView4.subviews[0];
            
            UILabel *title   = subView5.subviews[1];
            if ([title respondsToSelector:@selector(textAlignment)]) {
                title.textAlignment = NSTextAlignmentCenter;
            }
            
            UILabel *message = subView5.subviews[2];
            if ([message respondsToSelector:@selector(textAlignment)]) {
                if ([self.content isEqualToString:KDefaultPrompt] || ![self.content containsString:@"\n"]) {
                    message.textAlignment = NSTextAlignmentCenter;
                }else {
                    message.textAlignment = NSTextAlignmentLeft;
                }
            }
        });
    }
}

//可选更新
- (void)updateLater {
    if (!self.appear) {
        self.appear = YES;
        
        if (!self.content || ![self.content isKindOfClass:NSString.class]) {
            self.content = KDefaultPrompt;
        }else {
            self.content = self.content ? :KDefaultPrompt;
            NSString *tmpString = [self.content mutableCopy];
            tmpString = tmpString ? :KDefaultPrompt;
            tmpString = [tmpString replace:@" " _:@""];
            if (tmpString.length == 0) {
                self.content = KDefaultPrompt;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController showAlertWithTitle:@"版本更新提示" message:self.content style:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] completion:^(NSInteger buttonIndex) {
                self.appear = NO;
                if (buttonIndex == 1) {
                    self.downUrl = self.downUrl ? :@"";
                    [UIApplication openURLString:self.downUrl];
                }
            }];
            
            UIView *subView1 = alertVC.view.subviews[0];
            UIView *subView2 = subView1.subviews[0];
            UIView *subView3 = subView2.subviews[0];
            UIView *subView4 = subView3.subviews[0];
            UIView *subView5 = subView4.subviews[0];
            
            UILabel *title   = subView5.subviews[1];
            if ([title respondsToSelector:@selector(textAlignment)]) {
                title.textAlignment = NSTextAlignmentCenter;
            }
            
            UILabel *message = subView5.subviews[2];
            if ([message respondsToSelector:@selector(textAlignment)]) {
                if ([self.content isEqualToString:KDefaultPrompt] || ![self.content containsString:@"\n"]) {
                    message.textAlignment = NSTextAlignmentCenter;
                }else {
                    message.textAlignment = NSTextAlignmentLeft;
                }
            }
        });
    }
}

- (BOOL)needUpdate {
    
    NSString *onlineVersion = self.version;
    NSString *localVersion = [self localVersion];
    
    if ((onlineVersion && onlineVersion.length >= 5) && (localVersion && localVersion.length >= 5)) {
        
        onlineVersion = [onlineVersion replace:@" " _:@""];
        localVersion = [localVersion replace:@" " _:@""];
        
        NSArray *onlineArr = [onlineVersion componentsByString:@"."];
        NSArray *localArr = [localVersion componentsByString:@"."];
        
        if (onlineArr.count == 3 && localArr.count == 3) {
            NSString *online1 = onlineArr[0];
            NSString *online2 = onlineArr[1];
            NSString *online3 = onlineArr[2];
            
            NSString *local1 = localArr[0];
            NSString *local2 = localArr[1];
            NSString *local3 = localArr[2];
            
            if (online1.integerValue > local1.integerValue) {
                return YES;
            }else if (online1.integerValue == local1.integerValue) {
                if (online2.integerValue > local2.integerValue) {
                    return YES;
                }else if (online2.integerValue == local2.integerValue) {
                    if (online3.integerValue > local3.integerValue) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

- (NSString *)localVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
