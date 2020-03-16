//
//  HUserDefaults.h
//  QFProj
//
//  Created by dqf on 2018/9/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKeyChainStore.h"

@interface HUserDefaults : NSObject

/** 是否登录 */
@property (nonatomic) BOOL isLogin;

/** 用户ID */
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

/** 密码 */
@property (nonatomic, copy) NSString *password;

+ (HUserDefaults *)defaults;

//加载钥匙串中的数据
- (BOOL)loadKeyChainDataWith:(NSString *)userName pwd:(NSString *)pwd;

//线上环境链接
- (void)setBaseLink:(NSString *)baseLink;
- (NSString *)baseLink;

- (void)setH5Link:(NSString *)h5Link;
- (NSString *)h5Link;

@end
