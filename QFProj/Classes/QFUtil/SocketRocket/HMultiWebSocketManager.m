//
//  HMultiWebSocketManager.m
//  Pro
//
//  Created by dqf on 2019/3/18.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "HMultiWebSocketManager.h"

#define KBeatDuration 4.5//心跳频率
#define KReconnectTime 3.0//重连频率
#define KMaxBeatMissCout 5//心跳丢失最大次数
#define KMaxRepeateMissCount 5//最大重试失败次数

@interface HMultiWebSocketManager()<SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, strong) NSTimer *beatTimer;
@property (nonatomic, assign) NSInteger beatMissCount;//心跳丢失次数
@property (nonatomic, assign) NSInteger repeatMissCount;//重试失败次数
@property (nonatomic, assign) BOOL needMonitorNetWorking;
@property (nonatomic, assign) BOOL closeWithUser;
@end

@implementation HMultiWebSocketManager

#pragma mark init instance
+ (instancetype)shareManager {
    static HMultiWebSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:nil] init];
        instance.webSocket = nil;
        instance.uuid = @"";
        instance.beatMissCount = 0;
        instance.repeatMissCount = 0;
        instance.needMonitorNetWorking = NO;
        instance.closeWithUser = NO;
        [[NSNotificationCenter defaultCenter] addObserver:instance
                                                 selector:@selector(networkChangeState:)
                                                     name:K_NETWORK_CHANGE_NOTIFICATION
                                                   object:nil];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [HMultiWebSocketManager shareManager] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [HMultiWebSocketManager shareManager];
}

- (void)dealloc {
    [self destoryWebSocket];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_NETWORK_CHANGE_NOTIFICATION object:nil];
}

#pragma mark connect API
- (void)connectWebSocket:(NSString *)uuid {
    self.closeWithUser = NO;
    if (![self.uuid isEqualToString:uuid]) {
        [self destoryWebSocket];
    }
    self.uuid = uuid;
    [self connect];
}

#pragma mark close API
- (void)closeSocket {
    self.closeWithUser = YES;
    [self destoryWebSocket];
}

#pragma mark send data API
- (void)sendData:(id)data {
    if (_webSocket && SR_OPEN == _webSocket.readyState) {
        [_webSocket send:data];
    }
}

#pragma mark webSocket connect
- (void)connect {
    if (_webSocket && SR_OPEN == _webSocket.readyState) {
        return;
    }
    NSString *h5Link = nil;//[HUserDefaults defaults].h5Link;
    NSString *url = @"";
    if (h5Link.length > 8) {
        if ([h5Link containsString:@"http://"]) {
            h5Link = [h5Link substringFromIndex:7];
            url = [K_Multi_HTTP_BASE_URL stringByAppendingString:h5Link];
            url = [url stringByAppendingString:@"websocket/"];
            url = [url stringByAppendingString:self.uuid];
        }else if ([h5Link containsString:@"https://"]) {
            h5Link = [h5Link substringFromIndex:8];
            url = [K_Multi_HTTPS_BASE_URL stringByAppendingString:h5Link];
            url = [url stringByAppendingString:@"websocket/"];
            url = [url stringByAppendingString:self.uuid];
        }
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    //[request setValue:self.uuid forHTTPHeaderField:@"x-db-principal"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    _webSocket.delegate = self;
    [_webSocket open];
}

- (void)reconnect {
    [self destoryWebSocket];
    if (self.closeWithUser) {
        return;
    }
    if (_repeatMissCount > KMaxRepeateMissCount) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KReconnectTime *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self connect];
    });
}

#pragma mark net work change
- (void)networkChangeState:(NSNotification *)notification {
    if (_needMonitorNetWorking) {
        NSNumber *status = notification.object;
        if (AFNetworkReachabilityStatusReachableViaWWAN == [status integerValue] ||
            AFNetworkReachabilityStatusReachableViaWiFi ==[status integerValue]) {
            _repeatMissCount = 0;
            if (nil == _webSocket || SR_OPEN != _webSocket.readyState) {
                _repeatMissCount = 0;
                [self reconnect];
            }
        }
    }
}

- (void)destoryWebSocket {
    [self resetWebSockt];
    [self beatDestory];
}
#pragma mark beating
- (void)beatingFire {
    [self beatDestory];
    _beatMissCount = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.beatTimer = [NSTimer scheduledTimerWithTimeInterval:KBeatDuration
                                                          target:self
                                                        selector:@selector(beating)
                                                        userInfo:nil
                                                         repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.beatTimer forMode:NSRunLoopCommonModes];
    });
}

- (void)beating {
    ++_beatMissCount;
    if (_beatMissCount > KMaxBeatMissCout) {
        [self reconnect];
    }else if (_webSocket && SR_OPEN  == _webSocket.readyState) {
        [_webSocket sendPing:nil];
    }
}

- (void)beatDestory {
    _beatMissCount = 0;
    if (_beatTimer) {
        [_beatTimer invalidate];
        _beatTimer = nil;
    }
}

#pragma mark webSocket reset
- (void)resetWebSockt {
    if (_webSocket) {
        [_webSocket close];
        _webSocket = nil;
    }
}

#pragma mark webSocket delegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (_webSocket == webSocket) {
        [self disposeReceiveInformation:message];
        if (self.delegate && [self.delegate respondsToSelector:@selector(webSocket:didReceiveMessage:)]) {
            [self.delegate webSocket:webSocket didReceiveMessage:message];
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    if (_webSocket == webSocket) {
        _repeatMissCount = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketDidOpen:)]) {
            [self.delegate webSocketDidOpen:webSocket];
        }
        [self beatingFire];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (_webSocket == webSocket) {
        _repeatMissCount++;
        _needMonitorNetWorking = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(webSocket:didFailWithError:)]) {
            [self.delegate webSocket:webSocket didFailWithError:error];
        }
        [self reconnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (_webSocket == webSocket) {
        _needMonitorNetWorking = YES;
        _repeatMissCount = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(webSocket:didCloseWithCode:reason:wasClean:)]) {
            [self.delegate webSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
        }
        [self reconnect];
    }
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    if (_webSocket == webSocket) {
        _beatMissCount = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(webSocket:didReceivePong:)]) {
            [self.delegate webSocket:webSocket didReceivePong:pongPayload];
        }
    }
}

#pragma mark dispose receive message
- (void)disposeReceiveInformation:(id)receive {
    if ([receive isKindOfClass:[NSString class]]) {
        NSDictionary *dic = [self dictionaryWithJsonString:receive];
        if (dic) {
            NSString *type = dic[@"eventType"];
            NSString *notification;
            if ([type isEqualToString:@"DeviceScanned"]) {
                notification = K_DEVICE_SCANNED_NOTIFICATION;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:notification object:dic[@"payload"]];
            });
        }
    }
}

#pragma mark private - json string
- (NSDictionary *)dictionaryWithJsonString:(NSString *)string {
    if (nil == string || ![string isKindOfClass:[NSString class]] || 0 == [string length]) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    if (error) {
        return nil;
    }
    return dictionary;
}

@end
