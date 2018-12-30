//
//  HUserDefaults.h
//  HProjectModel1
//
//  Created by txkj_mac on 2018/9/27.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HUserDefaults : NSObject

/** 是否登录 */
@property (nonatomic) BOOL isLogin;
/** 本地存储 邮箱 */
@property (nonatomic, copy) NSString *user_email;


/** userKey */
@property (nonatomic, copy) NSString *userKey;
/** 用户ID */
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *realname;
/** balance */
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *integral;
@property (nonatomic, copy) NSString *vip_level;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *loginmobile;

@property (nonatomic, copy) NSString *login_time;
@property (nonatomic, copy) NSString *reg_date;

/** 银行卡列表,里面为字典 card_num和bank_name */
@property (nonatomic, copy) NSArray *bankList;
//是否已经设置取款密码
@property (nonatomic) BOOL settedqkpwd;


/** 密码 */
@property (nonatomic, copy) NSString *password;

+ (HUserDefaults *)defaults;

//登出的时候需要移除用户信息
- (void)removeUser;


//线上环境链接
- (void)setBaseLink:(NSString *)baseLink;
- (NSString *)baseLink;

- (void)setH5Link:(NSString *)h5Link;
- (NSString *)h5Link;

- (void)setPlatCodeLink:(NSString *)platCodeLink;
- (NSString *)platCodeLink;

- (void)setSrc1Link:(NSString *)src1Link;
- (NSString *)src1Link;

@end
