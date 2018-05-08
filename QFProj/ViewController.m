//
//  ViewController.m
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "ViewController.h"
#import "HAutoFill.h"
#import "NSObject+HAspects.h"
#import "TestViewController.h"
#import "QFButton.h"

@interface ViewController ()
@property (nonatomic) NSString *TestString;
@property (nonatomic) BOOL yn;
@property (nonatomic) NSInteger ff;
@property (nonatomic) NSNumber *ww;
@property (nonatomic) NSDate *date;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"test" forKey:@"TestString"];
    [dict setObject:@"1" forKey:@"yn"];
    [dict setObject:@"22" forKey:@"ff"];
    [dict setObject:@"333" forKey:@"www"];
    [dict setObject:@"11111111" forKey:@"date"];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setObject:@"www" forKey:@"ww"];
    [HAutoFill autoFill:self params:dict map:dict2];
    
    NSLog(@"%@",self.TestString);
    NSLog(@"%d",self.yn);
    NSLog(@"%ld",self.ff);
    NSLog(@"%@",self.ww);
    NSLog(@"%@",self.date);
    
    [self.navigationController pushViewController:[TestViewController new] animated:YES];
    
}

@end
