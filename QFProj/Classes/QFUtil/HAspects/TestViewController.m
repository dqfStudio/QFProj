//
//  ViewController.m
//  TestProject
//
//  Created by dqf on 2018/3/10.
//  Copyright © 2018年 socool. All rights reserved.
//

#import "TestViewController.h"
//#import <Aspects/Aspects.h>
#import "Aspects/Aspects.h"
#import "MightyCrash.h"
#import "Felix.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%tu", animated);
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, BOOL animated) {
//        NSLog(@"View Controller %@ will appear animated: %tu", info.instance, animated);
//        NSLog(@"%@ %@ %@ %tu", info.instance, info.arguments, info.originalInvocation, animated);
//    } error:NULL];
    
//    [Felix fixIt];
//    [Felix fixIt];
//    [Felix fixIt];

    NSString *fixScriptString = @" \
    fixInstanceMethodReplace('MightyCrash', 'divideUsingDenominator:', function(instance, originInvocation, originArguments){ \
    if (originArguments[0] == 0) { \
    console.log('zero goes here'); \
    } else { \
    runInvocation(originInvocation); \
    } \
    }); \
    \
    ";

    [Felix evalString:fixScriptString];
//    [Felix fixIt];
    
    MightyCrash *mc = [[MightyCrash alloc] init];
    float result = [mc divideUsingDenominator:3];
    NSLog(@"result: %.3f", result);
    result = [mc divideUsingDenominator:0];
    NSLog(@"won't crash");
    
//    [ViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info, BOOL animated) {
//        NSLog(@"View Controller %@ will appear animated: %tu", info.instance, animated);
//        NSLog(@"%@ %@ %@ %tu", info.instance, info.arguments, info.originalInvocation, animated);
//    } error:NULL];
}

@end
