//
//  HLoginController.m
//  QFProj
//
//  Created by wind on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HLoginController.h"

@interface HLoginController ()

@end

@implementation HLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"登录"];
    [self loadData];
}

- (void)loadData {
    [self.tupleView tupleWithSections:^CGFloat{
        return 1;
    } items:^CGFloat(NSInteger section) {
        return 6;
    } color:^UIColor * _Nullable(NSInteger section) {
        return nil;
    } inset:^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    }];
    
    [self.tupleView itemWithSize:^CGSize(NSIndexPath * _Nonnull indexPath) {
        switch (indexPath.row) {
            case 0:return CGSizeMake(self.tupleView.width, 60);
            case 1:return CGSizeMake(self.tupleView.width, 60);
            case 2:return CGSizeMake(self.tupleView.width, 60);
            case 3:return CGSizeMake(self.tupleView.width, 40);
            case 4:return CGSizeMake(self.tupleView.width, 45);
            case 5:return CGSizeMake(self.tupleView.width, 20);
            default:return CGSizeZero;
        }
    } edgeInsets:^UIEdgeInsets(NSIndexPath * _Nonnull indexPath) {
        switch (indexPath.row) {
            case 0:return UIEdgeInsetsMake(15, 0, 0, 0);
            case 1:return UIEdgeInsetsMake(15, 0, 0, 0);
            case 2:return UIEdgeInsetsMake(15, 0, 0, 0);
            case 3:return UIEdgeInsetsMake(0, 15, 0, 15);
            case 4:return UIEdgeInsetsMake(0, 15, 0, 15);
            case 5:return UIEdgeInsetsMake(5, 15, 0, 0);
            default:return UIEdgeInsetsZero;
        }
    } tuple:^(HItemTuple  _Nonnull itemBlock, NSIndexPath * _Nonnull indexPath) {
        switch (indexPath.row) {
            case 0: {
                HTupleTextFieldCell *cell = itemBlock(nil,HTupleTextFieldCell.class, nil, YES);
                [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                
                [cell.textField.leftLabel setFrame:CGRectMake(0, 0, 80, 60)];
                [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textField.leftLabel setText:@"+86"];
                [cell.textField.leftLabel setFont:[UIFont systemFontOfSize:14]];
                
                [cell.textField setPlaceholder:@"请输入手机号"];
                [cell.textField setTintColor:[UIColor colorWithString:@"#BABABF"]];
                [cell.textField setFont:[UIFont systemFontOfSize:14]];
                //cell.textField.inputValidator = HPhoneValidator.new;
                
                [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {
                    
                }];
            }
                break;
            case 1: {
                HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, nil, YES);
                [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                
                [cell.textField.leftLabel setFrame:CGRectMake(0, 0, 80, 60)];
                [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textField.leftLabel setText:@"昵称"];
                [cell.textField.leftLabel setFont:[UIFont systemFontOfSize:14]];
                
                [cell.textField setPlaceholder:@"请输入昵称"];
                [cell.textField setTintColor:[UIColor colorWithString:@"#BABABF"]];
                [cell.textField setFont:[UIFont systemFontOfSize:14]];
                
                [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {
                    
                }];
            }
                break;
            case 2: {
                HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, nil, YES);
                [cell.textField setBackgroundColor:[UIColor colorWithString:@"#F2F2F2"]];
                
                [cell.textField.leftLabel setFrame:CGRectMake(0, 0, 80, 60)];
                [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textField.leftLabel setText:@"验证码"];
                [cell.textField.leftLabel setFont:[UIFont systemFontOfSize:14]];
                
                [cell.textField setPlaceholder:@"请输入验证码"];
                [cell.textField setTintColor:[UIColor colorWithString:@"#BABABF"]];
                [cell.textField setFont:[UIFont systemFontOfSize:14]];
                //cell.textField.inputValidator = HNumericValidator.new;
                
                [cell.textField.rightButton setFrame:CGRectMake(0, 0, 120, 60)];
                [cell.textField.rightButton.button setTitle:@"获取验证码"];
                [cell.textField.rightButton.button setFont:[UIFont systemFontOfSize:14]];
                [cell.textField.rightButton setPressed:^(id sender, id data) {
                    
                }];
                
                [cell setSignalBlock:^(HTupleTextFieldCell *cell, HTupleSignal *signal) {
                    
                }];
            }
                break;
            case 3: {
                itemBlock(nil, HTupleBaseCell.class, nil, YES);
            }
                break;
            case 4: {
                HTupleButtonCell *cell = itemBlock(nil, HTupleButtonCell.class, nil, YES);
                [cell.buttonView setBackgroundColor:[UIColor colorWithString:@"#CCCCCC"]];
                [cell.buttonView.button setTitle:@"开始"];
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
            case 5: {
                
                HWebButtonView *buttonView = [[HWebButtonView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                [buttonView.button setImage:[UIImage imageNamed:@"dribbble"] forState:UIControlStateNormal];
                [buttonView.button setImage:[UIImage imageNamed:@"dribbble"] forState:UIControlStateSelected];
                [buttonView.button setSelected:!buttonView.button.isSelected];
                [buttonView setPressed:^(HWebButtonView *buttonView, id data) {
                    [buttonView.button setSelected:!buttonView.button.isSelected];
                }];
                
                NSMutableAttributedString *attributedString = [NSMutableAttributedString h_attachmentStringWithContent:buttonView contentMode:UIViewContentModeScaleAspectFit attachmentSize:buttonView.frame.size  alignToFont:[UIFont systemFontOfSize:14] alignment:HTextVerticalAlignmentCenter];
                
                NSString *string1 = @"点击开始,即表示已阅读并同意";
                NSString *string2 = @"《服务协议》";

                [attributedString h_appendString:string1];
                [attributedString h_appendString:string2];
                
                [attributedString h_setColor:[UIColor colorWithString:@"#BABABF"] range:NSMakeRange(0, string1.length)];
                [attributedString h_setColor:[UIColor colorWithString:@"#34BDD7"] range:NSMakeRange(string1.length, string2.length)];
                //设置点击
                HTextHighlight *highlight = [HTextHighlight new];
                highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {

                };
                [attributedString h_setTextHighlight:highlight range:NSMakeRange(string1.length, string2.length)];

                HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
                [cell.label setFont:[UIFont systemFontOfSize:12]];
                [cell.label setTextAlignment:NSTextAlignmentCenter];
                cell.label.attributedText = attributedString;
                
                
                [cell setSignalBlock:^(HTupleLabelCell *cell, HTupleSignal *signal) {
                    
                }];
                
            }
                break;
            default: {
                itemBlock(nil, HTupleBaseCell.class, nil, YES);
            }
                break;
        }
    }];
}

@end
