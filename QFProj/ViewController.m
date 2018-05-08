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

@property (nonatomic) QFButton *btn1;
@property (nonatomic) QFButton *btn2;
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
    
//    [@"ViewController".toClass() aspectInstead:@selector(testAction:) usingBlock:^(id<AspectInfo> info, id sender) {
//        NSLog(@"");
//    }];
    
    [@"ViewController".toClass() aspectInstead:@selector(viewWillAppear:) usingBlock:^(id<AspectInfo> info, BOOL animated) {
        NSLog(@"");
    }];
    
//    [@"QFButton".toClass() aspectInstead:@selector(testAction:) usingBlock:^(id<AspectInfo> info, id sender) {
//        NSLog(@"");
//    }];
    
    self.btn1 = [[QFButton alloc] init];
    [self.btn1 setFrame:CGRectMake(0, 80, 50, 50)];
    [self.btn1 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.btn1];
//    [self.btn1 addTarget:self action:@selector(testAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.btn2 = [[QFButton alloc] init];
    [self.btn2 setFrame:CGRectMake(100, 80, 50, 50)];
    [self.btn2 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.btn2];
    
    
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setFrame:CGRectMake(100, 180, 50, 50)];
    [btn3 setBackgroundColor:[UIColor yellowColor]];
    [btn3 addTarget:self action:@selector(testAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn3];
    
    
//    [@"QFButton".toClass() aspectInstead:@selector(testAction:) usingBlock:^(id<AspectInfo> info, id sender) {
//        NSLog(@"");
//    }];
    
//    [QFButton aspectInstead:@selector(testAction:) usingBlock:^(id<AspectInfo> info, id sender) {
//        NSLog(@"");
//    }];
    
//    [self.btn2 aspectInstead:@selector(testAction:) usingBlock:^(id<AspectInfo> info, id sender) {
//        NSLog(@"");
//    }];
    
//    [@"TestViewController".toClass() aspectInstead:@selector(dealloc) usingBlock:^(id<AspectInfo> info, id sender) {
//        NSLog(@"");
//    }];
//
////    [ViewController aspectInstead:@selector(viewWillAppear:) usingBlock:^(id<AspectInfo> info, BOOL animated) {
////        NSLog(@"");
////    }];
//    
//    NSTimer *timer = [NSTimer safe_scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self testAction:nil];
//    }];
    
}

- (void)dealloc {

}

- (void)testAction:(id)sender {
    NSLog(@"");
//    [self.btn1 removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
