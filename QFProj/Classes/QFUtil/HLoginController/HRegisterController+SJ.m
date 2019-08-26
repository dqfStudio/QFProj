//
//  HRegisterController+SJ.m
//  QFProj
//
//  Created by wind on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HRegisterController+SJ.h"

@interface HRegisterController ()

@end

@implementation HRegisterController (SJ)
- (NSInteger)tuple1_numberOfSectionsIntupleView:(HTupleView *)tupleView {
    return 3;
}
- (NSInteger)tuple1_tupleView:(HTupleView *)tupleView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return 5;
        case 2: return 1;
        default: return 0;
    }
}

- (CGSize)tuple1_tupleView:(HTupleView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeMake(tupleView.width, 10);
        case 1: return CGSizeMake(tupleView.width, 5);
        case 2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple1_tupleView:(HTupleView *)tupleView sizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: return CGSizeZero;
        case 1: return CGSizeMake(tupleView.width, 15);
        case 2: return CGSizeZero;
        default: return CGSizeZero;
    }
}
- (CGSize)tuple1_tupleView:(HTupleView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return CGSizeMake(tupleView.width, 55);
        case 1: {
            if (indexPath.row == 0) {
                return CGSizeMake(tupleView.width, 55);
            }else if (indexPath.row == 3) {
                return CGSizeMake(tupleView.width-100, 55);
            }else if (indexPath.row == 4) {
                return CGSizeMake(100, 55);
            }
            return CGSizeMake(tupleView.width, 55);
        }
            break;
        case 2: return CGSizeMake(tupleView.width, 55);
        default: return CGSizeZero;
    }
}

- (UIEdgeInsets)tuple1_tupleView:(HTupleView *)tupleView edgeInsetsForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple1_tupleView:(HTupleView *)tupleView edgeInsetsForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (UIEdgeInsets)tuple1_tupleView:(HTupleView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2: {
            if (indexPath.row == 0) {
                return UIEdgeInsetsMake(0, 30, 0, 0);
            }else if (indexPath.row == 4) {
                return UIEdgeInsetsMake(10, 0, 10, 10);
            }
        }
            break;
        default: return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)tuple1_tupleView:(HTupleView *)tupleView insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)tuple1_tupleView:(HTupleView *)tupleView headerTuple:(HTupleHeader)headerBlock inSection:(NSInteger)section {
    headerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple1_tupleView:(HTupleView *)tupleView footerTuple:(HTupleFooter)footerBlock inSection:(NSInteger)section {
    footerBlock(nil, HTupleBaseApex.class, nil, NO);
}
- (void)tuple1_tupleView:(HTupleView *)tupleView itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self tuple_tupleView:tupleView itemTuple:itemBlock atIndexPath:indexPath];
    }else {
        
    }
