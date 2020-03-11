//
//  HTestViewController.m
//  QFProj
//
//  Created by wind on 2020/3/11.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTestViewController.h"

@interface HTestViewController ()

@end

@implementation HTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topBar setHidden:YES];
    self.view.backgroundColor = UIColor.greenColor;
    UIButton *btn = UIButton.new;
    btn.backgroundColor = UIColor.redColor;
    btn.frame = CGRectMake(100, 100, 270, 121);
//    btn.center = self.view.center;
//    btn.frame = self.view.frame;
    [btn addSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:btn];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
