//
//  NSString+HUtil.h
//  TestProject
//
//  Created by dqf on 2018/4/24.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (HUtil)

- (id)JSONValue;

- (NSString *)trim;

- (NSString *)md5;

- (NSString *)encode;

- (NSString *)decode;

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font;

//String contains Emoji
- (BOOL)stringContainsEmoji;

@end

