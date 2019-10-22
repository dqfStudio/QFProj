//
//  HMainController6.m
//  QFProj
//
//  Created by wind on 2019/10/22.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HMainController6.h"

@interface HMainController6 ()

@end

@implementation HMainController6

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.leftNaviButton setHidden:YES];
    [self.tableView setTableDelegate:self];
}

- (NSInteger)numberOfSectionsInTableView:(HTableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(HTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(HTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (UIEdgeInsets)tableView:(HTableView *)tableView edgeInsetsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)tableView:(HTableView *)tableView tableCell:(HTableCell)cellBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HTableViewCellHoriValue4 *cell = cellBlock(nil, HTableViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];

            [cell.detailView setBackgroundColor:UIColor.redColor];
            [cell.detailView setImageWithName:@"icon_no_server"];

//            cell.detailWidth = 100;
//            cell.accessoryWidth = 100;
            
            cell.showAccessoryArrow = YES;
            
//            cell.labelInterval = 0;
            
            [cell.label setBackgroundColor:UIColor.redColor];
            [cell.label setText:@"wwwwwwwwwwwwww"];
//            [cell.label setText:@"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"];
//            [cell.label setText:@"wwwwwwwwwwwwwwwwwwww"];
//            [cell.label setText:@"wwwwwwwwwwwwwwwwwww"];
            
            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
            [cell.detailLabel setText:@"qqqqqqqqqqqqq"];
//            [cell.detailLabel setText:@"qqqqqqqqqqqqqqqqqqqqqqqq"];

//            [cell.accessoryLabel setBackgroundColor:UIColor.greenColor];
            
            //接收信号
            [cell setSignalBlock:^(HTableViewCellHoriValue4 *cell, HTableSignal *signal) {
                
            }];
        }
            break;
        case 1: {
            HTableViewCellHoriValue4 *cell = cellBlock(nil, HTableViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];
            
            [cell.label setBackgroundColor:UIColor.redColor];

            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
            
            //接收信号
            [cell setSignalBlock:^(HTableViewCellHoriValue4 *cell, HTableSignal *signal) {
                
            }];
            
            //发送信号
            //[self.TableView signal:nil indexPath:NSIndexPath.getValue(0, 0)];
        }
            break;
        case 2: {
            HTableViewCellHoriValue4 *cell = cellBlock(nil, HTableViewCellHoriValue4.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
//            cell.showAccessoryArrow = YES;

            [cell.imageView setBackgroundColor:UIColor.redColor];
            [cell.imageView setImageWithName:@"icon_no_server"];

            [cell.detailView setBackgroundColor:UIColor.redColor];
            [cell.detailView setImageWithName:@"icon_no_server"];

            [cell.label setBackgroundColor:UIColor.redColor];

            [cell.detailLabel setBackgroundColor:UIColor.yellowColor];
        }
            break;
        case 3: {
            HTableViewCellHoriValue3 *cell = cellBlock(nil, HTableViewCellHoriValue3.class, nil, YES);
            [cell setBackgroundColor:UIColor.grayColor];
            [cell setShouldShowSeparator:YES];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            
            cell.detailWidth  = cell.contentWidth/3;
            cell.accessoryWidth = cell.contentWidth/3;
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
        case 4: {
            HTableTextFieldCell *cell = cellBlock(nil, HTableTextFieldCell.class, nil, YES);
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
            [cell.textField.rightButton setTitle:@"获取验证码"];
            [cell.textField.rightButton setBackgroundColor:UIColor.greenColor];
            [cell.textField.rightButton setPressed:^(id sender, id data) {

            }];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)tableView:(HTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
