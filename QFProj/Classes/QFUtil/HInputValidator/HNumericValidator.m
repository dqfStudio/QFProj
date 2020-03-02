//
//  HNumericValidator.m
//  P2PCamera
//
//  Created by dqf on 1/16/16.
//  Copyright © 2016 scsocool. All rights reserved.
//

#import "HNumericValidator.h"

@implementation HNumericValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error {
    NSError *regError = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^[0-9]*$"
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:&regError];

    NSUInteger numberOfMatches = [regex
                                  numberOfMatchesInString:[input text]
                                  options:NSMatchingAnchored
                                  range:NSMakeRange(0, [[input text] length])];

    // if there is not a single match
    // then return an error and NO
    if (numberOfMatches == 0) {
        if (error != nil) {
            NSString *description = NSLocalizedString(@"Input Validation Failed", @"");
            NSString *reason = NSLocalizedString(@"The input can only contain numerical values", @"");

            NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
                                 NSLocalizedFailureReasonErrorKey, nil];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray
                                                                 forKeys:keyArray];
            *error = [NSError errorWithDomain:HInputValidationErrorDomain
                                         code:NumericCode
                                     userInfo:userInfo];
        }

        return NO;
    }

    return YES;
}

- (BOOL)input:(UITextField *)input inRange:(NSRange)range error:(NSError **)error {

    //去掉两端的空格和换行符号
    NSString *inputText = [input.text mutableCopy];
    inputText = [inputText stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [input setText:inputText];


    if (input.text.length >= range.location && input.text.length <= range.length) {
        return YES;
    }else {

        if (error != nil) {
            NSString *str = [NSString stringWithFormat:@"The length of the input needs to be between %lu-%lu",(unsigned long)range.location,(unsigned long)range.length];

            NSString *description = NSLocalizedString(@"Input Validation Failed", @"");
            NSString *reason = NSLocalizedString(str, @"");

            NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
                                 NSLocalizedFailureReasonErrorKey, nil];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray
                                                                 forKeys:keyArray];
            *error = [NSError errorWithDomain:HInputValidationErrorDomain
                                         code:NumericCode
                                     userInfo:userInfo];
        }

    }
    return NO;
}

@end
