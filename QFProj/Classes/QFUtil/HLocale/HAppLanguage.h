//
//  HAppLanguage.h
//  HProj
//
//  Created by dqf on 2018/6/5.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HSwizzleUtil.h"
#import "HTextView.h"
#import "HLabel.h"

#define KDefaultLanguage  @"zh-Hans"     //默认语言，这里默认为汉语
#define KSKinTable        @"Localizable" //语言文件名

/**
 支持HLabel、UILabel、UIButton、HTextView、UITextView文字替换
 此方案需要配置多个语言文本，然后设置每个词条的关键字即可
 */

@interface HAppLanguage : NSObject
//获取当前语言
@property (nonatomic, readonly) NSString *userLanguage;
//单例
+ (HAppLanguage *)userDefaults;
//设置当前语言
- (void)setUserlanguage:(NSString *)language completion:(void (^)(void))completion;

@end