//    switch (indexPath.section) {
//        case 0: {
//            switch (indexPath.row) {
//                case 0: {
//                    HTextViewCell5 *cell = itemBlock(HTextViewCell5.class, @"SJ");
//                    [cell setBackgroundColor:[UIColor colorWithString:@"#FDF2DC"]];
//                    [cell.label setText:@"手机注册每日随机产生最高999元现金大奖"];
//                    [cell.label setTextColor:[UIColor blackColor]];
//                    [cell.label setTextAlignment:NSTextAlignmentLeft];
//                    [cell.label setFont:[UIFont systemFontOfSize:17]];
//                    [cell.label setKeywords:@"999元"];
//                    [cell.label setKeywordsColor:[UIColor redColor]];
//                    [cell.label formatThatFits];
//                }
//                    break;
//                case 1: {
//                    HTupleRegisterStyle1Cell *cell = itemBlock(HTupleRegisterStyle1Cell.class, @"SJ");
//                    [cell setCellText:@"推荐码(非必填)"];
//                    [cell setCellIcon:@"login_tjm"];
//                    [cell setKeyboardType:UIKeyboardTypeASCIICapable];
//                    [cell setInputLimit:15];
//                    @weakify(cell)
//                    [cell setSignalBlock:^(HTupleSignal *signal) {
//                        @strongify(cell)
//                        HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//                        if (tfCell.textField.text.length > 0) {
//                            if (![HValidate isValidateReferralCode:tfCell.textField.text]) {
//                                [HProgressHUD showErrorWithStatus:@"请输入4-15位英文数字组合的推荐码!"];
//                                HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                                [btnCell.button.button setEnabled:YES];
//                            } else {
//                                self.registerDict[@"referralCode"] = tfCell.textField.text;
//                                [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                            }
//                        } else {
//                            [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                        }
//                    }];
//                }
//                    break;
//                case 2: {
//                    HTupleRegisterStyle1Cell *cell = itemBlock(HTupleRegisterStyle1Cell.class, @"SJ");
//                    [cell setCellText:@"手机号"];
//                    [cell setCellIcon:@"reg_phone"];
//                    [cell setKeyboardType:UIKeyboardTypeNumberPad];
//                    [cell setInputLimit:11];
//                    @weakify(cell)
//                    [cell setSignalBlock:^(HTupleSignal *signal) {
//                        @strongify(cell)
//                        HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//                        if (![HValidate isValidateMobile:tfCell.textField.text]) {
//                            [HProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
//                            HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                            [btnCell.button.button setEnabled:YES];
//                        }else {
//                            self.registerDict[@"mobileNo"] = tfCell.textField.text;
//                            [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//                        }
//                    }];
//                }
//                    break;
//                case 3: {
//                    HTupleRegisterStyle2Cell *cell = itemBlock(HTupleRegisterStyle2Cell.class, @"SJ");
//                    [cell setCellText:@"验证码"];
//                    [cell setCellIcon:@"reg_yzm"];
//                    [cell setIsCodeViewHidden:YES];
//                    [cell setKeyboardType:UIKeyboardTypeNumberPad];
//                    @weakify(cell)
//                    [cell setSignalBlock:^(HTupleSignal *signal) {
//                        @strongify(cell)
//                        HTextFieldCell *tfCell = cell.tupleView.cell(1, 0);
//
//                        if (tfCell.textField.text.length == 0) {
//                            [HProgressHUD showErrorWithStatus:@"请输入正确的验证码"];
//                            HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                            [btnCell.button.button setEnabled:YES];
//                        }else {
//                            self.registerDict[@"msgCode"] = tfCell.textField.text;
//                            [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//                        }
//                    }];
//                }
//                    break;
//                case 4: {
//                    HViewCell *cell = itemBlock(HViewCell.class, @"SJ");
//                    [cell setBottomFillLineWithColor:[HSkinManager lineColor]];
//
//                    JKCountDownButton *btn = [cell.view viewWithTag:1111];
//                    if (!btn) {
//                        btn = [[JKCountDownButton alloc] initWithFrame:cell.view.bounds];
//                        [btn setBackgroundColor:[HSkinManager specialColor]];
//                        [btn setCornerRadius:3];
//                        [btn setBoarderWith:1 color:[HSkinManager specialColor]];
//                        [btn setFont:[UIFont systemFontOfSize:15]];
//                        [btn setTitle:@"发送验证码"];
//                        [btn setTitleColor:[UIColor whiteColor]];
//                        [btn setTag:1111];
//                        [cell.view addSubview:btn];
//                        @weakify(btn)
//                        [btn addSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
//                            @strongify(btn)
//                            HTupleRegisterStyle2Cell *tmpCell = self.tupleView.cell(2, 0);
//                            HTextFieldCell *tfCell = tmpCell.tupleView.cell(1, 0);
//
//                            if (![HValidate isValidateMobile:tfCell.textField.text]) {
//                                [HProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
//                            }else {
//                                [btn setEnabled:NO];
//                                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                                dic[@"cagent"] = kPlatCode;
//                                dic[@"mobileNo"] = tfCell.textField.text;
//                                [[HNetWorkingManager shareManager] sendHTTPDataWithBaseURL:HEADBASEINURL andAppendURL:kRegisterSendChangeCode RequestWay:kPOST withParamters:dic withToken:nil success:^(BOOL isSuccess, id responseObject) {
//                                    if ([[responseObject objectForKey:@"msg"] isEqualToString:@"success"]) {
//                                        [HProgressHUD showSuccessWithStatus:@"验证码发送成功！"];
//                                        [btn startCountDownWithSecond:60];
//                                        [btn countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
//                                            NSString *title = [NSString stringWithFormat:@"重新获取%zd秒",second];
//                                            return title;
//                                        }];
//                                    }else{
//                                        [btn setEnabled:YES];
//                                        [HProgressHUD showErrorWithStatus:responseObject[@"msg"] ? : @"发送验证码失败!!!"];
//                                    }
//                                } failure:^(NSError *error) {
//                                    [btn setEnabled:YES];
//                                    [HProgressHUD showErrorWithStatus:error.localizedDescription];
//                                }];
//
//                                [btn countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
//                                    countDownButton.enabled = YES;
//                                    return @"重新发送";
//                                }];
//                            }
//                        }];
//                    }
//                }
//                    break;
//
//                default:
//                    break;
//            }
//        }
//            break;
//        case 1: {
//            HTupleRegisterStyle3Cell *cell = itemBlock(HTupleRegisterStyle3Cell.class, @"SJ");
//            [cell setCellBlock:^(NSIndexPath *idxPath) {
//                if (idxPath.row == 1) {
//                    HServiceAgreementVC *vc = HServiceAgreementVC.new;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//            }];
//            @weakify(cell)
//            [cell setSignalBlock:^(HTupleSignal *signal) {
//                @strongify(cell)
//                HButtonViewCell *tfCell = cell.tupleView.cell(0, 0);
//                if (!tfCell.button.button.selected) {
//                    [HProgressHUD showErrorWithStatus:@"请先同意用户协议"];
//                    HButtonViewCell *btnCell = self.tupleView.cell(0, 2);
//                    [btnCell.button.button setEnabled:YES];
//                }else {
//                    [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//                }
//            }];
//        }
//            break;
//        case 2: {
//            HButtonViewCell *cell = itemBlock(HButtonViewCell.class, @"SJ");
//            [cell.button setBackgroundColor:[HSkinManager specialColor]];
//            [cell.button.button setTitle:@"下一步"];
//            [cell.button setCornerRadius:5];
//            [cell.button.layer setMasksToBounds:YES];
//
//            [cell setButtonViewBlock:^(HWebButtonView *webButtonView, HButtonViewCell *buttonCell) {
//                [webButtonView.button setEnabled:NO];
//                if (self.registerDict.count > 0) {
//                    [self.registerDict removeAllObjects];
//                }
//                [self.tupleView signal:nil indexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//            }];
//
//            @weakify(cell)
//            @www
//            [cell setSignalBlock:^(HTupleSignal *signal) {
//                @strongify(cell)
//                @sss
//                [self SJ_nextStepBtn:cell.button];
//            }];
//        }
//            break;
//
//        default:
//            break;
//    }
}

@end
