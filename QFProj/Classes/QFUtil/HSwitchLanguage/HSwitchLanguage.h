//
//  HSwitchLanguage.h
//  TestProject
//
//  Created by 邓清峰 on 2018/6/5.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define KLanguageBase  @"Base" //默认语言，这里默认为汉语
#define KLanguageEN    @"en"   //英语
#define KSKinTbl       @"Test" //语言文件名

/**
 支持UILabel、UIButton、UITextView文字替换
 此方案需要配置多个语言文本，然后设置每个词条的关键字即可
 */

@interface HSwitchLanguage : NSObject
+ (NSString *)userLanguage;//获取当前语言
+ (void)setUserlanguage:(NSString *)language;//设置当前语言
@end
