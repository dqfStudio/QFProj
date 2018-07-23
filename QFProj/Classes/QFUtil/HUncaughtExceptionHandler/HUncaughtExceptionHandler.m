//
//  HUncaughtExceptionHandler.m
//  TestProject
//
//  Created by dqf on 2018/7/23.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import "HUncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation HUncaughtExceptionHandler

+ (NSArray *)backtrace {
	 void* callstack[128];
	 int frames = backtrace(callstack, 128);
	 char **strs = backtrace_symbols(callstack, frames);
	 
	 int i;
	 NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
	 for (
	 	i = UncaughtExceptionHandlerSkipAddressCount;
	 	i < UncaughtExceptionHandlerSkipAddressCount +
			UncaughtExceptionHandlerReportAddressCount;
		i++)
	 {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
	 }
	 free(strs);
	 
	 return backtrace;
}

- (void)handleException:(NSException *)exception {
    
    __block BOOL dismissed;
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"温馨提示"
                                        message:[NSString stringWithFormat:
                                                 @"You can try to continue but the application may be unstable.\n\n"
                                                 @"Debug details follow:\n%@\n%@",
                                                 [exception reason],
                                                 [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dismissed = YES;
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
	
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
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
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum) {
		return;
	}
	
	NSArray *callStack = [HUncaughtExceptionHandler backtrace];
	NSMutableDictionary *userInfo =
		[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[HUncaughtExceptionHandler alloc] init]
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
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
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
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

