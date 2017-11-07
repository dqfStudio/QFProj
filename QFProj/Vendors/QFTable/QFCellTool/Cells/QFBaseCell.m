//
//  QFBaseCell.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFBaseCell.h"

@implementation QFBaseCell

+ (id)registerTable:(UITableView *)table {
    return [self registerTable:table initBlock:nil];
}

+ (id)registerTable:(UITableView *)table initBlock:(QFCellInitBlock)block {
    return [self registerTable:table style:UITableViewCellStyleDefault initBlock:block];
}

+ (id)registerTable:(UITableView *)table style:(UITableViewCellStyle)style {
    return [self registerTable:table style:style initBlock:nil];
}

+ (id)registerTable:(UITableView *)table style:(UITableViewCellStyle)style initBlock:(QFCellInitBlock)block {
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    if (!cell) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:NSStringFromClass(self.class)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (block) {
            block(cell);
        }
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) [self initUI];
    return self;
}

//子类覆盖
- (void)initUI {}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
