//
//  HMultiWebSocketManager.h
//  Pro
//
//  Created by wind on 2019/3/18.
//  Copyright © 2019年 wind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"
#import "HCommonDefine.h"
#import "SRWebSocket.h"

#define K_NETWORK_CHANGE_NOTIFICATION              @"networkChangeNotification"
#define K_DEVICE_SCANNED_NOTIFICATION              @"deviceScannedNotification"

//#define K_Multi_SOCKET_MESSAGE_BASE_URL @"ws://192.168.0.144:400/websocket/"
#define K_Multi_HTTP_BASE_URL  @"ws://"
#define K_Multi_HTTPS_BASE_URL @"wss://"

@protocol HMultiWebSokcetManagerDelegate<NSObject>
@optional
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
@end

@interface HMultiWebSocketManager : NSObject
@property (nonatomic, weak) id<HMultiWebSokcetManagerDelegate> delegate;
+ (instancetype)shareManager;
- (void)connectWebSocket:(NSString*)uuid;
- (void)closeSocket;
// Send a UTF8 String or Data.
- (void)sendData:(id)data;
@end
