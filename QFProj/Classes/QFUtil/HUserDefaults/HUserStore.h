//
//  HUserStore.h
//  QFProj
//
//  Created by dqf on 2018/9/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKeyChainStore.h"

@interface HUserStore : NSObject

@property (nonatomic) BOOL isLogin;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

+ (HUserStore *)defaults;

//加载钥匙串中的数据
- (BOOL)loadKeyChainDataWithUserName:(NSString *)name password:(NSString *)pwd;

@end
