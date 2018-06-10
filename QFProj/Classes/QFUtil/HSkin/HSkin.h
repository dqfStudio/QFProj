//
//  HSkin.h
//  TestProject
//
//  Created by dqf on 2018/6/9.
//  Copyright © 2018年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIColor+HUtil.h"

#define KLanguageBase  @"Base" //默认语言，这里默认为汉语
#define KLanguageEN    @"en"   //英语
#define KSKinTbl       @"Test" //语言文件名

@interface HSkin : NSObject

@end

@interface UIView (UISkin)
- (void)skin_setBackgroundColor:(NSString *)color;
@end

@interface UILabel (UISkin)
- (void)skin_setFont:(NSString *)font;
- (void)skin_setTextColor:(NSString *)color;
@end

@interface UIButton (UISkin)
- (void)skin_setFont:(NSString *)font;
- (void)skin_setTextColor:(NSString *)color;
- (void)skin_setImage:(NSString *)image;
@end

@interface UITextView (UISkin)
- (void)skin_setFont:(NSString *)font;
- (void)skin_setTextColor:(NSString *)color;
@end

@interface UIImageView (UISkin)
- (void)skin_setImage:(NSString *)image;
@end
