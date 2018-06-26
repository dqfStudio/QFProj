//
//  UITextField+HRegular.h
//  TestProject
//
//  Created by dqf on 2018/6/26.
//  Copyright © 2018年 socool. All rights reserved.
//

#import "HInputValidator.h"

@interface UITextField (HRegular)

@property (nonatomic) HInputValidator *inputValidator;

- (BOOL)validate;
- (BOOL)lengthInRange:(NSRange)range;

@end
