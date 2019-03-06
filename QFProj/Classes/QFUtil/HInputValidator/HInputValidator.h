//
//  HInputValidator.h
//  P2PCamera
//
//  Created by dqf on 1/16/16.
//  Copyright © 2016 scsocool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HInputHeader.h"

@interface HInputValidator : NSObject

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error;
- (BOOL)input:(UITextField *)input inRange:(NSRange)range error:(NSError **)error;

@end
