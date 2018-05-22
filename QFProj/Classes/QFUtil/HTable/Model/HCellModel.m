//
//  HCellModel.m
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HCellModel.h"

@implementation HCellModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _height = UITableViewAutomaticDimension;
    }
    return self;
}

@end
