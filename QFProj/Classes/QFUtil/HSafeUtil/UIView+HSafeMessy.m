//
//  UIView+HSafeMessy.m
//  QFProj
//
//  Created by wind on 2019/7/11.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "UIView+HSafeMessy.h"
#import "NSObject+HSwizzleUtil.h"

@implementation UILabel (HSafeMessy)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(safeMessy_setText:)];
    });
}
- (void)safeMessy_setText:(NSString *)text {
    NSString *content = nil;
    if ([text isKindOfClass:NSString.class]) {
        content = text;
    }else if ([text isKindOfClass:NSNumber.class]) {
        content = [NSString stringWithFormat:@"%@", text];
    }
    [self safeMessy_setText:content];
}
@end

@implementation UITextView (HSafeMessy)
+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzleWithOrigSEL:@selector(setText:) overrideSEL:@selector(safeMessy_setText:)];
    });
}
- (void)safeMessy_setText:(NSString *)text {
    NSString *content = nil;
    if ([text isKindOfClass:NSString.class]) {
        content = text;
    }else if ([text isKindOfClass:NSNumber.class]) {
        content = [NSString stringWithFormat:@"%@", text];
    }
    [self safeMessy_setText:content];
}
@end

