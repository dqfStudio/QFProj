//
//  HRegisterController+KS.m
//  QFProj
//
//  Created by wind on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRegisterController+KS.h"

@interface HRegisterController ()

@end

@implementation HRegisterController (KS)
- (NSInteger)tuple0_numberOfSectionsIntupleView:(HTupleView *)tupleView {
    return 3;
}
- (NSInteger)tuple0_tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return 6;
        case 2: return 1;
        default:break;
    }
    return 0;
}

- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeMake(tupleView.width, 10);
        case 1: return CGSizeMake(tupleView.width, 5);
        case 2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeZero;
        case 1: return CGSizeMake(tupleView.width, 15);
        case 2: return CGSizeZero;
        default:return CGSizeZero;
    }
}
- (CGSize)tuple0_tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return CGSizeMake(tupleView.width, 55);
        case 1: return CGSizeMake(tupleView.width, 25);
        case 2: return CGSizeMake(tupleView.width, 55);
        default: return CGSizeZero;
    }
}

- (UIEdgeInsets)tuple0_tupleView:(HTupleView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple0_tupleView:(HTupleView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple0_tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2: return UIEdgeInsetsMake(0, 60, 0, 60);
        default: return UIEdgeInsetsZero;
    }
}

- (UIEdgeInsets)tuple0_tupleView:(HTupleView *)tupleView insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)tuple0_tupleView:(HTupleView *)tupleView headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple0_tupleView:(HTupleView *)tupleView footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple0_tupleView:(HTupleView *)tupleView itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self tuple_tupleView:tupleView itemTuple:itemBlock atIndexPath:indexPath];
    }else {
//        switch (indexPath.section) {
//            case 0: {
//                switch (indexPath.row) {
//                    case 0: {
//                        HTupleRegisterStyle1Cell *cell = itemBlock(HTupleRegisterStyle1Cell.class, @"KS");
//                        [cell setCellText:@"推荐码(非必填)"];
//                        [cell setCellIcon:@"login_tjm"];
//                        [cell setKeyboardType:UIKeyboardTypeASCIICapable];
//                        [cell setInputLimit:15];
//                        @weakify(cell)
//                        [cell setSignalBlock:^(HTupleSignal *signal) {
//                            @strongify(cell)
//                            HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//                            if (tfCell.textField.text.length > 0) {
//                                if (![HValidate isValidateReferralCode:tfCell.textField.text]) {
//                                    [HProgressHUD showErrorWithStatus:@"请输入4-15位英文数字组合的推荐码!"];
//                                    HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                                    [btnCell.button.button setEnabled:YES];
//                                } else {
//                                    self.registerDict[@"referralCode"] = tfCell.textField.text;
//                                    [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//                                }
//                            } else {
//                                [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//                            }
//                        }];
//                    }
//                        break;
//                    case 1: {
//                        HTupleRegisterStyle1Cell *cell = itemBlock(HTupleRegisterStyle1Cell.class, @"KS");
//                        [cell setCellText:@"用户名"];
//                        [cell setCellIcon:@"login_name"];
//                        [cell setKeyboardType:UIKeyboardTypeASCIICapable];
//                        [cell setInputLimit:11];
//                        @weakify(cell)
//                        [cell setSignalBlock:^(HTupleSignal *signal) {
//                            @strongify(cell)
//                            HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//                            NSString *userName = tfCell.textField.text;
//                            userName = userName.replace(@" ", @"");
//
//                            if (![HValidate isValidateAlphaNumeric:userName] || userName.length < 5 || userName.length > 11) {
//                                [HProgressHUD showErrorWithStatus:@"用户名为5-11位字母,数字组成"];
//                                HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                                [btnCell.button.button setEnabled:YES];
//                            }else {
//                                self.registerDict[@"userName"] = userName;
//                                [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                            }
//                        }];
//                    }
//                        break;
//                    case 2: {
//                        HTupleRegisterStyle1Cell *cell = itemBlock(HTupleRegisterStyle1Cell.class, @"KS");
//                        [cell setCellText:@"密码"];
//                        [cell setCellIcon:@"login_pass"];
//                        [cell setKeyboardType:UIKeyboardTypeASCIICapable];
//                        [cell setSecureTextEntry:YES];
//                        [cell setInputLimit:12];
//                        @weakify(cell)
//                        [cell setSignalBlock:^(HTupleSignal *signal) {
//                            @strongify(cell)
//                            HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//                            NSString *passWord = tfCell.textField.text;
//                            passWord = passWord.replace(@" ", @"");
//
//                            if (![HValidate isValidatePass:passWord]) {
//                                [HProgressHUD showErrorWithStatus:@"密码为6-12位字母,数字组成"];
//                                HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                                [btnCell.button.button setEnabled:YES];
//                            }else {
//                                self.registerDict[@"passWord"] = passWord;
//                                self.registerDict[@"repassWord"] = passWord;
//                                [HUserDefaults defaults].password = passWord;
//                                [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//                            }
//                        }];
//                    }
//                        break;
//                    case 3: {
//                        HTupleRegisterStyle1Cell *cell = itemBlock(HTupleRegisterStyle1Cell.class, @"KS");
//                        [cell setCellText:@"微信"];
//                        [cell setCellIcon:@"reg_Wechat"];
//                        @weakify(cell)
//                        [cell setSignalBlock:^(HTupleSignal *signal) {
//                            @strongify(cell)
//                            HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//                            if (tfCell.textField.text.length == 0) {
//                                [HProgressHUD showErrorWithStatus:@"请输入微信号"];
//                                HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                                [btnCell.button.button setEnabled:YES];
//                            }else {
//                                NSString *remark = [NSString stringWithFormat:@"weixin:%@",tfCell.textField.text];
//                                self.registerDict[@"remark"] = remark;
//                                [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
//                            }
//                        }];
//                    }
//                        break;
//                    case 4: {
//                        HTupleRegisterStyle1Cell *cell = itemBlock(HTupleRegisterStyle1Cell.class, @"KS");
//                        [cell setCellText:@"手机号"];
//                        [cell setCellIcon:@"reg_phone"];
//                        [cell setKeyboardType:UIKeyboardTypeNumberPad];
//                        [cell setInputLimit:11];
//                        @weakify(cell)
//                        [cell setSignalBlock:^(HTupleSignal *signal) {
//                            @strongify(cell)
//                            HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//                            if (![HValidate isValidateMobile:tfCell.textField.text]) {
//                                [HProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
//                                HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                                [btnCell.button.button setEnabled:YES];
//                            }else {
//                                self.registerDict[@"mobileNo"] = tfCell.textField.text;
//                                [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
//                            }
//                        }];
//                    }
//                        break;
//                    case 5: {
//                        HTupleRegisterStyle2Cell *cell = itemBlock(HTupleRegisterStyle2Cell.class, @"KS");
//                        [cell setCellText:@"验证码"];
//                        [cell setCellIcon:@"reg_yzm"];
//                        [cell setKeyboardType:UIKeyboardTypeNumberPad];
//                        @weakify(cell)
//                        [cell setSignalBlock:^(HTupleSignal *signal) {
//                            @strongify(cell)
//                            HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//                            HViewCell *viewCell = cell.tupleView.cell(2, 0);
//
//                            PooCodeView *codeView = [viewCell viewWithTag:111];
//                            if (![tfCell.textField.text isEqualToString:codeView.changeString]) {
//                                [HProgressHUD showErrorWithStatus:@"请输入正确的验证码"];
//                                HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                                [btnCell.button.button setEnabled:YES];
//                            }else {
//                                [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//                            }
//                        }];
//                    }
//                        break;
//
//                    default:
//                        break;
//                }
//            }
//                break;
//            case 1: {
//                HTupleRegisterStyle3Cell *cell = itemBlock(HTupleRegisterStyle3Cell.class, @"KS");
//                [cell setCellBlock:^(NSIndexPath *idxPath) {
//                    if (idxPath.row == 1) {
//                        HServiceAgreementVC *vc = HServiceAgreementVC.new;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                }];
//                @weakify(cell)
//                [cell setSignalBlock:^(HTupleSignal *signal) {
//                    @strongify(cell)
//                    HButtonViewCell *tfCell = cell.tupleView.cell(0, 0);
//                    if (!tfCell.button.button.selected) {
//                        [HProgressHUD showErrorWithStatus:@"请先同意用户协议"];
//                        HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                        [btnCell.button.button setEnabled:YES];
//                    }else {
//                        [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//                    }
//                }];
//            }
//                break;
//            case 2: {
//                HButtonViewCell *cell = itemBlock(HButtonViewCell.class, @"KS");
//                [cell.button.button setTitle:@"下一步"];
//                [cell.button setCornerRadius:5];
//                [cell.button.layer setMasksToBounds:YES];
//
//                [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
//                    [webButtonView.button setEnabled:NO];
//                    if (self.registerDict.count > 0) {
//                        [self.registerDict removeAllObjects];
//                    }
//                    [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//                }];
//
//                @weakify(cell)
//                @www
//                [cell setSignalBlock:^(HTupleSignal *signal) {
//                    @strongify(cell)
//                    @sss
//                    [self KS_nextStepBtn:cell.button];
//                }];
//            }
//                break;
//
//            default:
//                break;
//        }
    }
}

@end
