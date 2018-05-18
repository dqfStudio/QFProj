//
//  ViewController.m
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+HAutoFill.h"
#import "NSObject+HAspects.h"
#import "TestViewController.h"
#import "QFButton.h"
#import "NSFileManager+HUtil.h"
#import "UILabel+HState.h"

@interface ViewController () {
    UILabel *label;
}
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
    [self autoFillWithParams:dict map:dict2];
    
    NSLog(@"%@",self.TestString);
    NSLog(@"%d",self.yn);
    NSLog(@"%ld",self.ff);
    NSLog(@"%@",self.ww);
    NSLog(@"%@",self.date);
    
    
    label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(100, 100, 100, 100)];
//    [label setSelected:YES];
    [label setText:@"hello" forState:UILabelStateNormal];
    [label setText:@"world" forState:UILabelStateSelected];
    
    [label setTextColor:[UIColor blueColor] forState:UILabelStateNormal];
    [label setTextColor:[UIColor greenColor] forState:UILabelStateSelected];
    [label setSelected:YES];
    [label setFont:[UIFont systemFontOfSize:15] forState:UILabelStateNormal];
    [label setFont:[UIFont systemFontOfSize:35] forState:UILabelStateSelected];
    
    [label setBackgroundColor:[UIColor redColor] forState:UILabelStateNormal];
    [label setBackgroundColor:[UIColor yellowColor] forState:UILabelStateSelected];
//    [label setSelected:YES];
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setFrame:CGRectMake(100, 300, 80, 80)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    [self.navigationController pushViewController:[TestViewController new] animated:YES];
    
    NSLog(@"%@",[NSFileManager documentPath:nil]);
    
}

- (void)btnAction {
    if (label.isSelected) {
        [label setSelected:NO];
    }else {
        [label setSelected:YES];
    }
}

@end
