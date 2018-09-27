//
//  HUserDefaults.h
//  HProjectModel1
//
//  Created by txkj_mac on 2018/9/27.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUserDefaults : NSObject

/** 是否登录 */
@property (nonatomic) BOOL isLogin;

/** 用户名 */
@property (nonatomic, copy) NSString *nickName;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 生日 */
@property (nonatomic, copy) NSString *birthday;
/** 性别 */
@property (nonatomic, copy) NSString *gender;
/** 省份 */
@property (nonatomic, copy) NSString *province;
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 地区 */
@property (nonatomic, copy) NSString *district;
/** 地址 */
@property (nonatomic, copy) NSString *address;
/** 组织 */
@property (nonatomic, copy) NSString *organization;
/** 职位名 */
@property (nonatomic, copy) NSString *position_name;
/** 信息是否完整 */
@property (nonatomic, assign) BOOL is_complete;
/** token 用户身份验证信息 */
@property (nonatomic, copy) NSString *token;
/** 本地存储 邮箱 */
@property (nonatomic, copy) NSString *user_email;


/** userKey */
@property (nonatomic, copy) NSString *userKey;
/** 用户ID */
@property (nonatomic, copy) NSString *userName;
/** balance */
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *integral;


/** 密码 */
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *phonenumber;

+ (HUserDefaults *)defaults;

//登出的时候需要移除用户信息
- (void)removeUser;

@end
