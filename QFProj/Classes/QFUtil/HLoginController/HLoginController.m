//
//  HLoginController.m
//  QFProj
//
//  Created by dqf on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HLoginController.h"

@interface HLoginController ()

@end

@implementation HLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftNaviButton setHidden:YES];
    [self setTitle:@"登录"];
    [self.tupleView setTupleDelegate:(id<HTupleViewDelegate>)self];
}

- (NSInteger)numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0:return CGSizeMake(self.tupleView.width, 60);
        case HCell1:return CGSizeMake(self.tupleView.width, 60);
        case HCell2:return CGSizeMake(self.tupleView.width, 60);
        case HCell3:return CGSizeMake(self.tupleView.width, 40);
        case HCell4:return CGSizeMake(self.tupleView.width, 45);
        case HCell5:return CGSizeMake(self.tupleView.width, 20);
        default:return CGSizeZero;
    }
}

- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0:return UIEdgeInsetsMake(15, 0, 0, 0);
        case HCell1:return UIEdgeInsetsMake(15, 0, 0, 0);
        case HCell2:return UIEdgeInsetsMake(15, 0, 0, 0);
        case HCell3:return UIEdgeInsetsMake(0, 15, 0, 15);
        case HCell4:return UIEdgeInsetsMake(0, 15, 0, 15);
        case HCell5:return UIEdgeInsetsMake(5, 15, 0, 0);
        default:return UIEdgeInsetsZero;
    }
}

- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0: {
            HTupleTextFieldCell *cell = itemBlock(nil,HTupleTextFieldCell.class, nil, YES);
            [cell.textField setBackgroundColor:HColorHex(#F2F2F2)];

            [cell.textField setLeftWidth:80];
            [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textField.leftLabel setText:@"+86"];

            [cell.textField setPlaceholder:@"请输入手机号"];
            [cell.textField setTextColor:HColorHex(#BABABF)];
            [cell.textField setFont:[UIFont systemFontOfSize:14]];
            //cell.textField.inputValidator = HPhoneValidator.new;

            [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {

            }];
        }
            break;
        case HCell1: {
            HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, nil, YES);
            [cell.textField setBackgroundColor:HColorHex(#F2F2F2)];

            [cell.textField setLeftWidth:80];
            [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textField.leftLabel setText:@"昵称"];

            [cell.textField setPlaceholder:@"请输入昵称"];
            [cell.textField setTextColor:HColorHex(#BABABF)];
            [cell.textField setFont:[UIFont systemFontOfSize:14]];

            [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {

            }];
        }
            break;
        case HCell2: {
            HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, nil, YES);
            [cell.textField setBackgroundColor:HColorHex(#F2F2F2)];

            [cell.textField setLeftWidth:80];
            [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textField.leftLabel setText:@"验证码"];

            [cell.textField setPlaceholder:@"请输入验证码"];
            [cell.textField setTextColor:HColorHex(#BABABF)];
            [cell.textField setFont:[UIFont systemFontOfSize:14]];
            //cell.textField.inputValidator = HNumericValidator.new;

            [cell.textField setRightWidth:120];
            [cell.textField.rightButton setTitle:@"获取验证码"];
            [cell.textField.rightButton setFont:[UIFont systemFontOfSize:14]];
            [cell.textField.rightButton setPressed:^(id sender, id data) {

            }];

            [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {

            }];
        }
            break;
        case HCell3: {
            itemBlock(nil, HTupleBaseCell.class, nil, YES);
        }
            break;
        case HCell4: {
            HTupleButtonCell *cell = itemBlock(nil, HTupleButtonCell.class, nil, YES);
            [cell.buttonView setBackgroundColor:HColorHex(#CCCCCC)];
            [cell.buttonView setTitle:@"登录"];
            [cell.buttonView setPressed:^(id sender, id data) {
                /*
                HTupleTextFieldCell *tfCell1 = self.tupleView.cell(1, 0);
                HTupleTextFieldCell *tfCell2 = self.tupleView.cell(3, 0);
                HTupleTextFieldCell *tfCell3 = self.tupleView.cell(5, 0);

                if ([tfCell1.textField validate] && tfCell2.textField.text > 0 && tfCell3.textField.text > 0) {

                }
                */
            }];

            [cell setSignalBlock:^(HTupleButtonCell *cell, HTupleSignal *signal) {

            }];
        }
            break;
        case HCell5: {

            HServiceAuthorizationCell *cell = itemBlock(nil, HServiceAuthorizationCell.class, nil, YES);

            [cell setServiceAgreementBlock:^{

            }];

            [cell setSignalBlock:^(HServiceAuthorizationCell *cell, HTupleSignal *signal) {
                if (cell.isAuthorized) {

                }
            }];

        }
            break;
        default: {
            itemBlock(nil, HTupleBaseCell.class, nil, YES);
        }
            break;
    }
}

@end
