//
//  HInputValidator.m
//  P2PCamera
//
//  Created by dqf on 1/16/16.
//  Copyright © 2016 scsocool. All rights reserved.
//

#import "HInputValidator.h"

@implementation HInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error {
    if (error) {
        *error = nil;
    }
    return NO;
}

- (BOOL)input:(UITextField *)input inRange:(NSRange)range error:(NSError **)error {
    if (error) {
        *error = nil;
    }
    return NO;
}

@end
