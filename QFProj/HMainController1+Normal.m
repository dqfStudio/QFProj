//
//  HMainController1+Normal.m
//  QFProj
//
//  Created by dqf on 2020/3/18.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HMainController1+Normal.h"

@implementation HMainController1 (Normal)

- (NSInteger)tuple1_numberOfSectionsInTupleView {
    return 1;
}
- (NSInteger)tuple1_numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (UIEdgeInsets)tuple1_insetForSection:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UIColor *)tuple1_colorForSection:(NSInteger)section {
    return UIColor.redColor;
}
- (CGSize)tuple1_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0:
        case HCell1:
        case HCell2:
            return CGSizeMake(self.tupleView.sectionWidth(indexPath.section), 65);
            break;
        case HCell3:
        case HCell4:
        case HCell5: {
            CGFloat width = self.tupleView.sectionWidth(indexPath.section);
            width = [self.tupleView fixSlitWith:width colCount:3 index:indexPath.row-3];
            return CGSizeMake(width, 120);
        }
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.tupleView.sectionWidth(indexPath.section), 65);
}
- (UIEdgeInsets)tuple1_edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell3:
            return UIEdgeInsetsMake(10, 10, 10, 5);
        case HCell4:
            return UIEdgeInsetsMake(10, 5, 10, 5);
        case HCell5:
            return UIEdgeInsetsMake(10, 5, 10, 10);
        default:
            break;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)tuple1_tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HCell0: {
            HTupleViewCellHoriValue4 *cell = itemBlock(nil, HTupleViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];

            [cell.detailView setBackgroundColor:UIColor.redColor];
            [cell.detailView setImageWithName:@"icon_no_server"];
            
            cell.showAccessoryArrow = YES;
            
            [cell.label setBackgroundColor:UIColor.redColor];
            [cell.label setText:@"label"];
            
            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
            [cell.detailLabel setText:@"detailLabel"];

            [cell.accessoryLabel setBackgroundColor:UIColor.greenColor];
            [cell.accessoryLabel setText:@"accessoryLabel"];
            
            //接收信号
            [cell setSignalBlock:^(HTupleViewCellHoriValue4 *cell, HTupleSignal *signal) {
                
            }];
        }
            break;
        case HCell1: {
            HTupleViewCellHoriValue4 *cell = itemBlock(nil, HTupleViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            
            [cell.label setBackgroundColor:UIColor.redColor];

            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
            
            //接收信号
            [cell setSignalBlock:^(HTupleViewCellHoriValue4 *cell, HTupleSignal *signal) {
                
            }];
            
            //发送信号
            //[self.tupleView signal:nil toRow:HCell0 inSection:HSection0];
        }
            break;
        case HCell2: {
            HTupleViewCellHoriValue4 *cell = itemBlock(nil, HTupleViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];

            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];

            [cell.detailView setBackgroundColor:UIColor.redColor];
            [cell.detailView setImageWithName:@"icon_no_server"];

            [cell.label setBackgroundColor:UIColor.redColor];

            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
        }
            break;
        case HCell3: {
            HTupleViewCellVertValue1 *cell = itemBlock(nil, HTupleViewCellVertValue1.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 0)];
            
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            [cell.imageView setFillet:YES];
            
            cell.labelHeight = 25;
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"黑客帝国"];
        }
            break;
        case HCell4: {
            HTupleViewCellVertValue1 *cell = itemBlock(nil, HTupleViewCellVertValue1.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            [cell.imageView setFillet:YES];
            
            cell.labelHeight = 25;
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"黑客帝国"];
        }
            break;
        case HCell5: {
            HTupleViewCellVertValue1 *cell = itemBlock(nil, HTupleViewCellVertValue1.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(0, 10)];

            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            [cell.imageView setFillet:YES];

            cell.labelHeight = 25;
            [cell.label setTextAlignment:NSTextAlignmentCenter];
            [cell.label setText:@"黑客帝国"];

            cell.didSelectCell = ^(HTupleViewCellVertValue1 *cell, NSIndexPath *indexPath) {
                [self presentViewController:HLiveRoomVC.new animated:YES completion:nil];
            };
        }
            break;
        case HCell6: {
            HTupleViewCellHoriValue3 *cell = itemBlock(nil, HTupleViewCellHoriValue3.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UILREdgeInsetsMake(10, 10)];
            
            cell.detailWidth  = CGRectGetWidth(cell.layoutViewBounds)/3;
            cell.accessoryWidth = CGRectGetWidth(cell.layoutViewBounds)/3;
            [cell.label setBackgroundColor:UIColor.greenColor];
            [cell.label setText:@"label"];
            [cell.label setTextAlignment:NSTextAlignmentCenter];

            [cell.detailLabel setBackgroundColor:UIColor.redColor];
            [cell.detailLabel setText:@"detailLabel"];
            [cell.detailLabel setTextAlignment:NSTextAlignmentCenter];
            
            [cell.accessoryLabel setBackgroundColor:UIColor.yellowColor];
            [cell.accessoryLabel setText:@"accessoryLabel"];
            [cell.accessoryLabel setTextAlignment:NSTextAlignmentCenter];
        }
            break;
        case HCell7: {
            HTupleTextFieldCell *cell = itemBlock(nil, HTupleTextFieldCell.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell.textField setBackgroundColor:UIColor.redColor];
            
            cell.textField.leftWidth = 50;
            [cell.textField.leftLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textField.leftLabel setText:@"验证码"];
            [cell.textField.leftLabel setBackgroundColor:UIColor.greenColor];
            
            [cell.textField setPlaceholder:@"请输入验证码"];
            [cell.textField setPlaceholderColor:[UIColor whiteColor]];
            [cell.textField setTextColor:[UIColor whiteColor]];
            
            cell.textField.rightWidth = 90;
            //普通view
//            [cell.textField.rightButton setTitle:@"获取验证码"];
//            [cell.textField.rightButton setBackgroundColor:UIColor.greenColor];
//            [cell.textField.rightButton setPressed:^(id sender, id data) {
//
//            }];
            //短信验证码
            [cell.textField.rightCountDownButton setTitle:@"获取验证码"];
            [cell.textField.rightCountDownButton setBackgroundColor:UIColor.greenColor];
            [cell.textField.rightCountDownButton countDownButtonHandler:^(HCountDownButton *countDownButton, NSInteger tag) {
                [countDownButton startCountDownWithSecond:60];
            }];
            [cell.textField.rightCountDownButton countDownChanging:^NSString *(HCountDownButton *countDownButton, NSUInteger second) {
                return [NSString stringWithFormat:@"还剩%lu秒",(unsigned long)second];
            }];
            [cell.textField.rightCountDownButton countDownFinished:^NSString *(HCountDownButton *countDownButton, NSUInteger second) {
                return @"重新获取";
            }];
            //图形验证码
//            [cell.textField.rightVerifyCodeView setBackgroundColor:UIColor.greenColor];
//            cell.textField.rightVerifyCodeView.textSize = 20;
//            cell.textField.rightVerifyCodeView.textColor = [UIColor blackColor];
//            cell.textField.rightVerifyCodeView.charsArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)tuple1_didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
//    [self.view showResult:^(id<HResultProtocol> make) {
//
//    }];
//    [self.view showWaiting:^(id<HWaitingProtocol> make) {
//
//    }];
    [self presentController:HAlertController.new completion:^(HTransitionType transitionType) {
        NSLog(@"");
    }];
    
    /*
    [self presentController:HSheetController.new completion:^(HTransitionType transitionType) {
        NSLog(@"");
    }];
    */
}

@end
