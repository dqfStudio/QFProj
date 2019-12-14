//
//  HEmailManager.m
//  mail
//
//  Created by 朱斌 on 13/07/2017.
//  Copyright © 2017 朱斌. All rights reserved.
//

#import "HEmailManager.h"
#import "SKPSMTPMessage.h"

@interface HEmailManager ()<SKPSMTPMessageDelegate>

@property (nonatomic, copy) NSString *fromEmail;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *toEmail;
@property (nonatomic, copy) NSString *relayHost;

@end

@implementation HEmailManager

+ (HEmailManager *)shareInstance {
    static dispatch_once_t onceToken;
    static HEmailManager * emailManager;
    dispatch_once(&onceToken, ^{
        emailManager = [[HEmailManager alloc] init];
    });
    return emailManager;
}

- (void)configWithFromEmail:(NSString *)fromEmail andPasswod:(NSString *)password andToEmail:(NSString *)toEmail andRelayHose:(NSString *)relayHost {
    self.fromEmail = fromEmail;
    self.password = password;
    self.toEmail = toEmail;
    self.relayHost = relayHost;
}

- (void)sendEmail:(NSString *)content {
    SKPSMTPMessage *myMessage = [[SKPSMTPMessage alloc] init];
    myMessage.delegate = self;
    myMessage.fromEmail = self.fromEmail;//发送者邮箱
    myMessage.pass = self.password;//发送者邮箱的密码
    myMessage.login = self.fromEmail;//发送者邮箱的用户名
    myMessage.toEmail = self.toEmail;//收件邮箱
    //myMessage.bccEmail = @"******@qq.com";//抄送
    myMessage.relayHost = self.relayHost;
    myMessage.requiresAuth = YES;
    myMessage.wantsSecure = YES;//为gmail邮箱设置 smtp.gmail.com
    myMessage.subject = [NSString stringWithFormat:@"%@%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],@"崩溃日志"];//邮件主题
    
    /* >>>>>>>>>>>>>>>>>>>> *   设置邮件内容   * <<<<<<<<<<<<<<<<<<<< */
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain; charset=UTF-8",kSKPSMTPPartContentTypeKey, content,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    myMessage.parts = [NSArray arrayWithObjects:plainPart,nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [myMessage send];
    });
}

#pragma mark - SKPSMTPMessageDelegate
- (void)messageSent:(SKPSMTPMessage *)message {
    NSLog(@"发送邮件成功");
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                           stringByAppendingPathComponent:@"crash"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager]  removeItemAtPath:cachePath error:nil];
    }
}
- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    NSLog(@"message - %@\nerror - %@", message, error);
}

@end
