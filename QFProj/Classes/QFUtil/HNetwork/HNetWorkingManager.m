//
//  HNetWorkingManager.m
//  QFProj
//
//  Created by wind on 2020/1/21.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HNetWorkingManager.h"
#import "HPingTester.h"

@interface HNetWorkingManager ()
@property (nonatomic, strong) NSArray *originUrls;
@property (nonatomic, copy)   void (^handler)(NSString *);
@end

@implementation HNetWorkingManager

+ (instancetype)shareManager {
    static HNetWorkingManager *share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = [[self alloc] init];
    });
    return share;
}

#pragma mark - 查找可用URL

- (void)findUsableURL:(NSArray *)urlArr callback:(void (^)(NSString *))handler {
    if (urlArr.count == 0) {
        if (handler) {
            handler(@"");
        }
    }else {
        self.handler = handler;
        self.originUrls = [urlArr copy];
        [self loopUrlAt:0 callback:handler];
    }
}

- (void)loopUrlAt:(NSInteger)index callback:(void (^)(NSString *))handler {
    if (index >= 0 && index < self.originUrls.count) {
        NSString *url = self.originUrls[index];
        __block NSInteger indexCount = index;
        [[HPingTester sharedInstance] startPingWith:url completion:^(NSString *hostName, NSTimeInterval time, NSError *error) {
            [[HPingTester sharedInstance] stopPing];
            if (error) {
                [self loopUrlAt:++indexCount callback:handler];
            }else {
                handler([hostName mutableCopy]);
            }
        }];
    }
}

@end
