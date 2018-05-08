//
//  TestViewController.m
//  QFProj
//
//  Created by dqf on 2018/5/8.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "TestViewController.h"
#import "HAutoFill.h"
#import "QFButton.h"
#import "HAspectsCenter.h"

@interface TestViewController ()
@property (nonatomic) NSTimer *timer;
@property (nonatomic) QFButton *btn1;
@property (nonatomic) id<AspectToken> aspectToken;
@end

@implementation TestViewController

- (void)dealloc {
    NSLog(@"");
//    [self.aspectToken remove];
//    self.aspectToken = nil;
    [[HAspectsCenter defaultCenter] removeAspectsForClass:QFButton.class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btn1 = [[QFButton alloc] init];
    [self.btn1 setFrame:CGRectMake(0, 80, 50, 50)];
    [self.btn1 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.btn1];
    
    [QFButton aspectInstead:@selector(testAction:) usingBlock:^(id<AspectInfo> info, id sender) {
        NSLog(@"");
    }];
    
//    [self.btn1 aspectInstead:@selector(testAction:) usingBlock:^(id<AspectInfo> info, id sender) {
//        NSLog(@"");
//    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testAction:(id)sender {
    NSLog(@"");
}

@end
