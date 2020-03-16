//
//  HUncaughtExceptionHandler.m
//  HProj
//
//  Created by dqf on 2018/7/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HUncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#include <stdatomic.h>

NSString *const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString *const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString *const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

//const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
//const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@interface HUncaughtExceptionHandler ()
@property (nonatomic) BOOL dismissed;
@end

@implementation HUncaughtExceptionHandler

+ (HUncaughtExceptionHandler *)sharedInstance {
    static HUncaughtExceptionHandler *crashHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashHandler = [[HUncaughtExceptionHandler alloc] init];
        crashHandler.dismissed = NO;
    });
    return crashHandler;
}

+ (NSArray *)backtrace {
	 void *callstack[128];
	 int frames = backtrace(callstack, 128);
	 char **strs = backtrace_symbols(callstack, frames);
	 
//     int i;
//     NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
//     for (
//         i = UncaughtExceptionHandlerSkipAddressCount;
//         i < UncaughtExceptionHandlerSkipAddressCount +
//            UncaughtExceptionHandlerReportAddressCount;
//        i++)
//     {
//         [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
//     }
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i ++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
	 free(strs);
	 
	 return backtrace;
}

//- (void)handleException:(NSException *)exception {
//
//    __block BOOL dismissed;
//    UIAlertController *alertController =
//    [UIAlertController alertControllerWithTitle:@"温馨提示"
//                                        message:[NSString stringWithFormat:
//                                                 @"You can try to continue but the application may be unstable.\n\n"
//                                                 @"Debug details follow:\n%@\n%@",
//                                                 [exception reason],
//                                                 [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//                                 preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//        dismissed = YES;
//    }]];
//
//    [alertController addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//    }]];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//
//    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
//
//    while (!dismissed) {
//        for (NSString *mode in (__bridge NSArray *)allModes) {
//            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
//        }
//    }
//
//    CFRelease(allModes);
//
//    NSSetUncaughtExceptionHandler(NULL);
//    signal(SIGABRT, SIG_DFL);
//    signal(SIGILL, SIG_DFL);
//    signal(SIGSEGV, SIG_DFL);
//    signal(SIGFPE, SIG_DFL);
//    signal(SIGBUS, SIG_DFL);
//    signal(SIGPIPE, SIG_DFL);
//
//    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
//        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
//    }else {
//        [exception raise];
//    }
//
//}
- (void)handleException:(NSException *)exception {
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSString *vcInfo = [delegate currentVCInfo];
    NSString *vcInfo = nil;
    NSArray *arr = [[exception userInfo] valueForKey:UncaughtExceptionHandlerAddressesKey];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDateString = [formatter stringFromDate:nowDate];
    NSMutableDictionary *crashs = [[NSMutableDictionary alloc] init];
    NSString *version  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleID =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    [crashs setValue:nowDateString forKey:@"time"];
    [crashs setValue:name forKey:@"name"];
    [crashs setValue:reason forKey:@"reason"];
    [crashs setValue:arr forKey:@"stackInfo"];
    [crashs setValue:vcInfo forKey:@"currentVC"];
    [crashs setValue:version forKey:@"version"];
    [crashs setValue:bundleID forKey:@"bundle"];
    [crashs setValue:appName forKey:@"appName"];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                           stringByAppendingPathComponent:@"crash"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:crashs options:NSJSONWritingPrettyPrinted error:nil ];
    [data writeToFile:cachePath atomically:YES];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    // 延时两秒退出
    double time  = 0.0;
    while (!self.dismissed) {
        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        for (NSString *mode in (NSArray *)CFBridgingRelease(allModes)) {
            CFRunLoopRunInMode((CFStringRef)CFBridgingRetain(mode), 0.001, false);
        }
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        time = (end - start) + time;
        if (time > 2) {
            self.dismissed  = YES;
        }
    }
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }else {
        [exception raise];
    }
}
@end

void HandleException(NSException *exception)
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
#pragma clang diagnostic pop
	if (exceptionCount > UncaughtExceptionMaximum) {
		return;
	}
	
	NSArray *callStack = [HUncaughtExceptionHandler backtrace];
	NSMutableDictionary *userInfo =
		[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
//    [[[HUncaughtExceptionHandler alloc] init]
//        performSelectorOnMainThread:@selector(handleException:)
//        withObject:
//            [NSException
//                exceptionWithName:[exception name]
//                reason:[exception reason]
//                userInfo:userInfo]
//        waitUntilDone:YES];
    [[HUncaughtExceptionHandler sharedInstance]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:[exception name]
      reason:[exception reason]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void SignalHandler(int signal)
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
#pragma clang diagnostic pop
	
	if (exceptionCount > UncaughtExceptionMaximum) {
		return;
	}
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                                                       forKey:UncaughtExceptionHandlerSignalKey];
	NSArray *callStack = [HUncaughtExceptionHandler backtrace];
	[userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[HUncaughtExceptionHandler alloc] init]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
				reason:
					[NSString stringWithFormat:
						NSLocalizedString(@"Signal %d was raised.", nil),
						signal]
				userInfo:
					[NSDictionary
						dictionaryWithObject:[NSNumber numberWithInt:signal]
						forKey:UncaughtExceptionHandlerSignalKey]]
		waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler(void)
{
#ifdef DEBUG
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
#endif
}

