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
#import "HLabelView.h"

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
    
//    UITableViewCell *btn;
    
    label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(100, 100, 150, 100)];
//    [label setSelected:YES];
    [label setText:@"hello福建省拉法基啊放假啊类似飞机案例；放假啊类似飞机啊；了房间啊；房价啊；放假啊；房价啊；峰" forState:UILabelStateNormal];
    [label setNumberOfLines:0];
    [label setText:@"world" forState:UILabelStateSelected];
    
    [label setTextColor:[UIColor blueColor] forState:UILabelStateNormal];
    [label setTextColor:[UIColor greenColor] forState:UILabelStateSelected];
//    [label setSelected:YES];
    [label setFont:[UIFont systemFontOfSize:15] forState:UILabelStateNormal];
    [label setFont:[UIFont systemFontOfSize:35] forState:UILabelStateSelected];
    
    [label setBackgroundColor:[UIColor redColor] forState:UILabelStateNormal];
    [label setBackgroundColor:[UIColor yellowColor] forState:UILabelStateSelected];
//    [label setSelected:YES];

    UIView *accView = [UIView new];
    [accView setFrame:CGRectMake(0, 0, 50, 80)];
    [accView setBackgroundColor:[UIColor blackColor]];
    
//    UIEdgeInsetsMake(0, 0, 0, 0);
//    [label setAccessoryView:accView edgeInsets:HEdgeInsetsMake(10, 10, 10)];
    
    
//    [self.view addSubview:label];
    
    HLabelView *labelView = [[HLabelView alloc]initWithFrame:CGRectMake(100, 100, 150, 100)];
//    [labelView setFrame:CGRectMake(100, 100, 150, 100)];
    [labelView setBackgroundColor:[UIColor redColor]];
    [labelView.label setText:@"事发后撒发货哦啊放假啊房价法搜撒娇哦"];
//    [labelView.label setText:@"事发"];
    [labelView.label setNumberOfLines:0];
    [label setBackgroundColor:[UIColor blueColor]];
    [labelView setAccessoryView:accView];
    [labelView setEdgeInsets:HEdgeInsetsMake(50, 80, 0, 10)];
    [self.view addSubview:labelView];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setFrame:CGRectMake(100, 300, 80, 80)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    [self.navigationController pushViewController:[TestViewController new] animated:YES];
    
    NSLog(@"%@",[NSFileManager documentPath:nil]);
    
}

- (void)btnAction {
    NSLog(@"%@",label);
    if (label.isSelected) {
        [label setSelected:NO];
    }else {
        [label setSelected:YES];
    }
}

@end
