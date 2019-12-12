//
//  NSMutableAttributedString+HUtil.m
//  QFProj
//
//  Created by dqf on 2019/4/29.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "NSMutableAttributedString+HUtil.h"

@implementation NSMutableAttributedString (HUtil)
+ (NSMutableAttributedString *)attributedWithString:(NSString *)string attributed:(NSDictionary *)attribute {
    if (string.length == 0) return nil;
    return [NSMutableAttributedString attributedWithString:string range:NSMakeRange(0,string.length) attributed:attribute];
}
+ (NSMutableAttributedString *)attributedWithString:(NSString *)string
                                              range:(NSRange)range
                                         attributed:(NSDictionary *)attribute {
    if (string.length == 0) return nil;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    for (NSString *key in attribute.allKeys) {
        [attr addAttribute:key value:attribute[key] range:range];
    }
    return attr;
}


- (NSMutableAttributedString *)attributedWith:(NSDictionary *)attribute {
    return [self attributedWithRange:NSMakeRange(0,self.length) attributed:attribute];
}
- (NSMutableAttributedString *)attributedWithRange:(NSRange)range attributed:(NSDictionary *)attribute {
    for (NSString *key in attribute.allKeys) {
        [self addAttribute:key value:attribute[key] range:range];
    }
    return self;
}
@end
