//
//  HSwitchLanguage.h
//  TestProject
//
//  Created by 邓清峰 on 2018/6/5.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define KLanguageBase  @"zh-Hans"   //默认语言，这里默认为汉语
#define KLanguageEN    @"en"        //英语
#define KSKinTbl       @"Localizable" //语言文件名

#define HLocalizedString(key) \
[[HSwitchLanguage share].currentBundle localizedStringForKey:(key) value:@"" table:nil]
#define HLocalizedStringFromTable(key, tbl) \
[[HSwitchLanguage share].currentBundle localizedStringForKey:(key) value:@"" table:(tbl)]

/**
 支持UILabel、UIButton、UITextView文字替换
 此方案需要配置多个语言文本，然后设置每个词条的关键字即可
 */

@interface HSwitchLanguage : NSObject
@property (nonatomic) NSBundle *currentBundle;
+ (HSwitchLanguage *)share;
+ (NSString *)userLanguage;//获取当前语言
+ (void)setUserlanguage:(NSString *)language;//设置当前语言
@end
