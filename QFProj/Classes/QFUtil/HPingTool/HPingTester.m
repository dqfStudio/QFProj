//
//  HPingTester.m
//  BigVPN
//
//  Created by lingxuanfeng on 2018/12/20.
//  Copyright © 2018年 lingxuanfeng. All rights reserved.
//

#import "HPingTester.h"

@interface HPingTester() {
    NSTimer *_timer;
    NSDate *_beginDate;
    NSString *_hostName;
}
@property (nonatomic) SimplePing *simplePing;
@property (nonatomic) NSMutableArray<HPingItem *> *pingItems;
@property (nonatomic, copy) HPingBlock pingBlock;

@end

@implementation HPingTester

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startPingWith:(NSString *)hostName completion:(HPingBlock)pingBlock {
    _hostName = hostName;
    self.simplePing = [[SimplePing alloc] initWithHostName:hostName];
    self.simplePing.delegate = self;
    self.simplePing.addressStyle = SimplePingAddressStyleAny;
    self.timeout = 1.5;
    self.pingItems = [NSMutableArray new];
    
    _pingBlock = pingBlock;
    [self.simplePing start];
}

- (instancetype)initWithHostName:(NSString *)hostName {
    if (self = [super init]) {
        _hostName = hostName;
        self.simplePing = [[SimplePing alloc] initWithHostName:hostName];
        self.simplePing.delegate = self;
        self.simplePing.addressStyle = SimplePingAddressStyleAny;
        self.timeout = 1.5;
        self.pingItems = [NSMutableArray new];
    }
    return self;
}

- (void)startPingWith:(HPingBlock)pingBlock {
    _pingBlock = pingBlock;
    [self.simplePing start];
}

- (BOOL)isPinging {
    return [_timer isValid];
}

- (void)stopPing {
    [_timer invalidate];
    _timer = nil;
    [self.simplePing stop];
}


- (void)actionTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendPingData) userInfo:nil repeats:YES];
}

- (void)sendPingData {
    [self.simplePing sendPingWithData:nil];
}


#pragma mark - Ping Delegate
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    [self actionTimer];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    //NSLog(@"hostname:%@, ping失败--->%@", _hostName, error);
    if (self.pingBlock) {
        self.pingBlock(_hostName, 0, error);
    }
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    HPingItem *item = [HPingItem new];
    item.sequence = sequenceNumber;
    [self.pingItems addObject:item];
    
    _beginDate = [NSDate date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeout *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.pingItems containsObject:item]) {
            //NSLog(@"hostname:%@, 超时---->", _hostName);
            [self.pingItems removeObject:item];
            if (self.pingBlock) {
                self.pingBlock(self->_hostName, 0, [NSError errorWithDomain:NSURLErrorDomain code:111 userInfo:nil]);
            }
        }
    });
}
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error {
    //NSLog(@"hostname:%@, 发包失败--->%@", _hostName, error);
    if (self.pingBlock) {
        self.pingBlock(_hostName, 0, error);
    }
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    float delayTime = [[NSDate date] timeIntervalSinceDate:_beginDate] * 1000;
    [self.pingItems enumerateObjectsUsingBlock:^(HPingItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.sequence == sequenceNumber) {
            [self.pingItems removeObject:obj];
        }
    }];
    if (self.pingBlock) {
        self.pingBlock(_hostName, delayTime, nil);
    }
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    
}

@end

@implementation HPingItem

@end
