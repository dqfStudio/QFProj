//
//  NSMutableAttributedString+HUtil.h
//  QFProj
//
//  Created by wind on 2019/4/29.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (HUtil)
+ (NSMutableAttributedString *)attributedWithString:(NSString *)string attributed:(NSDictionary *)attribute;
+ (NSMutableAttributedString *)attributedWithString:(NSString *)string range:(NSRange)range attributed:(NSDictionary *)attribute;

- (NSMutableAttributedString *)attributedWith:(NSDictionary *)attribute;
- (NSMutableAttributedString *)attributedWithRange:(NSRange)range attributed:(NSDictionary *)attribute;
@end
