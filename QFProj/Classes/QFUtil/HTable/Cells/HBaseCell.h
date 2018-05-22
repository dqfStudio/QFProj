//
//  HBaseCell.h
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCellModel.h"

@interface HBaseCell : UITableViewCell
@property (nonatomic) HCellModel *model;
//子类覆盖
- (void)initUI;

@end
