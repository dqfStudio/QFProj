//
//  UITextField+HRegular.m
//  TestProject
//
//  Created by dqf on 2018/6/26.
//  Copyright © 2018年 socool. All rights reserved.
//

#import "UITextField+HRegular.h"
#import <objc/runtime.h>

@implementation UITextField (HRegular)

- (HInputValidator *)inputValidator {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setInputValidator:(HInputValidator *)inputValidator {
    objc_setAssociatedObject(self, @selector(inputValidator), inputValidator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)validate {
    
    NSError *error = nil;
    BOOL validationResult = [self.inputValidator validateInput:self error:&error];
    
    if (!validationResult) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    return validationResult;
}

- (BOOL)lengthInRange:(NSRange)range {
    NSError *error = nil;
    BOOL rangeResult = [self.inputValidator input:self inRange:range error:&error];
    
    if (!rangeResult) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    return rangeResult;
}

@end
