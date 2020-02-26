//
//  HSwitchLanguage.h
//  TestProject
//
//  Created by dqf on 2018/6/5.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HSwizzleUtil.h"
#import "HLabel.h"

#define KLanguageBase  @"zh-Hans"   //默认语言，这里默认为汉语
#define KLanguageEN    @"en"        //英语
#define KSKinTable     @"Localizable" //语言文件名

/**
 支持HLabel、UILabel、UIButton、UITextView文字替换
 此方案需要配置多个语言文本，然后设置每个词条的关键字即可
 */

@interface HSwitchLanguage : NSObject

@property (nonatomic, readonly) NSBundle *currentBundle; //当前语言资源文件
@property (nonatomic, readonly) NSString *userLanguage; //获取当前语言

+ (HSwitchLanguage *)share;

- (void)setUserlanguage:(NSString *)language completion:(void (^)(void))completion;//设置当前语言

@end
