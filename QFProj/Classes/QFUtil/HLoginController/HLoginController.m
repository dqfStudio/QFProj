//
//  HLoginController.m
//  QFProj
//
//  Created by dqf on 2018/8/25.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HLoginController.h"

@interface HLoginController () <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@end

@implementation HLoginController

- (HTupleView *)tupleView {
    if (!_tupleView) {
        CGRect frame = self.view.frame;
        frame.origin.y += UIDevice.topBarHeight;
        frame.size.height -= UIDevice.topBarHeight;
        _tupleView = [[HTupleView alloc] initWithFrame:frame scrollDirection:HTupleViewScrollDirectionVertical];
        [_tupleView setTupleDelegate:self];
    }
    return _tupleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"登录"];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.view addSubview:self.tupleView];
}

- (NSInteger)tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 11;
}

- (CGSize)tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(80, 60);
            break;
        case 1:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)-80, 60);
            break;
        case 2:
            return CGSizeMake(80, 60);
            break;
        case 3:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)-80, 60);
            break;
        case 4:
            return CGSizeMake(80, 60);
            break;
        case 5:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)-80-120, 60);
            break;
        case 6:
            return CGSizeMake(120, 60);
            break;
        case 7:
            return CGSizeMake(CGRectGetWidth(tupleView.frame), 40);
            break;
        case 8:
            return CGSizeMake(CGRectGetWidth(tupleView.frame), 45);
            break;
        case 9:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)/2+45, 20);
            break;
        case 10:
            return CGSizeMake(CGRectGetWidth(tupleView.frame)/2-45, 20);
            break;

        default:
            break;
    }
    return CGSizeMake(0, 0);
}
- (CGSize)tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (CGSize)tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (UIEdgeInsets)tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return UIEdgeInsetsMake(15, 15, 0, 0);
            break;
        case 1:
            return UIEdgeInsetsMake(15, 0, 0, 15);
            break;
        case 2:
            return UIEdgeInsetsMake(15, 15, 0, 0);
            break;
        case 3:
            return UIEdgeInsetsMake(15, 0, 0, 15);
            break;
        case 4:
            return UIEdgeInsetsMake(15, 15, 0, 0);
            break;
        case 5:
            return UIEdgeInsetsMake(15, 0, 0, 10);
            break;
        case 6:
            return UIEdgeInsetsMake(15, 0, 0, 15);
            break;
        case 7:
            return UIEdgeInsetsMake(0, 15, 0, 15);
            break;
        case 8:
            return UIEdgeInsetsMake(0, 15, 0, 15);
            break;
        case 9:
            return UIEdgeInsetsMake(5, 15, 0, 0);
            break;
        case 10:
            return UIEdgeInsetsMake(5, 0, 0, 15);
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (void)tupleView:(HTupleView *)tupleView itemTuple:(HItemTuple)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"+86"];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
        }
            break;
        case 1:
        {
            HTextFieldCell *cell = itemBlock(nil,HTextFieldCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.textField setPlaceholder:@"请输入手机号"];
            [cell.textField setTintColor:[UIColor colorWithString:@"#BABABF"]];
            [cell.textField setFont:[UIFont systemFontOfSize:14]];
            cell.textField.inputValidator = HPhoneValidator.new;
        }
            break;
        case 2:
        {
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"昵称"];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
        }
            break;
        case 3:
        {
            HTextFieldCell *cell = itemBlock(nil, HTextFieldCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.textField setPlaceholder:@"请输入昵称"];
            [cell.textField setTintColor:[UIColor colorWithString:@"#BABABF"]];
            [cell.textField setFont:[UIFont systemFontOfSize:14]];
        }
            break;
        case 4:
        {
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"验证码"];
            [cell.label setFont:[UIFont systemFontOfSize:14]];
        }
            break;
        case 5:
        {
            HTextFieldCell *cell = itemBlock(nil, HTextFieldCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
            [cell.textField setPlaceholder:@"请输入验证码"];
            [cell.textField setTintColor:[UIColor colorWithString:@"#BABABF"]];
            [cell.textField setFont:[UIFont systemFontOfSize:14]];
            cell.textField.inputValidator = HNumericValidator.new;
        }
            break;
        case 6:
        {
            HButtonViewCell *cell = itemBlock(nil, HButtonViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.buttonView setBackgroundColor:[UIColor colorWithString:@"#CCCCCC"]];
            [cell.buttonView.button setTitle:@"获取验证码"];
            [cell.buttonView.button setFont:[UIFont systemFontOfSize:14]];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                
            }];
        }
            break;
        case 7:
        {
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
        }
            break;
        case 8:
        {
            HButtonViewCell *cell = itemBlock(nil, HButtonViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.buttonView setBackgroundColor:[UIColor colorWithString:@"#CCCCCC"]];
            [cell.buttonView.button setTitle:@"开始"];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
                HTextFieldCell *tfCell1 = tupleView.cell(1, 0);
                HTextFieldCell *tfCell2 = tupleView.cell(3, 0);
                HTextFieldCell *tfCell3 = tupleView.cell(5, 0);
                
                if ([tfCell1.textField validate] && tfCell2.textField.text > 0 && tfCell3.textField.text > 0) {
                    
                }
            }];
        }
            break;
        case 9:
        {
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.label setBackgroundColor:[UIColor clearColor]];
            [cell.label setText:@"点击开始,即表示已阅读并同意"];
            [cell.label setTextColor:[UIColor colorWithString:@"#BABABF"]];
            [cell.label setFont:[UIFont systemFontOfSize:12]];
            [cell.label setTextAlignment:NSTextAlignmentRight];
        }
            break;
        case 10:
        {
            HButtonViewCell *cell = itemBlock(nil, HButtonViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.buttonView setBackgroundColor:[UIColor clearColor]];
            [cell.buttonView.button setBackgroundColor:[UIColor clearColor]];
            [cell.buttonView.button setTitle:@"《服务协议》"];
            [cell.buttonView.button setFont:[UIFont systemFontOfSize:12]];
            [cell.buttonView.button setTitleColor:[UIColor colorWithString:@"#34BDD7"]];
            [cell.buttonView.button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {

            }];
        }
            break;
            
        default:
        {
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell setBackgroundColor:[UIColor clearColor]];
        }
            break;
    }
}

@end
