//
//  HUpdate.h
//  HProj
//
//  Created by dqf on 2018/11/5.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertController+HUtil.h"
#import "UIApplication+HUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface HUpdate : NSObject
@property (nonatomic) NSString *version;   //服务端版本号
@property (nonatomic) NSString *isUpdate;  //是否更新:0代表强制更新,1表示非强制更新
@property (nonatomic) NSString *downUrl;   //下载地址
@property (nonatomic) NSString *content;   //版本更新内容

+ (instancetype)share;
- (void)update;

@end

NS_ASSUME_NONNULL_END
