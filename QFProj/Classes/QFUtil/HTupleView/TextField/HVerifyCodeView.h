//
//  HVerifyCodeView.h
//  Code
//
//  Created by dqf on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVerifyCodeView : UIControl

/**
VerifyCodeView:1.随机内容(默认由0~9与26个大小写字母随机组合);2.文本颜色(默认黑色);3.字体大小(默认20);4.获取当前验证码等;
*/
@property (nonatomic, readwrite) UIColor   *textColor;         // 文本颜色
@property (nonatomic, readwrite) NSInteger textSize;           // 字体大小
//随机内容, 字符数组如:@[@"a",@"F",@"A",@"1",@"0"];
@property (nonatomic, readwrite) NSArray   *charsArray;        // 随机内容
@property (nonatomic, readonly)  NSString  *verifyCodeString;  // 验证码

//刷新随机验证码
- (void)refreshVerifyCode;

@end
